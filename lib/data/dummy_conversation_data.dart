import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreInitializer {
  static Future<void> initializeDummyData(String currentUserId) async {
    final db = FirebaseFirestore.instance;
    final batch = db.batch();

    try {
      print('Starting Firestore initialization...');

      // Add all users to the users collection
      final users = [
        {'id': currentUserId, 'name': 'Alice Andersson', 'email': 'alice@example.com', 'imageUrl': ''},
        {'id': 'u2', 'name': 'Björn Berg', 'email': 'bjorn@example.com', 'imageUrl': ''},
        {'id': 'u3', 'name': 'Carla Carlsson', 'email': 'carla@example.com', 'imageUrl': ''},
        {'id': 'u4', 'name': 'David Dahl', 'email': 'david@example.com', 'imageUrl': ''},
        {'id': 'u5', 'name': 'Ella Ek', 'email': 'ella@example.com', 'imageUrl': ''},
        {'id': 'u6', 'name': 'Filip Fors', 'email': 'filip@example.com', 'imageUrl': ''},
        {'id': 'u7', 'name': 'Greta Gustafsson', 'email': 'greta@example.com', 'imageUrl': ''},
        {'id': 'u8', 'name': 'Henrik Holm', 'email': 'henrik@example.com', 'imageUrl': ''},
        {'id': 'u9', 'name': 'Isabella Isaksson', 'email': 'isabella@example.com', 'imageUrl': ''},
        {'id': 'u10', 'name': 'Jonas Johansson', 'email': 'jonas@example.com', 'imageUrl': ''},
      ];

      for (var user in users) {
        final userRef = db.collection('users').doc(user['id'] as String);
        batch.set(userRef, {
          'name': user['name'],
          'email': user['email'],
          'imageUrl': user['imageUrl'],
        });
      }

      await batch.commit();
      print('Users added');

      // Add conversations with messages
      final conversations = [
        {
          'name': 'Björn Berg',
          'otherUserId': 'u2',
          'messages': [
            {'senderId': currentUserId, 'senderName': 'Alice Andersson', 'text': 'Hej Björn!', 'minutesAgo': 20},
            {'senderId': 'u2', 'senderName': 'Björn Berg', 'text': 'Hej Alice! Hur är läget? bla bla bla bla', 'minutesAgo': 19},
          ],
        },
        {
          'name': 'Carla Carlsson',
          'otherUserId': 'u3',
          'messages': [
            {'senderId': 'u3', 'senderName': 'Carla Carlsson', 'text': 'Vi ses imorgon på jobbet?', 'minutesAgo': 60},
            {'senderId': currentUserId, 'senderName': 'Alice Andersson', 'text': 'Japp, vi ses då 👋 bla bla bla bla bla bla', 'minutesAgo': 50},
          ],
        },
        {
          'name': 'David Dahl',
          'otherUserId': 'u4',
          'messages': [
            {'senderId': 'u4', 'senderName': 'David Dahl', 'text': 'Glöm inte rapporten!', 'minutesAgo': 180},
            {'senderId': currentUserId, 'senderName': 'Alice Andersson', 'text': 'Tack för påminnelsen 🙈 bla bla bla bla', 'minutesAgo': 175},
          ],
        },
        {
          'name': 'Ella Ek',
          'otherUserId': 'u5',
          'messages': [
            {'senderId': currentUserId, 'senderName': 'Alice Andersson', 'text': 'Hur går det med projektet?', 'minutesAgo': 300},
            {'senderId': 'u5', 'senderName': 'Ella Ek', 'text': 'Bra! Nästan klart nu 😄 bla bla bla bla bla bla', 'minutesAgo': 290},
          ],
        },
        {
          'name': 'Filip Fors',
          'otherUserId': 'u6',
          'messages': [
            {'senderId': 'u6', 'senderName': 'Filip Fors', 'text': 'Kommer du på träningen?', 'minutesAgo': 420},
            {'senderId': currentUserId, 'senderName': 'Alice Andersson', 'text': 'Ja, jag är på väg!', 'minutesAgo': 415},
          ],
        },
      ];

      for (var conv in conversations) {
        final convRef = db.collection('conversations').doc();
        final messages = conv['messages'] as List;
        final lastMsg = messages.last as Map;

        await convRef.set({
          'name': conv['name'],
          'participants': [currentUserId, conv['otherUserId']],
          'lastMessage': lastMsg['text'],
          'lastMessageTime': Timestamp.fromDate(
            DateTime.now().subtract(Duration(minutes: lastMsg['minutesAgo'] as int)),
          ),
        });

        // Add messages as subcollection
        for (var msg in messages) {
          await convRef.collection('messages').add({
            'senderId': msg['senderId'],
            'senderName': msg['senderName'],
            'text': msg['text'],
            'timestamp': Timestamp.fromDate(
              DateTime.now().subtract(Duration(minutes: msg['minutesAgo'] as int)),
            ),
            'isRead': true,
          });
        }

        print('Conversation with ${conv['name']} created');
      }

      print('All dummy data initialized successfully!');
    } catch (e) {
      print('Error initializing data: $e');
      rethrow;
    }
  }

  // Check if data already exists
  static Future<bool> isDatabaseEmpty() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }
}
