import 'package:flutter_gemini/flutter_gemini.dart';
import '../model.dart';

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

  """;
}

class PromptResponse {
  final String? responses;
  final String? stopReason;
  PromptResponse(this.responses, this.stopReason);
}

abstract class Proptable {
  Future<PromptResponse> prompt(
    List<ChatBotMessage> chat,
    String system_prompt,
  );
}

class ChatBot {
  final String Function(
    String user,
    List<String> otherUsers,
    String Function(String userName, String message),
  )
  baseSystemPrompt;
  final String Function(String userName, String message) formatUserMessage;
  String personalitySpec;
  final List<String> otherUsers;
  final String user;
  final Proptable prompter;

  ChatBot({
    required this.prompter,
    required this.personalitySpec,
    required this.user,
    required this.otherUsers,
    this.formatUserMessage = bracketFormat,
    this.baseSystemPrompt = basicBaseSystemPrompt,
  });

  ChatBot.gemini({
    required String apiKey,
    required this.personalitySpec,
    required this.user,
    required this.otherUsers,
    this.formatUserMessage = bracketFormat,
    this.baseSystemPrompt = basicBaseSystemPrompt,
  }) : this.prompter = GemeniPromparble(apiKey);

  Future<PromptResponse> prompt(List<Message> chat) {
    String systemPrompt =
        baseSystemPrompt(user, otherUsers, formatUserMessage) + personalitySpec;
    List<ChatBotMessage> chatBotMessages = [];
    String userMessage = "";

    chat.forEach((m) {
      if (m.ai_generated && m.user_name == user) {
        if (userMessage != "") {
          chatBotMessages.add(ChatBotMessage(Role.user, userMessage));
        }
        chatBotMessages.add(ChatBotMessage(Role.model, m.message));
        userMessage = "";
      } else {
        userMessage =
            """$userMessage
        ${formatUserMessage(m.user_name, m.message)}
        """;
      }
    });
    if (userMessage != "") {
        chatBotMessages.add(ChatBotMessage(Role.user, userMessage));
    }

    return prompter.prompt(chatBotMessages, systemPrompt);
  }
}

class GemeniPromparble implements Proptable {
  GemeniPromparble(String apiKey) : super() {
    Gemini.init(apiKey: apiKey);
  }

  @override
  Future<PromptResponse> prompt(
    List<ChatBotMessage> chat,
    String systemPrompt,
  ) async {
    Candidates? candidates = await Gemini.instance.chat(
      chat
          .map((m) => Content(role: m.role.name, parts: [Part.text(m.message)]))
          .toList(),
      generationConfig: GenerationConfig(
        maxOutputTokens: 500,
        temperature: 0.9,
      ),
      systemPrompt: systemPrompt,
    );
    if (candidates?.output == null) {
      return PromptResponse(null, "Gemeni prompt process failed");
    }
    return PromptResponse(candidates?.output, null);
  }
}


