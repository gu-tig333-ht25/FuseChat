import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signup(String email, String password) async {
    _setLoading(true);
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _getErrorMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    String message = 'An error occurred';
    if (e.code == 'configuration-not-found') {
      message =
          'Firebase Authentication not configured!\n\n'
          'Please:\n'
          '1. Go to Firebase Console\n'
          '2. Enable Authentication\n'
          '3. Enable Email/Password provider\n\n'
          'Tap the debug button (🐛) for more info.';
    } else if (e.code == 'user-not-found') {
      message = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      message = 'Wrong password provided.';
    } else if (e.code == 'email-already-in-use') {
      message = 'The account already exists for that email.';
    } else if (e.code == 'weak-password') {
      message = 'The password provided is too weak.';
    } else if (e.code == 'invalid-email') {
      message = 'The email address is not valid.';
    } else if (e.code == 'invalid-credential') {
      message = 'Invalid email or password.';
    } else {
      message = 'Authentication failed: ${e.message}';
    }

    return message;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
