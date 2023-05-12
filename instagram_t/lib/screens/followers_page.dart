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

class FollowersPage extends StatefulWidget {
  //final User current_user;
  
  final Map<String, dynamic>? user_follow;
  FollowersPage({super.key, required this.user_follow,});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  List<Map<String, dynamic>> followersList = [];
  @override
  Widget build(BuildContext context) {
    getFollowers();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            "Followers",
          ),
          
        ),
      body: ListView.builder(
        itemCount: followersList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(followersList[index]['username']),
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                followersList[index]['image']
              ),
            ),
          );
        },
      )
    );
  }

  void getFollowers() async {
  QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
  .collection('users')
  .where('following', arrayContains: widget.user_follow!['id'])
  .get();

  List<Map<String, dynamic>> following = [];

  followersSnapshot.docs.forEach((followersDoc) {
    Map<String, dynamic> followersData = followersDoc.data() as Map<String, dynamic>;
    following.add(followersData);
   });

   if (mounted) {
    setState(() {
      followersList = following;
    });
  }
}



}


