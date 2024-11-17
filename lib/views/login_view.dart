import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flagrush/constants/routes.dart';
import 'package:flagrush/firebase_options.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future initFirebase() async {
    // sleep for 2 seconds to simulate a long running task
    await Future.delayed(const Duration(seconds: 2));
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: true,
            autocorrect: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                final userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                final user = userCredential.user;
                devtools.log(userCredential.toString());
                devtools.log('User: $user');
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  devtools.log('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  devtools.log('Wrong password provided for that user.');
                } else {
                  devtools.log('Failed with error code: ${e.code}');
                  devtools.log(e.message.toString());
                }
              }
              if (FirebaseAuth.instance.currentUser != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              }
            },
            child: const Text('Login')
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here')
          ),
        ],
      ),
    );
  }
}
