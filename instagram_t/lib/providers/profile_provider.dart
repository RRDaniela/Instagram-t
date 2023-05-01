import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_t/profile.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  static final ProfileProvider _profileProvider = ProfileProvider._internal();
  factory ProfileProvider() {
    return _profileProvider;
  }

  ProfileProvider._internal();

  Map<String, dynamic>? _userData;
  int _followersCount = 0;
  int _postsCount = 0;
  int _followingCount = 0;
  List<Map<String, dynamic>> posts = [];
  String _profilePicture =
      "https://cdn5.vectorstock.com/i/1000x1000/17/44/person-icon-in-line-style-man-symbol-vector-24741744.jpg";
  String _userName = "";
  String _description = "";

  Future<Map<String, dynamic>> getUserData(String userId) async {
    final QuerySnapshot<Map<String, dynamic>> userDocs = await FirebaseFirestore
        .instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .limit(1)
        .get();
    if (userDocs.docs.isEmpty) {
      throw Exception('User document not found');
    }

    final DocumentSnapshot<Map<String, dynamic>> userDoc = userDocs.docs.first;
    _userData = userDoc.data();
    _setFollowersCount();
    _setPostsCount();
    _setFollowingCount();
    _setProfilePicture();
    _setUsername();
    _setDescription();

    posts = await getPostsForUsername(_userData!['username'].toString());
    return _userData!;
  }

  void _setFollowersCount() {
    if (_userData != null && _userData!['followers'] != null) {
      _followersCount = _userData!['followers'];
    }
  }

  int getFollowersCount() {
    return _followersCount;
  }

  void _setPostsCount() {
    if (_userData != null && _userData!['number_of_posts'] != null) {
      _postsCount = _userData!['number_of_posts'];
    }
  }

  int getPostsCount() {
    return _postsCount;
  }

  void _setFollowingCount() {
    if (_userData != null && _userData!['following'] != null) {
      _followingCount = _userData!['following'];
    }
  }

  int getFollowingCount() {
    return _followingCount;
  }

  void _setProfilePicture() {
    if (_userData != null && _userData!['image'] != null) {
      _profilePicture = _userData!['image'];
    }
  }

  String getProfilePicture() {
    return _profilePicture;
  }

  void _setDescription() {
    if (_userData != null && _userData!['description'] != null) {
      _description = _userData!['description'];
    }
  }

  String getDescription() {
    return _description;
  }

  void _setUsername() {
    if (_userData != null && _userData!['username'] != null) {
      _userName = _userData!['username'];
    }
  }

  String getUsername() {
    return _userName;
  }

  Future<List<Map<String, dynamic>>> getPostsForUsername(String id) async {
    final QuerySnapshot<Map<String, dynamic>> postDocs = await FirebaseFirestore
        .instance
        .collection('posts')
        .where('id', isEqualTo: id)
        .orderBy('timestamp', descending: true)
        .get();

    return postDocs.docs.map((doc) {
      final data = doc.data();
      return data;
    }).toList();
  }
}
