import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'package:provider/provider.dart';
import 'theme/themedata.dart';
import 'services/auth_service.dart';
import 'services/auth_wrapper.dart';
import 'services/firestore_service.dart';
import 'models/theme_model.dart';

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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AISettings()),
        ChangeNotifierProvider(
          create: (context) => ThemeSettings(fuseChatDarkTheme),
        ),
        ChangeNotifierProvider(create: (_) => MyAuthProvider()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
        ChangeNotifierProvider(create: (_) => ChatbotLastPrompts()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeSettings themeSettings = context.watch<ThemeSettings>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeSettings.theme,
      home: const AuthWrapper(),
    );
  }
}
