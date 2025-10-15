import '../models/user_model.dart';
import '../models/message_model.dart';
import '../models/conversation_model.dart';

//  User1 (inloggad)
final User currentUser = User(
  id: 'u1',
  name: 'Alice Andersson',
  imageUrl: 'assets/images/alice.jpg',
);

// Andra användare
final List<User> otherUsers = [
  User(id: 'u2', name: 'Björn Berg', imageUrl: ''),
  User(id: 'u3', name: 'Carla Carlsson', imageUrl: ''),
  User(id: 'u4', name: 'David Dahl', imageUrl: ''),
  User(id: 'u5', name: 'Ella Ek', imageUrl: ''),
  User(id: 'u6', name: 'Filip Fors', imageUrl: ''),
  User(id: 'u7', name: 'Greta Gustafsson', imageUrl: ''),
  User(id: 'u8', name: 'Henrik Holm', imageUrl: ''),
  User(id: 'u9', name: 'Isabella Isaksson', imageUrl: ''),
  User(id: 'u10', name: 'Jonas Johansson', imageUrl: ''),
];

// Alice's konversationer 
final List<Conversation> dummyConversations = [
  Conversation(
    id: 'c1',
    participants: [currentUser, otherUsers[0]],
    messages: [
      Message(id: 'm1', sender: currentUser, text: 'Hej Björn!', timestamp: DateTime.now().subtract(const Duration(minutes: 20))),
      Message(id: 'm2', sender: otherUsers[0], text: 'Hej Alice! Hur är läget? bla bla bla bla', timestamp: DateTime.now().subtract(const Duration(minutes: 19))),
    ],
  ),
  Conversation(
    id: 'c2',
    participants: [currentUser, otherUsers[1]],
    messages: [
      Message(id: 'm3', sender: otherUsers[1], text: 'Vi ses imorgon på jobbet?', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
      Message(id: 'm4', sender: currentUser, text: 'Japp, vi ses då 👋 bla bla bla bla bla bla', timestamp: DateTime.now().subtract(const Duration(minutes: 50))),
    ],
  ),
  Conversation(
    id: 'c3',
    participants: [currentUser, otherUsers[2]],
    messages: [
      Message(id: 'm5', sender: otherUsers[2], text: 'Glöm inte rapporten!', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
      Message(id: 'm6', sender: currentUser, text: 'Tack för påminnelsen 🙈 bla bla bla bla', timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 55))),
    ],
  ),
  Conversation(
    id: 'c4',
    participants: [currentUser, otherUsers[3]],
    messages: [
      Message(id: 'm7', sender: currentUser, text: 'Hur går det med projektet?', timestamp: DateTime.now().subtract(const Duration(hours: 5))),
      Message(id: 'm8', sender: otherUsers[3], text: 'Bra! Nästan klart nu 😄 bla bla bla bla bla bla', timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 50))),
    ],
  ),
  Conversation(
    id: 'c5',
    participants: [currentUser, otherUsers[4]],
    messages: [
      Message(id: 'm9', sender:  otherUsers[4], text: 'Kommer du på träningen?', timestamp: DateTime.now().subtract(const Duration(hours: 7))),
      Message(id: 'm10', sender: currentUser, text: 'Ja, jag är på väg!', timestamp: DateTime.now().subtract(const Duration(hours: 6, minutes: 55))),
    ],
  ),
];
