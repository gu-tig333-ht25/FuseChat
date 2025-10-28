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
import '../../models/user_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
    final firestoreService = Provider.of<FirestoreService>(context);
    ThemeSettings themeSettings = context.watch<ThemeSettings>();
    return StreamBuilder(
      stream: firestoreService.getUser(currentUserId),
      builder: (context, snapshot) {
        User? user = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || user == null) {
          return const Center(
            child: Text("Internal error, no data found for profile"),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "${user.name}'s Profile",
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileSettingsView(),
                      ),
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
                                (user.email[0]).toUpperCase(),
                                style: Theme.of(
                                  context,
                                ).textTheme.titleLarge?.copyWith(fontSize: 22),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              user.email,
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
                            stream: firestoreService.getAmountMessages(
                              currentUserId,
                            ),
                            builder: (context, snapshot) {
                              final messages = snapshot.data ?? "";
                              return Expanded(
                                child: (snapshot.data != null)
                                    ? StatCard(
                                        icon: Icons.message_outlined,
                                        color: Colors.blue,
                                        value: '$messages',
                                        label: 'Messages',
                                      )
                                    : Spacer(),
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          StreamBuilder(
                            stream: firestoreService.getAmountConversations(
                              currentUserId,
                            ),
                            builder: (context, snapshot) {
                              final groups = snapshot.data ?? "";

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
                        ],
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.grey[300], height: 40),

                    Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(
                            30,
                            12,
                            30,
                            12,
                          ),
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
                            inactiveTrackColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            activeTrackColor: Theme.of(
                              context,
                            ).colorScheme.secondary,
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
                              MaterialPageRoute(
                                builder: (context) => AIConfig(),
                              ),
                            );
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
      },
    );
  }
}
