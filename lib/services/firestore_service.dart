import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Conversation>> getConversations(String userId) {
    return _db
        .collection('conversations')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Conversation.fromFirestore(doc))
            .toList());
  }

  Stream<List<Message>> getMessages(String conversationId) {
    return _db
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
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

    final batch = _db.batch();

    batch.set(messageRef, {
      'senderId': senderId,
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
}