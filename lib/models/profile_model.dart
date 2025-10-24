import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileSettings extends ChangeNotifier {
  // Private fields
  String _profileName =
      FirebaseAuth.instance.currentUser?.displayName ?? "User Name";
  String _profileEmail =
      FirebaseAuth.instance.currentUser?.email ?? "user@email.com";
  int _totMsgs = 0;
  int _groups = 0;
  int _aiReplies = 0;

  // ====== GETTERS ======
  String get profileName => _profileName;
  String get profileEmail => _profileEmail;
  int get totMsgs => _totMsgs;
  int get groups => _groups;
  int get aiReplies => _aiReplies;

  // ====== SETTERS ======
  set profileName(String name) {
    if (name != _profileName) {
      _profileName = name;
      notifyListeners();
    }
  }

  set profileEmail(String email) {
    if (email != _profileEmail) {
      _profileEmail = email;
      notifyListeners();
    }
  }

  set totMsgs(int value) {
    if (value != _totMsgs) {
      _totMsgs = value;
      notifyListeners();
    }
  }

  set groups(int value) {
    if (value != _groups) {
      _groups = value;
      notifyListeners();
    }
  }

  set aiReplies(int value) {
    if (value != _aiReplies) {
      _aiReplies = value;
      notifyListeners();
    }
  }

  // ====== INCREMENT METHODS ======
  void incrementMessages() {
    _totMsgs++;
    notifyListeners();
  }

  void incrementGroups() {
    _groups++;
    notifyListeners();
  }

  void incrementAiReplies() {
    _aiReplies++;
    notifyListeners();
  }

  // ====== RESET METHOD ======
  void resetStats() {
    _totMsgs = 0;
    _groups = 0;
    _aiReplies = 0;
    notifyListeners();
  }

  // ====== REFRESH FROM FIREBASE USER ======
  void refreshFromFirebaseUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _profileName = user.displayName ?? _profileName;
      _profileEmail = user.email ?? _profileEmail;
      notifyListeners();
    }
  }
}
