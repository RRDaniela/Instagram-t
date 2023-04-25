import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/screens/userData.dart';

class UserPictureProvider with ChangeNotifier {
  static final UserPictureProvider _UserPictureProvider =
      UserPictureProvider._internal();
  factory UserPictureProvider() {
    return _UserPictureProvider;
  }

  UserPictureProvider._internal();
}
