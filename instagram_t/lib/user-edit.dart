import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:instagram_t/providers/userData_provider.dart';

class UserEdit extends  StatefulWidget {
  final User current_user;
  UserEdit({super.key, required this.current_user});

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  String _error = "";
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            "Edit profile",
          ),
          
        ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: GestureDetector(
                    onTap: (){
                      
                    },
                    child: ClipOval(
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          context
                          .read<ProfileProvider>()
                          .getProfilePicture()
                          .toString(),
                          fit: BoxFit.cover,
                        ),
                      )),
                  ),
                    radius: 50,
                ),
              ],
            ),
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
                onPressed: (){},
                    /*onPressed: () async {
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
                      },*/
                      child: Text(
                        'Save changes',
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
        ],
      ),
    );
  }
}