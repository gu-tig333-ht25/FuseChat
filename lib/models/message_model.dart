import 'user_model.dart';

class Message {
  final String id;
  final User sender;
  final String text;
  final DateTime timestamp;
  final bool ai_generated;

  const Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.ai_generated = false
  });
}
