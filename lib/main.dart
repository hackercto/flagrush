import 'package:flagrush/constants/routes.dart';
import 'package:flagrush/views/login_view.dart';
import 'package:flagrush/views/notes/create_update_note_view.dart';
import 'package:flagrush/views/notes/notes_view.dart';
import 'package:flagrush/views/register_view.dart';
import 'package:flagrush/views/verify_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flagrush/services/auth/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        notesRoute: (context) => const NotesView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      }));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
