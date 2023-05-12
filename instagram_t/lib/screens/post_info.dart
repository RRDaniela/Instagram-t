import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/item_post.dart';
import 'package:instagram_t/screens/login_screen.dart';
import 'package:instagram_t/users_search.dart';

class PostInfo extends StatefulWidget {
  final String Nlikes;
  final String postId;
  final String imageUrl;
  final String username;
  final String caption;
  final User current_user;
  final User user;

  const PostInfo({
    Key? key,
    required this.Nlikes,
    required this.postId,
    required this.imageUrl,
    required this.username,
    required this.caption,
    required this.current_user,
    required this.user,
  }) : super(key: key);
  @override
  State<PostInfo> createState() => _PostInfoState();
}

class _PostInfoState extends State<PostInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (AppColors.background),
      appBar: AppBar(
        backgroundColor: (AppColors.background),
        title: Text(
          "Instagramt",
          style: TextStyle(color: AppColors.imageColor),
        ),
      ),
      body: InstagramtPost(
        imageUrl: widget.imageUrl,
        username: widget.username,
        caption: widget.caption,
        postId: widget.postId,
        Nlikes: widget.Nlikes,
        current_user: widget.current_user,
        user: widget.user,
      ),
    );
  }
}
