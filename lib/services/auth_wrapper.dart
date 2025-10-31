import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import '../pages/auth_screen.dart';
import '../pages/conversation_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();

    if (auth.user == null && auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ConversationScreen is the "default" page that is navigated to after a user is logged in.
    // Could cause issues if the firebase-user is edited but not logged out. Idk.
    if (auth.isLoggedIn) {
      return ConversationScreen();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      });

      return const AuthScreen();
    }
  }
}
