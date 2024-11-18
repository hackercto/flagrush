import 'package:firebase_core/firebase_core.dart';
import 'package:flagrush/firebase_options.dart';
import 'package:flagrush/services/auth/auth_user.dart';
import 'package:flagrush/services/auth/auth_provider.dart';
import 'package:flagrush/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'dart:developer' as devtools show log;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        devtools.log('The password provided is too weak.');
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        devtools.log('The account already exists for that email.');
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        devtools.log('The email provided is invalid.');
        throw InvalidEmailAuthException();
      } else {
        devtools.log(e.message.toString());
        throw GenericAuthException();
      }
    } catch (e) {
      devtools.log(e.toString());
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        devtools.log('No user found for that email.');
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        devtools.log('Wrong password provided for that user.');
        throw InvalidPasswordAuthException();
      } else {
        devtools.log(e.message.toString());
        throw GenericAuthException();
      }
    } catch (e) {
      devtools.log(e.toString());
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
