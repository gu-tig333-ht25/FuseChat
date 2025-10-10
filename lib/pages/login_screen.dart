import 'package:flutter/material.dart';
import 'package:template/pages/conversation_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Bomb icon: https://www.flaticon.com/free-icon/bomb_4357187
  // Font: Irish Grover - https://fonts.google.com/specimen/Irish+Grover

  @override
  Widget build(BuildContext context) {
    TextEditingController controllerUser = TextEditingController();
    TextEditingController controllerPass = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'FuseChat',
                style: TextStyle(fontSize: 64, fontFamily: 'IrishGrover'),
              ),
              Image.asset('lib/assets/bomb_512px.png', height: 150),
              TextField(
                controller: controllerUser,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: controllerPass,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle login logic
                  // ...

                  // After successful login, navigate to ConversationScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationScreen(),
                    ),
                  );
                },
                child: Text('Login / Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
