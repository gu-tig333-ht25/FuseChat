import 'package:flutter/material.dart';
import 'stat_card.dart';
import 'settings_tile.dart';

class ProfileView extends StatefulWidget {
  @override
  State<ProfileView> createState() => _ProfileViewState();

  String profileName = "Jane Doe";
  String profileEmail = "jane.doe@email.com";
  int totMsgs = 248;
  int groups = 12;
  int aiReplies = 156;
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // TODO: add navigator.pop()
          },
        ),
        centerTitle: true,
        title: Text(
          "${widget.profileName}'s Profile",
          style: TextStyle(color: Color.fromARGB(255, 204, 208, 211)),
        ),
        backgroundColor: Color.fromARGB(255, 18, 18, 21),
      ),
      body: Container(
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
                      SizedBox(
                        width: 200, // control TextField width
                        child: TextField(
                          style: TextStyle(color: Colors.white), // text color
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(255, 31, 32, 35),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Enter new nickname',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.profileEmail,
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
                        value: '${widget.totMsgs}',
                        label: 'Messages',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        icon: Icons.group,
                        color: Colors.purpleAccent,
                        value: '${widget.groups}',
                        label: 'Groups',
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: StatCard(
                        icon: Icons.stars,
                        color: Colors.orangeAccent,
                        value: '${widget.aiReplies}',
                        label: 'AI Replies',
                      ),
                    ),
                  ],
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
                    icon: Icons.stars,
                    label: "AI Configuration",
                    actionText: "Configure",
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
                    icon: Icons.help_outline,
                    label: "Help & Support",
                    actionText: "Get Help",
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
                      // TODO: Log out and maybe some push/pop stuff
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
