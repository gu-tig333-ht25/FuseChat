import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/theme_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _authenticate(MyAuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      if (_isLogin) {
        await auth.login(_emailController.text, _passwordController.text);
      } else {
        await auth.signup(_emailController.text, _passwordController.text);
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid);

        final doc = await userRef.get();
        if (!doc.exists) {
          final email = currentUser.email ?? '';
          final name = email.contains('@')
              ? email.split('@').first
              : currentUser.uid;
          final cname = name[0].toUpperCase() + name.substring(1);
          await userRef.set({'name': cname, 'email': email, 'imageUrl': ''});
        }
      }
      // AuthWrapper will automatically navigate to ConversationScreen
      // No need to manually navigate here
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeSettings themeSettings = context.watch<ThemeSettings>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(child: Text('FuseChat', style: theme.textTheme.displayLarge)),
                const SizedBox(height: 30),
                Image.asset('assets/logo.png', width: 180, height: 180),
                const SizedBox(height: 40),

                // Email field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'user@mail.com'),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter email';
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter password';
                    if (value.length < 6) return 'Min 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                Consumer<MyAuthProvider>(
                  builder: (context, auth, child) {
                    return SizedBox(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        onPressed: auth.isLoading
                            ? null
                            : () => _authenticate(auth),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_isLogin ? 'Log in' : 'Sign Up'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () {
                    setState(() => _isLogin = !_isLogin);
                  },
                  child: Text(
                    _isLogin
                        ? "Don't have an account? Sign up!"
                        : "Already have an account? Log in!",
                  ),
                ),
                const Spacer(),
                Center(
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        color: TextTheme.of(context).labelLarge?.color,
                        size: 30,
                      ),
                      Switch(
                        inactiveTrackColor: Theme.of(
                          context,
                        ).colorScheme.primary,
                        activeTrackColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        value: themeSettings.isDarkMode,
                        onChanged: (value) {
                          //print("set toggle $value");
                          themeSettings.isDarkMode = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
