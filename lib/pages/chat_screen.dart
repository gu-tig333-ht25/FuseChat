import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:template/chatBot/chatBot.dart';
import 'package:template/models/AI_model.dart';
import 'package:template/models/conversation_model.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/dummy_conversation_data.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/message_model.dart';

// 2do
// Add references to Firebase, get current user, send messages to Firestore, and get messages from Firestore
// Add LLM suggestions
// ...
// Fix spacing between messages etc.
// Set chat title based on conversation
// auto focus to text field https://docs.flutter.dev/cookbook/forms/focus

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.chatTitle,
  });

  final String conversationId;
  final String chatTitle;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}



class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  @override
  Widget build(context) {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(widget.chatTitle)),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: MessagesStream(
                conversationId: widget.conversationId,
                currentUserId: currentUserId,
              ),
            ),
            Card(
              color: Color(0xFF303030),
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: AISuggestionBox(conv: Provider.of<FirestoreService>(context).getMessages(widget.conversationId)),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      controller: messageTextController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                      ),
                      onSubmitted: (String text) async {
                        if (text.trim().isEmpty) return;

                        final firestoreService =
                            Provider.of<FirestoreService>(context, listen: false);

                        await firestoreService.sendMessage(
                          conversationId: widget.conversationId,
                          senderId: currentUserId,
                          text: text,
                        );

                        messageTextController.clear();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    super.key,
    required this.conversationId,
    required this.currentUserId,
  });

  final String conversationId;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final ScrollController listScrollController = ScrollController();

    return StreamBuilder<List<Message>>(
      stream: firestoreService.getMessages(conversationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No messages yet'));
        }

        final messages = snapshot.data!;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (listScrollController.hasClients) {
            listScrollController.jumpTo(
              listScrollController.position.maxScrollExtent,
            );
          }
        });

        return ListView.builder(
          controller: listScrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            return MessageBubble(
              sender: msg.senderId,
              text: msg.text,
              isMe: msg.senderId == currentUserId,
            );
          },
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
  });

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          if (!isMe)
            Text(
              sender,
              style: TextStyle(fontSize: 12.0, color: Colors.white70),
            ),
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isMe)
                CircleAvatar(
                  radius: 15,
                  child: Text(
                    sender[0].toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              SizedBox(width: 8),
              Material(
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      )
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                elevation: 5.0,
                color: isMe
                    ? const Color.fromARGB(255, 45, 93, 0)
                    : const Color.fromARGB(255, 194, 194, 194),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  child: Text(
                    text,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AISuggestionBox extends StatelessWidget {
  final Conversation conv;
  AISuggestionBox({required this.conv, super.key});

  @override
  Widget build(BuildContext context) {
    AISettings settings = context.watch<AISettings>();
    Promptable? promptable = settings.promptable;
    if (promptable == null) {
      String reasonText;
      if (settings.api_key == null) {
        reasonText = "API key has net been given";
      } else if (~settings.aiSuggestionsEnabled) {
        reasonText = "AI suggestions are disabled";
      } else {
        reasonText = "ChatBot error, perhaps wrong API key?";
      }
      return Text(reasonText);
    }

    Personality? personality = settings.selectedPersonality;
    if (personality == null) {
      return Text("Personality has not been selected");
    }

    return FutureBuilder(
      future: prompt(
        prompter: promptable,
        chat: conv.messages,
        user: currentUser.name,
        otherUsers: conv.participants
            .map((e) => e.name)
            .where((element) => element != currentUser.name)
            .toList(),
        personalitySpec: personality.instruction,
      ),
      builder: (context, snapshot) {
        PromptResponse? promptResponse = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("❌ Error: ${snapshot.error}");
          } else if (snapshot.hasData && promptResponse != null) {
            return SelectableText(
              promptResponse.responses ??
                  promptResponse.stopReason ??
                  "Empty ChatBot Response",
            );
          } else {
            return const Text("⚠️ No data returned");
          }
        } else {
          return const Text("Idle");
        }
      },
    );
  }
}
