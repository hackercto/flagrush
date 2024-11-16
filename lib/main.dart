import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flagrush/firebase_options.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    )
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      appBar: AppBar(
        title: const Text('Home Page')
      ),
      body: FutureBuilder(
        future: initFirebase(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              print(user);
              if (user?.emailVerified ?? false) {
                return Text('Welcome ${user?.email}');
              } else {
                return const Text('Please verify your email');
              }
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}
