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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 40,
                          child: Text(
                            (user.name[0]).toUpperCase(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(fontSize: 35),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    Divider(thickness: 2, height: 40),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: StreamBuilder<int>(
                              stream: firestoreService.getAmountMessages(
                                currentUserId,
                              ),
                              builder: (context, snapshot) {
                                final messages = snapshot.data ?? "";

                                return (snapshot.hasData)
                                    ? StatCard(
                                        icon: Icons.message_outlined,
                                        color: Colors.blue,
                                        value: '$messages',
                                        label: 'Messages',
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: StreamBuilder(
                              stream: firestoreService.getAmountConversations(
                                currentUserId,
                              ),
                              builder: (context, snapshot) {
                                final groups = snapshot.data ?? "";

                                return (snapshot.hasData)
                                    ? StatCard(
                                        icon: Icons.group,
                                        color: Colors.purpleAccent,
                                        value: '$groups',
                                        label: 'Groups',
                                      )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 2, height: 40),

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
                            color: Theme.of(
                              context,
                            ).textTheme.labelLarge?.color,
                            size: 30,
                          ),
                          title: Text(
                            "Toggle dark mode",
                            style: Theme.of(context).textTheme.titleLarge,
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
