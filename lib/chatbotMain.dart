import 'package:template/models/conversation_model.dart';

import 'chatBot/chatBot.dart';

import 'data/dummy_conversation_data.dart';

void main() async {
  Gemeni gemini = Gemeni("");

  Conversation conv = dummyConversations[0];

  prompt(
    prompter: gemini,
    chat: conv.messages,
    user: currentUser.name,
    otherUsers: conv.participants.map((e) => e.name,).where((element) => element != currentUser.name,).toList(),
    personalitySpec:
        "Use bad spelling. You really like cats. Act like a human, not an assistant",
  ).then((value) {
    print(value.responses ?? value.stopReason ?? "No response");
  });
}
