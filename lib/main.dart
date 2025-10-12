import 'package:flutter/material.dart';
import 'theme/themedata.dart';
import 'pages/login_screen.dart';
import 'pages/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FuseChat',
      theme: fuseChatDarkTheme,
      debugShowCheckedModeBanner: false,
      home: ChatScreen(convIndex: 0), //LoginScreen(),
    );
  }
}
