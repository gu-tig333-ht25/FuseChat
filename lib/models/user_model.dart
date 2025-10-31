import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String imageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl = '',
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  // Create a copy with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? imageUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
