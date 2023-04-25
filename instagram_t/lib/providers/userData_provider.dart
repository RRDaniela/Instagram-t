import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/screens/userData.dart';

class UserDataProvider with ChangeNotifier {
  static final UserDataProvider _userDataProvider =
      UserDataProvider._internal();
  factory UserDataProvider() {
    return _userDataProvider;
  }

  UserDataProvider._internal();
  TextEditingController usernameController = TextEditingController();

  Future<String> crearUsuario() async {
    try {
      String username = usernameController.text;
      bool exists = await checkUsernameExists(username);
      if (exists) {
        return 'Username already exists.';
      } else {
        return "";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<bool> checkUsernameExists(String username) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking username: $e');
      return false; // Return false in case of an error
    }
  }
}
