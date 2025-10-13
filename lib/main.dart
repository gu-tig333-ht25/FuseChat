import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth/firebase_options.dart';
import 'package:provider/provider.dart';

import 'theme/themedata.dart';
import 'services/auth/auth.dart';

import 'pages/auth_screen.dart';
import 'pages/conversation_screen.dart';
import 'pages/profile_view/profile_view.dart';
import 'pages/chat_screen.dart';

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
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MyAuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: fuseChatDarkTheme,
        home: const AuthScreen(),
      ),
    );
  }
}
