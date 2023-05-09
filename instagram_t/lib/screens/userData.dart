import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/providers/userData_provider.dart';
import 'package:instagram_t/screens/addPicture.dart';
import 'package:provider/provider.dart';

class UserData extends StatefulWidget {
  final User current_user;
  UserData({super.key, required this.current_user});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  String _error = "";
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<UserDataProvider>(builder: (context, provider, child) {
      
      print(widget.current_user);
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
                        String error = await context
                            .read<UserDataProvider>()
                            .crearUsuario();
                        if (error.isEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPicture(
                                      current_user: widget.current_user,
                                      username: context
                                          .read<UserDataProvider>()
                                          .usernameController
                                          .text)));
                        }
                        setState(() {
                          _error = error;
                        });
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
            ),
            Visibility(
              visible: _error.isNotEmpty,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                          color: AppColors.errorContainer,
                          border:
                              Border.all(color: AppColors.error, width: 2.0)),
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            _error,
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }));
  }
}
