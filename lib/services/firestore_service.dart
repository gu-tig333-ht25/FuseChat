import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

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
      print('Error getting conversation: $e');
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

        // If name is empty, derive from email
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
      print('Error fetching user name: $e');
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

  Future<User> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return User.fromFirestore(doc);
  }

  Future<String> getUserName(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (!doc.exists) return 'User';

      final data = doc.data() ?? {};
      String name = (data['name'] ?? '').trim();
      final email = (data['email'] ?? '').trim();

      // Derive name from email if missing
      if (name.isEmpty && email.isNotEmpty) {
        name = email.split('@').first;
      }

      // Cache result
      _nameCache[userId] = name.isNotEmpty ? name : 'User';
      return _nameCache[userId]!;
    } catch (e) {
      print('Error getting user name: $e');
      return 'User';
    }
  }

  // Get conversation with messages for LLM
  Future<Conversation?> getConversationForLLM(String conversationId) async {
    try {
      final conversation = await getConversation(conversationId);
      if (conversation == null) return null;

      final messagesSnapshot = await _db
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp')
          .get();

      final messages = messagesSnapshot.docs
          .map((doc) => Message.fromFirestore(doc))
          .toList();

      // Use copyWith to add messages to existing conversation
      return conversation.copyWith(messages: messages);
    } catch (e) {
      print('Error getting conversation for LLM: $e');
      return null;
    }
  }

  // Helper to get messages formatted for LLM
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
      print('Error getting messages for LLM: $e');
      return [];
    }
  }
}
