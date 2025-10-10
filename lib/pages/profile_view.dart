import 'package:flutter/material.dart';
import 'stat_card.dart';
import 'settings_tile.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage("assets/jane_doe.png"),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Jane Doe",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "jane.doe@email.com",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w100,
                        color: Colors.black.withOpacity(0.7),
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(thickness: 1, color: Colors.grey[300], height: 40),

            Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: StatCard(
                        icon: Icons.message_outlined,
                        color: Colors.blue,
                        value: '248',
                        label: 'Messages',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        icon: Icons.group,
                        color: Colors.purpleAccent,
                        value: '12',
                        label: 'Groups',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        icon: Icons.stars,
                        color: Colors.orangeAccent,
                        value: '156',
                        label: 'AI Replies',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 1, // line thickness
              color: Colors.grey[300], // line color
              height: 40, // total space around the line
            ),

            Column(
              children: [
                SettingsTile(
                  icon: Icons.notifications_none,
                  label: "Notifications",
                  actionText: "View",
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.lock_outline,
                  label: "Privacy",
                  actionText: "Manage",
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.help_outline,
                  label: "Help & Support",
                  actionText: "Get Help",
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.logout,
                  label: "Logout",
                  actionText: "",
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    // handle logout
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
