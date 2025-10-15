import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:provider/provider.dart';

import '../pages/auth_screen.dart';
import '../pages/conversation_screen.dart';

// makes sure that the user is brought to the login screen whenever/wherever the user is logged out.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();

    if (auth.user == null && auth.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ConversationScreen is the "default" page that is navigated to after a user is logged in.
    // Could cause issues if the firebase-user is edited but not logged out. Idk.
    if (auth.isLoggedIn) {
      return const ConversationScreen();
    } else {
      Navigator.popUntil(context, ModalRoute.withName("/"));
      return const AuthScreen();
    }
  }
}
