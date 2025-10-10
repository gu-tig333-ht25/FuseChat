class Message {
  final bool ai_generated;
  final String user_name;
  final String message;
  const Message({
    this.ai_generated = false,
    required this.user_name,
    required this.message,
  });
}