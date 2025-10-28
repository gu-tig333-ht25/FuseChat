import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '/services/firestore_service.dart';
import 'package:provider/provider.dart';

class ProfileSettingsView extends StatefulWidget {
  ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  final TextEditingController _chatNameController = TextEditingController();

  @override
  void dispose() {
    _chatNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    final firestoreService = Provider.of<FirestoreService>(context);

    void setName() async {
      if (_chatNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enter a nickname!'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final String newName = _chatNameController.text.trim();
      bool resp = await firestoreService.setUsername(currentUserId, newName);

      if (!resp) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Couldn't update nickname!"),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Nickname updated successfully!"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Profile Settings")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Change Nickname", textAlign: TextAlign.center),
                const SizedBox(height: 20),
                TextField(
                  controller: _chatNameController,
                  decoration: const InputDecoration(
                    hintText: "Enter new nickname",
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: setName,
                  child: const Text("Update Nickname"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
