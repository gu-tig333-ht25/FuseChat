import 'package:flutter/material.dart';
import '../data/dummy_conversation_data.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  //final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversations'),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.account_circle_outlined, color: Colors.white,),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: SearchBar(
                hintText: 'Search conversations',
                leading: Icon(Icons.menu, color: Colors.black,),
                trailing: [Icon(Icons.search, color: Colors.black)],
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                  debugPrint('Search text: $_searchText');
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dummyConversations.length,
                itemBuilder: (context, index) {
                  final chat = dummyConversations[index];
                  return Card(
                    margin: EdgeInsets.all(2),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          chat.participants[1].name[0].toUpperCase(), 
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ), 
                        ),
                      ),
                      title: Text(chat.participants[1].name, style: TextStyle(color: Colors.white),),
                      subtitle: Text(chat.messages.last.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        ),
                      ),
                      trailing: Text(chat.messages.last.timestamp.toString(), 
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: const Icon(Icons.message),
        )
    );
  }
}
