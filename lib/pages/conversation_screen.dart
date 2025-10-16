import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import '../services/firestore_service.dart';
import '../models/conversation_model.dart';
import 'chat_screen.dart';
import 'profile_view/profile_view.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _searchText = '';

  @override
  Widget build(context) {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FuseChat',
          style: GoogleFonts.irishGrover(fontSize: 28, color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProfileView()),
            );
          },
          icon: const Icon(Icons.person),
          tooltip: 'Profile',
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: SearchBar(
                hintText: 'Search conversations',
                leading: Icon(Icons.menu, color: Colors.black),
                trailing: [Icon(Icons.search, color: Colors.black)],
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
                    return const Center(
                      child: Text('No conversations yet'),
                    );
                  }

                  final conversations = snapshot.data!;

                  return ListView.builder(
                    itemCount: conversations.length,
                    itemBuilder: (context, index) {
                      final conv = conversations[index];
                      return Card(
                        margin: EdgeInsets.all(2),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              conv.name.isNotEmpty 
                                ? conv.name[0].toUpperCase()
                                : 'C',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            conv.name,
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            conv.lastMessage,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
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
        onPressed: () {},
        child: const Icon(Icons.message),
      ),
    );
  }
}
