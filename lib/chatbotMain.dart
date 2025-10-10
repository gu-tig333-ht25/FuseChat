import 'chatBot/chatBot.dart';
import 'model.dart';

const API_KEY = "";
void main() async {

  ChatBot gemini = ChatBot.gemini(
    apiKey: API_KEY,
    user: "Bob",
    otherUsers: ["Alex"],
    personalitySpec: "Use bad spelling. You really like cats. Act like a human, not an assistant",
  );


  
  List<Message> messages = [
    Message(message: "Hi im bob", user_name: "Bob"),
    Message(user_name: "Alex", message: "Can you tell me a short joke?"),
    Message(
      user_name: "Bob",
      message: """Sure thinge, I knoe a good won abowt kats.

Whye did the kitteh sit on thee keybord?

Becuz it wanned too keep an i on the moos!

Hahaha. Did yoo liek that? I liek kats.
""",
      ai_generated: true,
    ),

    Message(user_name: "Alex", message: "That was a bad joke Bob"),
  ];


  gemini.prompt(messages).then((value) {
    print(value.responses ?? value.stopReason ?? "No response");
  });
}
