import 'package:flutter_gemini/flutter_gemini.dart';
import '../models/message_model.dart';

enum Role { user, model }

class ChatBotMessage {
  final Role role;
  final String message;
  ChatBotMessage(this.role, this.message);
}

String bracketFormat(String userName, String message) {
  return "[$userName] $message";
}

String basicBaseSystemPrompt(
  String user,
  List<String> otherUsers,
  String Function(String userName, String message) formatUserMessage,
) {
  return """You are $user, and are in a conversation with ${otherUsers.join(", ")}.
If you see:
  ${formatUserMessage(otherUsers[0], "How are you $user")}
Then you should give an answer based on the message and previous messages.
Like this:
  Good
Not like this:
  ${formatUserMessage(user, "Good")}
Always give a text answer as if you are sending another message.
  """;
}

class PromptResponse {
  final String? responses;
  final String? stopReason;
  PromptResponse(this.responses, this.stopReason);
}

abstract class Promptable {
  Future<PromptResponse> prompt(List<ChatBotMessage> chat, String systemPrompt);
}

Future<PromptResponse> prompt({
  required Promptable prompter,
  required List<Message> chat,
  required String user,
  required List<String> otherUsers,
  required String personalitySpec,
  String Function(
        String user,
        List<String> otherUsers,
        String Function(String userName, String message),
      )
      baseSystemPrompt =
      basicBaseSystemPrompt,
  String Function(String userName, String message) formatUserMessage =
      bracketFormat,
}) {
  String systemPrompt =
      baseSystemPrompt(user, otherUsers, formatUserMessage) + personalitySpec;
  List<ChatBotMessage> chatBotMessages = [];
  String userMessage = "";

  for (var m in chat) {
    if (m.ai_generated && m.sender.name == user) {
      if (userMessage != "") {
        chatBotMessages.add(ChatBotMessage(Role.user, userMessage));
      }
      chatBotMessages.add(ChatBotMessage(Role.model, m.text));
      userMessage = "";
    } else {
      userMessage =
          """$userMessage
        ${formatUserMessage(m.sender.name, m.text)}
        """;
    }
  }
  if (userMessage != "") {
    chatBotMessages.add(ChatBotMessage(Role.user, userMessage));
  }

  return prompter.prompt(chatBotMessages, systemPrompt);
}

class Gemeni implements Promptable {
  Gemeni(String apiKey) : super() {
    Gemini.init(apiKey: apiKey);
  }

  @override
  Future<PromptResponse> prompt(
    List<ChatBotMessage> chat,
    String systemPrompt,
  ) async {
    List<Content> contentChat = chat
        .map((m) => Content(role: m.role.name, parts: [Part.text(m.message)]))
        .toList();
    Candidates? candidates = await Gemini.instance.chat(
      contentChat,
      generationConfig: GenerationConfig(
        maxOutputTokens: 5000,
        temperature: 0.9,
      ),
      systemPrompt: systemPrompt,
    );
    
    return PromptResponse(candidates?.output, candidates?.finishReason);
  }
}
