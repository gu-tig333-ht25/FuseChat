import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth/firebase_options.dart';
import 'package:provider/provider.dart';

import 'theme/themedata.dart';
import 'services/auth/auth.dart';

import 'pages/auth_screen.dart';
import 'pages/conversation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    throw ('Firebase initialization failed: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyAuthProvider(),
      child: Consumer<MyAuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: fuseChatDarkTheme,
            home: auth.isLoggedIn
                ? const ConversationScreen()
                : const AuthScreen(),
          );
        },
      ),
    );
  }
}
