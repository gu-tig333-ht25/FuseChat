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
      Message(id: 'm1', senderId: 'u1', text: 'Hej Björn!', timestamp: DateTime.now().subtract(const Duration(minutes: 20))),
      Message(id: 'm2', senderId: 'u2', text: 'Hej Alice! Hur är läget? bla bla bla bla', timestamp: DateTime.now().subtract(const Duration(minutes: 19))),
    ],
  ),
  Conversation(
    id: 'c2',
    participants: [currentUser, otherUsers[1]],
    messages: [
      Message(id: 'm3', senderId: 'u3', text: 'Vi ses imorgon på jobbet?', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
      Message(id: 'm4', senderId: 'u1', text: 'Japp, vi ses då 👋 bla bla bla bla bla bla', timestamp: DateTime.now().subtract(const Duration(minutes: 50))),
    ],
  ),
  Conversation(
    id: 'c3',
    participants: [currentUser, otherUsers[2]],
    messages: [
      Message(id: 'm5', senderId: 'u4', text: 'Glöm inte rapporten!', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
      Message(id: 'm6', senderId: 'u1', text: 'Tack för påminnelsen 🙈 bla bla bla bla', timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 55))),
    ],
  ),
  Conversation(
    id: 'c4',
    participants: [currentUser, otherUsers[3]],
    messages: [
      Message(id: 'm7', senderId: 'u1', text: 'Hur går det med projektet?', timestamp: DateTime.now().subtract(const Duration(hours: 5))),
      Message(id: 'm8', senderId: 'u5', text: 'Bra! Nästan klart nu 😄 bla bla bla bla bla bla', timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 50))),
    ],
  ),
  Conversation(
    id: 'c5',
    participants: [currentUser, otherUsers[4]],
    messages: [
      Message(id: 'm9', senderId: 'u6', text: 'Kommer du på träningen?', timestamp: DateTime.now().subtract(const Duration(hours: 7))),
      Message(id: 'm10', senderId: 'u1', text: 'Ja, jag är på väg!', timestamp: DateTime.now().subtract(const Duration(hours: 6, minutes: 55))),
    ],
  ),
];
