import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:template/chatBot/chatBot.dart';
import 'package:template/models/AI_model.dart';
import 'package:template/models/conversation_model.dart';
import '../services/firestore_service.dart';
import '../models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

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
  final FocusNode messageFocusNode = FocusNode();
  String? _lastSuggestion;

  @override
  void dispose() {
    messageTextController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

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
              child: InkWell(
                onTap: () {
                  // If we have a last suggestion from the LLM, copy it into the input
                  if (_lastSuggestion != null &&
                      _lastSuggestion!.trim().isNotEmpty) {
                    messageTextController.text = _lastSuggestion!;
                    messageTextController.selection = TextSelection.collapsed(
                      offset: messageTextController.text.length,
                    );
                    messageFocusNode.requestFocus();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: AISuggestionBoxWrapper(
                    conversationId: widget.conversationId,
                    onSuggestionAvailable: (String? suggestion) {
                      _lastSuggestion = suggestion;
                    },
                  ),
                ),
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
                      focusNode: messageFocusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                      ),
                      onSubmitted: (String text) async {
                        if (text.trim().isEmpty) return;

                        final firestoreService = Provider.of<FirestoreService>(
                          context,
                          listen: false,
                        );

                        await firestoreService.sendMessage(
                          conversationId: widget.conversationId,
                          senderId: currentUserId,
                          text: text,
                        );

                        messageTextController.clear();
                        setState(
                          () {},
                        ); // Triggers rebuild for a new LLM suggestion
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

class AISuggestionBoxWrapper extends StatelessWidget {
  final String conversationId;
  final void Function(String?)? onSuggestionAvailable;

  const AISuggestionBoxWrapper({
    super.key,
    required this.conversationId,
    this.onSuggestionAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(
      context,
      listen: false,
    );

    return FutureBuilder<Conversation?>(
      future: firestoreService.getConversationForLLM(conversationId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error loading conversation: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No conversation data available');
        }

        final conversation = snapshot.data!;

        return AISuggestionBox(
          conversationId: conversationId,
          messages: conversation.messages,
          onSuggestionAvailable: onSuggestionAvailable,
        );
      },
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

    List<String> userIDs =
        []; // Keep track of participants for message bubble color coding

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
            final senderId = msg.senderId;
            if (senderId != currentUserId && !userIDs.contains(senderId)) {
              userIDs.add(senderId);
            }
            final msgColorIndex = userIDs.indexOf(senderId);
            String? previousSenderID = index > 0
                ? messages[index - 1].senderId
                : '';
            String? nextSenderID = index < messages.length - 1
                ? messages[index + 1].senderId
                : '';
            return MessageBubble(
              senderName: msg.senderName ?? msg.senderId,
              senderID: msg.senderId,
              previousSenderID: previousSenderID,
              nextSenderID: nextSenderID,
              text: msg.text,
              isMe: msg.senderId == currentUserId,
              colorIndex: msgColorIndex,
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
    required this.senderName,
    required this.text,
    required this.isMe,
    required this.senderID,
    required this.previousSenderID, // bubble design depends on sender continuity
    required this.nextSenderID,
    required this.colorIndex,
  });

  final String senderName;
  final String text;
  final bool isMe;
  final String senderID;
  final String previousSenderID;
  final String nextSenderID;
  final int colorIndex;

  BorderRadius _getBubbleBorderRadius() {
    const radius = Radius.circular(30.0);

    bool isPreviousSame = senderID == previousSenderID;
    bool isNextSame = senderID == nextSenderID;

    if (isMe) {
      return BorderRadius.only(
        topLeft: radius,
        topRight: isPreviousSame ? Radius.circular(5.0) : radius,
        bottomLeft: radius,
        bottomRight: isNextSame ? Radius.circular(5.0) : radius,
      );
    } else {
      return BorderRadius.only(
        topLeft: isPreviousSame ? Radius.circular(5.0) : radius,
        topRight: radius,
        bottomLeft: isNextSame ? Radius.circular(5.0) : radius,
        bottomRight: radius,
      );
    }
  }

  Color getBubbleColor() {
    // Define a list of colors to cycle through for different users
    final colors = [
      Color.fromARGB(255, 194, 194, 194),
      Colors.deepPurpleAccent,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
    ];
    return colors[colorIndex % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: (previousSenderID == senderID ? 1.0 : 8.0),
        bottom: (nextSenderID == senderID ? 1.0 : 8.0),
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          if (!isMe && previousSenderID != senderID)
            Text(
              senderName,
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
                    senderName[0].toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
              SizedBox(width: 8),
              Flexible(
                child: Material(
                  borderRadius: _getBubbleBorderRadius(),
                  elevation: 5.0,
                  color: isMe
                      ? const Color.fromARGB(255, 45, 93, 0)
                      : getBubbleColor(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        // Limit width so long messages wrap instead of overflowing
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Text(
                        text,
                        softWrap: true,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
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
  final String conversationId;
  final List<Message> messages;
  final void Function(String?)? onSuggestionAvailable;

  const AISuggestionBox({
    required this.conversationId,
    required this.messages,
    this.onSuggestionAvailable,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AISettings settings = context.watch<AISettings>();
    Promptable? promptable = settings.promptable;

    if (promptable == null) {
      String reasonText;
      if (settings.api_key == null) {
        reasonText = "API key has not been given";
      } else if (!settings.aiSuggestionsEnabled) {
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

    // Get current user
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';

    // Don't show suggestions if conversation is empty
    if (messages.isEmpty) {
      return const Text("Start a conversation to get AI suggestions");
    }

    // Find current user's name from messages
    final currentUserName =
        messages
            .firstWhere(
              (m) => m.senderId == currentUserId,
              orElse: () => Message(
                id: '',
                senderId: currentUserId,
                senderName: 'You',
                text: '',
                isRead: false,
              ),
            )
            .senderName ??
        'You';

    // Extract other user names
    final otherUsers = messages
        .where((m) => m.senderId != currentUserId)
        .map((m) => m.senderName ?? 'Unknown')
        .where((name) => name != 'Unknown')
        .toSet()
        .toList();

    return FutureBuilder(
      future: prompt(
        prompter: promptable,
        chat: messages,
        user: currentUserName,
        otherUsers: otherUsers,
        personalitySpec: personality.instruction,
      ),
      builder: (context, snapshot) {
        PromptResponse? promptResponse = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text("❌ Error: \\${snapshot.error}");
          } else if (snapshot.hasData && promptResponse != null) {
            final suggestionText =
                promptResponse.responses ??
                promptResponse.stopReason ??
                "Empty ChatBot Response";

            // Notify parent that a suggestion is available
            if (onSuggestionAvailable != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onSuggestionAvailable!(suggestionText);
              });
            }

            // Make suggestion tappable: when tapped, call the provided callback
            return Text(suggestionText);
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
