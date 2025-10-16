import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'stat_card.dart';
import 'settings_tile.dart';
import '../../services/auth_service.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String profileName = "Jane Doe";
  String profileEmail = "jane.doe@email.com";
  int totMsgs = 248;
  int groups = 12;
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
    final currentUser = FirebaseAuth.instance.currentUser;
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "${profileName.trim().isEmpty == false ? profileName : 'User'}'s Profile",
          style: TextStyle(color: Color.fromARGB(255, 204, 208, 211)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // TODO: navigator.push(ProfileSettings)
            },
          ),
        ],
        backgroundColor: Color.fromARGB(255, 18, 18, 21),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 18, 18, 21),
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
                          radius: 60,
                          backgroundImage: AssetImage("assets/jane_doe.png"),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          profileEmail,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w100,
                            color: Color.fromARGB(150, 204, 208, 211),
                            letterSpacing: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(thickness: 1, color: Colors.grey[300], height: 40),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Icons.message_outlined,
                          color: Colors.blue,
                          value: '$totMsgs',
                          label: 'Messages',
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: StatCard(
                          icon: Icons.group,
                          color: Colors.purpleAccent,
                          value: '$groups',
                          label: 'Groups',
                        ),
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
                    SettingsTile(
                      icon: Icons.stars,
                      label: "AI Configuration",
                      actionText: "Configure AI",
                      onTap: () {
                        // TODO: navigator.push()
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
      ),
    );
  }
}