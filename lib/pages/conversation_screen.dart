import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/conversation_model.dart';
import 'chat_screen.dart';
import 'profile_view/profile_view.dart';
import 'package:template/theme/themedata.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _searchText = '';
  final TextEditingController _chatNameController = TextEditingController();

  Future<void> createChatDialog(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(
      context,
      listen: false,
    );
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Create Chat')),
          content: TextField(
            controller: _chatNameController,
            decoration: InputDecoration(hintText: "chat name"),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Create'),
                  onPressed: () {
                    final chatName = _chatNameController.text.trim();
                    if (chatName.isEmpty) return;

                    firestoreService.createConversation(
                      name: chatName,
                      participantIds: [currentUserId],
                    );

                    _chatNameController.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _chatNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FuseChat',
          style: GoogleFonts.irishGrover(
            textStyle: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
          child: StreamBuilder<String>(
            stream: firestoreService.getUserName(currentUserId),
            builder: (context, snapshot) {
              final userName = snapshot.data ?? 'User';
              return TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileView()),
                  );
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: CircleAvatar(
                  radius: 20,
                  child: Text(
                    userName[0].toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontSize: 23),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: SearchBar(
                shadowColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primary,
                ),
                backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onSurface,
                ),
                textStyle: WidgetStatePropertyAll(
                  TextTheme.of(context).bodyMedium?.copyWith(
                    color: TextTheme.of(
                      context,
                    ).bodyMedium?.color?.withValues(alpha: 0.4),
                  ),
                ),

                hintText: 'Search conversations',
                leading: Icon(Icons.menu),
                trailing: [Icon(Icons.search)],
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Conversation>>(
                stream: firestoreService.getConversations(currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No conversations yet'));
                  }

                  final conversations = snapshot.data!;
                  print(TextTheme.of(context).titleMedium?.color);
                  return ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      return Card(
                        margin: EdgeInsets.all(2),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                conversationBubbleColors[index %
                                    conversationBubbleColors.length],
                            child: Text(
                              conv.name.isNotEmpty
                                  ? conv.name[0].toUpperCase()
                                  : 'C',
                              style: TextTheme.of(context).titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            conv.name,
                            style: TextTheme.of(context).titleMedium,
                          ),
                          subtitle: Text(
                            conv.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextTheme.of(context).labelLarge?.copyWith(
                              color: TextTheme.of(
                                context,
                              ).labelLarge?.color?.withValues(alpha: 0.5),
                            ),
                          ),
                          trailing: conv.lastMessageTime != null
                              ? Text(
                                  '${conv.lastMessageTime!.hour}:${conv.lastMessageTime!.minute.toString().padLeft(2, '0')}',
                                )
                              : null,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  conversationId: conv.id,
                                  chatTitle: conv.name,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createChatDialog(context);
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
