import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static Future<User?> registerUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;

      await user!.reload();
      user = auth.currentUser;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      }
      if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    }

    return user;
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided.');
      }
    }

    return user;
  }

  static Future signupWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    try {
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw Exception('The account already exists with a different credential.');
      } else if (e.code == 'invalid-credential') {
        throw Exception('Error occurred while accessing credentials. Try again.');
      }
    } catch (e) {
      throw Exception('Error occurred using Google Sign-In. Try again.');
    }

    return user;
  }

  static Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
        throw Exception('Google Sign In was unsuccessful. Try again.');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseAuth auth = FirebaseAuth.instance;

    User? user;

    try {
        UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;

        // Check if user is new
        if (userCredential.additionalUserInfo!.isNewUser) {
            // If new, fail and ask user to sign up
            throw Exception('Please sign up first.');
        }
    } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
            throw Exception('The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
            throw Exception('Error occurred while accessing credentials. Try again.');
        } else if (e.code == 'user-not-found') {
            throw Exception('No user found for this email.');
        } else if (e.code == 'wrong-password') {
            throw Exception('Wrong password provided for that user.');
        }
    } catch (e) {
        throw Exception('Error occurred using Google Sign-In. Try again.');
    }

    return user;
}


  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  static Future<void> signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signOut();
  }

  // Create method to check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      FirebaseApp firebaseApp = await Firebase.initializeApp();
      FirebaseAuth auth = FirebaseAuth.instance;

      User? user = auth.currentUser;

      await user?.reload();
      user = auth.currentUser;

      if (user == null) {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  // Create method to get the current user
  static User getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    return user!;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
}
