import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final Map<String, String> _nameCache = {};

  Stream<List<Conversation>> getConversations(String userId) {
    return _db
        .collection('conversations')
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Conversation.fromFirestore(doc))
              .toList(),
        );
  }

  // get amount of conversations
  Stream<int> getAmountConversations(String userId) {
    return getConversations(
      userId,
    ).map((conversations) => conversations.length);
  }

  Stream<int> getAmountMessages(String userId) {
    return _db.collection('conversations').snapshots().switchMap((snapshot) {
      final messageStreams = snapshot.docs.map((doc) {
        return doc.reference
            .collection('messages')
            .where('senderId', isEqualTo: userId)
            .snapshots()
            .map((msgSnap) => msgSnap.docs.length);
      }).toList();

      if (messageStreams.isEmpty) {
        return Stream.value(0);
      }

      return Rx.combineLatestList<int>(
        messageStreams,
      ).map((counts) => counts.fold<int>(0, (s, c) => s + c));
    });
  }

  // Get a single conversation by ID
  Future<Conversation?> getConversation(String conversationId) async {
    try {
      final doc = await _db
          .collection('conversations')
          .doc(conversationId)
          .get();
      if (doc.exists) {
        return Conversation.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Stream for a single conversation
  Stream<Conversation?> getConversationStream(String conversationId) {
    return _db
        .collection('conversations')
        .doc(conversationId)
        .snapshots()
        .map((doc) => doc.exists ? Conversation.fromFirestore(doc) : null);
  }

  Stream<List<Message>> getMessages(String conversationId) {
    return _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList(),
        );
  }

  // Get sender name with caching
  Future<String> _getSenderName(String userId) async {
    if (_nameCache.containsKey(userId)) {
      return _nameCache[userId]!;
    }

    try {
      final userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data() ?? {};
        String name = (data['name'] ?? '').trim();
        final email = (data['email'] ?? '').trim();

        if (name.isEmpty) {
          name = email.split('@').first;
        }

        final currentName = (data['name'] ?? '').toString().trim();
        if (currentName.isEmpty && name.isNotEmpty) {
          await _db.collection('users').doc(userId).update({'name': name});
        }
        _nameCache[userId] = name;
        return name;
      }
    } catch (e) {
      // Fallback to default if user document doesn't exist
    }

    return 'User';
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String text,
  }) async {
    final messageRef = _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc();

    // Get sender name
    final senderName = await _getSenderName(senderId);

    final batch = _db.batch();

    batch.set(messageRef, {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    batch.update(_db.collection('conversations').doc(conversationId), {
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<String> createConversation({
    required List<String> participantIds,
    required String name,
  }) async {
    final convRef = _db.collection('conversations').doc();

    await convRef.set({
      'name': name,
      'participants': participantIds,
      'lastMessage': '',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });

    return convRef.id;
  }

  Stream<User> getUser(String userId) => _db
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((event) => User.fromFirestore(event));

  Future<bool> setUsername(String userId, String newName) async {
    try {
      await _db.collection('users').doc(userId).update({'name': newName});
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<String> getUserName(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return 'User';

          final data = doc.data() ?? {};
          String name = (data['name'] ?? '').trim();
          final email = (data['email'] ?? '').trim();

          if (name.isEmpty && email.isNotEmpty) {
            name = email.split('@').first;
          }

          _nameCache[userId] = name.isNotEmpty ? name : 'User';
          return _nameCache[userId]!;
        })
        .handleError((error) {
          return 'User';
        });
  }

  Stream<Conversation?> getConversationForLLM(String conversationId) async* {
    try {
      final conversationDocStream = _db
          .collection('conversations')
          .doc(conversationId)
          .snapshots();

      await for (final conversationSnapshot in conversationDocStream) {
        if (!conversationSnapshot.exists) {
          yield null;
          continue;
        }

        final conversation = Conversation.fromFirestore(conversationSnapshot);

        final messagesStream = _db
            .collection('conversations')
            .doc(conversationId)
            .collection('messages')
            .orderBy('timestamp')
            .snapshots()
            .map((messagesSnapshot) {
              final messages = messagesSnapshot.docs
                  .map((doc) => Message.fromFirestore(doc))
                  .toList();

              return conversation.copyWith(messages: messages);
            });

        yield* messagesStream;
      }
    } catch (e) {
      yield null;
    }
  }

  Future<List<Map<String, dynamic>>> getMessagesForLLM(
    String conversationId,
  ) async {
    try {
      final messagesSnapshot = await _db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp')
          .get();

      return messagesSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'sender': data['senderName'] ?? 'Unknown',
          'senderId': data['senderId'],
          'message': data['text'],
          'timestamp': data['timestamp'],
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
