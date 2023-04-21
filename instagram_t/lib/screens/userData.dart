import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/add_post.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/item_post.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/screens/login_screen.dart';

class UserData extends StatefulWidget {
  final Auth auth;
  UserData({super.key, required this.auth});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  User? currentUser;
  @override
  void initState() {
    super.initState();
    currentUser = widget.auth.currentUser;
  }

  Widget build(BuildContext context) {
    return Container(
      child: Text('${currentUser?.email}'),
    );
  }
}
