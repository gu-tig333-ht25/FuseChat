import 'package:flutter/material.dart';
import 'package:template/models/conversation_model.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/dummy_conversation_data.dart';
import '../models/message_model.dart';

// 2do
// Add references to Firebase, get current user, send messages to Firestore, and get messages from Firestore
// Add LLM suggestions
// Fix spacing between messages etc.
// Set chat title based on conversation
// auto focus to text field https://docs.flutter.dev/cookbook/forms/focus

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.convIndex});

  final int convIndex; // Index of the conversation to display

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Title')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: DummyMessagesStream(convIndex: widget.convIndex)),
            Card(
              color: Theme.of(context).cardColor,
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Text(
                  'LLM Suggestions Here. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eu quam nisl. Suspendisse potenti. Maecenas.',
                  style: TextStyle(color: Colors.grey[100]),
                ), // 2do: Implement LLM suggestions
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    onSubmitted: (String text) {
                      setState(() {
                        // 2do: Implement Firebase send functionality
                        Conversation conv =
                            dummyConversations[widget.convIndex];
                        conv.messages.add(
                          Message(
                            id: 'm${conv.messages.length + 1}',
                            senderId: currentUser.id,
                            text: messageTextController.text,
                            timestamp: DateTime.now(),
                          ),
                        );
                      });
                      messageTextController.clear();
                    },
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

class DummyMessagesStream extends StatelessWidget {
  DummyMessagesStream({super.key, required this.convIndex});

  final int convIndex;
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var listView = ListView.builder(
      controller: listScrollController,
      itemCount: dummyConversations[convIndex].messages.length,
      itemBuilder: (context, index) {
        final msg = dummyConversations[convIndex].messages[index];
        return MessageBubble(
          sender: msg.senderId,
          text: msg.text,
          isMe: msg.senderId == currentUser.id,
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (listScrollController.hasClients) {
        listScrollController.jumpTo(
          listScrollController.position.maxScrollExtent,
        );
      }
    });

    return listView;
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
                    style: TextStyle(
                      fontFamily: 'Inter',
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
