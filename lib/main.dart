import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth/firebase_options.dart';
import 'theme/themedata.dart';

import 'auth/auth_screen.dart';
import 'pages/conversation_screen.dart';
import 'pages/profile_view/profile_view.dart';
import 'pages/chat_screen.dart';

import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'models/AI_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    throw ('Firebase initialization failed: $e');
  }
  runApp(
    ChangeNotifierProvider(
      create: (_) => AIPersonalitySettings(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuseChat',
      theme: fuseChatDarkTheme,
      debugShowCheckedModeBanner: false,
      //if loggedin
      home: ProfileView(),
    );
  }
}
