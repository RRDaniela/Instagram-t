import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:instagram_t/providers/userData_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingPage extends StatefulWidget {
  //final User current_user; 
  
  final Map<String, dynamic>? user_follow;
  FollowingPage({super.key, required this.user_follow,});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  List<Map<String, dynamic>> followingList = [];
  @override
  Widget build(BuildContext context) {
    getFollowing();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            "Following",
          ),
          
        ),
      body: ListView.builder(
        itemCount: followingList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(followingList[index]['username']),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                followingList[index]['image']
              ),
            ),
          );
        },
      )
    );
  }

  void getFollowing() async {
  QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
  .collection('users')
  .where('followers', arrayContains: widget.user_follow!['id'])
  .get();

  List<Map<String, dynamic>> following = [];

  followingSnapshot.docs.forEach((followingDoc) {
    Map<String, dynamic> followingData = followingDoc.data() as Map<String, dynamic>;
    following.add(followingData);
   });

   if (mounted) {
    setState(() {
      followingList = following;
    });
  }
}



}


