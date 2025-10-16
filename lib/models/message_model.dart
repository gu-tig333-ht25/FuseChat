import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String? senderName;
  final String text;
  final DateTime? timestamp;
  final bool isRead;
  final bool aiGenerated;

  Message({
    required this.id,
    required this.senderId,
    this.senderName,
    required this.text,
    this.timestamp,
    required this.isRead,
    this.aiGenerated = false,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'],
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
      isRead: data['isRead'] ?? false,
      aiGenerated: data['aiGenerated'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : FieldValue.serverTimestamp(),
      'isRead': isRead,
      'aiGenerated': aiGenerated,
    };
  }
}
