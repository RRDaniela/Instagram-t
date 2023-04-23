import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/add_post.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/item_post.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/providers/userData_provider.dart';
import 'package:instagram_t/screens/login_screen.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
        body: Consumer<UserDataProvider>(builder: (context, provider, child) {
      return Container(
        color: AppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enter your username',
                    style: TextStyle(
                        color: AppColors.onPrimaryContainer,
                        fontSize: 25,
                        fontFamily: 'Garamond',
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.none)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 300,
                            decoration: BoxDecoration(
                                color: AppColors.background,
                                border: Border.all(
                                  color: AppColors.outline,
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: TextField(
                                controller: context
                                    .read<UserDataProvider>()
                                    .usernameController,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  border: InputBorder.none,
                                ),
                              ),
                            )),
                      ]),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 300,
                    height: 50,
                    child: TextButton(
                      onPressed: () async {
                        await context.read<UserDataProvider>().crearUsuario();
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(
                            fontFamily: 'Garamond',
                            color: AppColors.onPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary),
                    ))
              ],
            )
          ],
        ),
      );
    }));
  }
}
