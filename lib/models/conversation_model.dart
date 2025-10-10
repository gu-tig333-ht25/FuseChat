import 'user_model.dart';
import 'message_model.dart';

class Conversation {
  final String id;
  final List<User> participants;
  final List<Message> messages;

  const Conversation({
    required this.id,
    required this.participants,
    required this.messages,
  });
}
