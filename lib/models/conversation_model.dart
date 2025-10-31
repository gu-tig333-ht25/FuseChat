import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user_model.dart';
import 'message_model.dart';

class Conversation {
  final String id;
  final String name;
  final List<String> participantIds;
  final String lastMessage;
  final DateTime? lastMessageTime;

  final List<User> participants;
  final List<Message> messages;

  const Conversation({
    required this.id,
    required this.name,
    this.participantIds = const [],
    this.lastMessage = '',
    this.lastMessageTime,
    this.participants = const [],
    this.messages = const [],
  });

  // Create from Firestore document
  factory Conversation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Conversation(
      id: doc.id,
      name: data['name'] ?? '',
      participantIds: List<String>.from(data['participants'] ?? []),
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp?)?.toDate(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'participants': participantIds,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime != null
          ? Timestamp.fromDate(lastMessageTime!)
          : FieldValue.serverTimestamp(),
    };
  }

  // Create a copy with updated fields
  Conversation copyWith({
    String? id,
    String? name,
    List<String>? participantIds,
    String? lastMessage,
    DateTime? lastMessageTime,
    List<User>? participants,
    List<Message>? messages,
  }) {
    return Conversation(
      id: id ?? this.id,
      name: name ?? this.name,
      participantIds: participantIds ?? this.participantIds,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
    );
  }
}

class ConversationFilterState extends ChangeNotifier {
  String _filter = "";

  set filter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  String get filter => _filter;
}
