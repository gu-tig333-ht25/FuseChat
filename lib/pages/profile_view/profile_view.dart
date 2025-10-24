import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import '/services/firestore_service.dart';
import 'stat_card.dart';
import 'settings_tile.dart';
import '../../services/auth_service.dart';
import 'AI_config_view.dart';
import '../../models/theme_model.dart';
import '../profile_settings.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String profileName = "User";
  String profileEmail = "User@email.com";
  int totMsgs = 248;
  int aiReplies = 156;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: profileName);
    _controller.addListener(() {
      setState(() {
        profileName = _controller.text;
      });
    });

    // Load Firebase Auth user info
    final currentUser = auth.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      profileEmail = currentUser.email ?? profileEmail;
      profileName = currentUser.displayName ?? profileName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    final firestoreService = Provider.of<FirestoreService>(context);
    ThemeSettings themeSettings = context.watch<ThemeSettings>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: StreamBuilder<String>(
          stream: firestoreService.getUserName(currentUserId),
          builder: (context, snapshot) {
            final fetchedName = snapshot.data;
            final user = auth.FirebaseAuth.instance.currentUser;
            final displayName = fetchedName ?? user?.displayName ?? '';

            return Text(
              "$displayName's Profile",
              style: Theme.of(context).textTheme.headlineLarge,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfileSettings()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 30,
                        child: Text(
                          (profileName[0]).toUpperCase(),
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 22),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        profileEmail,
                        style: TextTheme.of(context).titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
              Divider(thickness: 2, height: 40),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StreamBuilder<int>(
                      stream: firestoreService.getAmountMessages(currentUserId),
                      builder: (context, snapshot) {
                        final messages = snapshot.data ?? 0;

                        return Expanded(
                          child: StatCard(
                            icon: Icons.message_outlined,
                            color: Colors.blue,
                            value: '$messages',
                            label: 'Messages',
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    StreamBuilder(
                      stream: firestoreService.getAmountConversations(
                        currentUserId,
                      ),
                      builder: (context, snapshot) {
                        final groups = snapshot.data ?? 0;

                        return Expanded(
                          child: StatCard(
                            icon: Icons.group,
                            color: Colors.purpleAccent,
                            value: '$groups',
                            label: 'Groups',
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        icon: Icons.stars,
                        color: Colors.orangeAccent,
                        value: '$aiReplies',
                        label: 'AI Replies',
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1, color: Colors.grey[300], height: 40),

              Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                    leading: Icon(
                      Icons.dark_mode,
                      color: TextTheme.of(context).labelLarge?.color,
                      size: 30,
                    ),
                    title: Text(
                      "Toggle dark mode",
                      style: TextTheme.of(context).titleLarge,
                    ),
                    trailing: Switch(
                      inactiveTrackColor: Theme.of(context).colorScheme.primary,
                      activeTrackColor: Theme.of(context).colorScheme.secondary,
                      value: themeSettings.isDarkMode,
                      onChanged: (value) {
                        print("set toggle $value");
                        themeSettings.isDarkMode = value;
                      },
                    ),
                  ),
                  SettingsTile(
                    icon: Icons.stars,
                    label: "AI Configuration",
                    actionText: "Configure AI",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AIConfig()),
                      );
                    },
                  ),

                  SettingsTile(
                    icon: Icons.notifications_none,
                    label: "Notifications",
                    actionText: "View",
                    onTap: () {
                      // TODO: navigator.push()
                    },
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline,
                    label: "Privacy",
                    actionText: "Manage",
                    onTap: () {
                      // TODO: navigator.push()
                    },
                  ),
                  SettingsTile(
                    icon: Icons.logout,
                    label: "Logout",
                    actionText: "",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      context.read<MyAuthProvider>().logout();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
