import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_t/profile.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _userDataSubscription;

  ProfileProvider();

  static ProfileProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<ProfileProvider>(context, listen: listen);

  Map<String, dynamic>? _userData;
  int _followersCount = 0;
  int _postsCount = 0;
  int _followingCount = 0;
  List<Map<String, dynamic>> posts = [];
  String _profilePicture =
      "https://cdn5.vectorstock.com/i/1000x1000/17/44/person-icon-in-line-style-man-symbol-vector-24741744.jpg";
  String _userName = "";
  String _description = "";

  void updateUserData(Map<String, dynamic> userData) {
    _userData = userData;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getUserData(
      String userId, BuildContext context) async {
    _clearData();
    await _fetchUserData(userId);
    _subscribeToUserData(userId);
    Provider.of<ProfileProvider>(context, listen: false)
        .updateUserData(_userData!);

    return _userData!;
  }

  Future<void> _fetchUserData(String userId) async {
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
  }

  void updateFollowersCount(String userId, int followersCount) {
    if (_userData != null && _userData!['id'] == userId) {
      _userData!['followers_count'] = followersCount;
      notifyListeners();
    }
  }

  void _subscribeToUserData(String userId) {
    final userQuery = FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: userId)
        .limit(1);

    _userDataSubscription = userQuery.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final DocumentSnapshot<Map<String, dynamic>> userDoc =
            snapshot.docs.first;
        _userData = userDoc.data();
        _setFollowersCount();
        _setPostsCount();
        _setFollowingCount();
        _setProfilePicture();
        _setUsername();
        _setDescription();
        notifyListeners();
      }
    });
  }

  void _setFollowersCount() {
    if (_userData != null && _userData!['followers'] != null) {
      _followersCount = _userData!['followers_count'];
    }
  }

  int getFollowersCount() {
    return _followersCount;
  }

  @override
  void dispose() {
    _userDataSubscription?.cancel();
    super.dispose();
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
    if (_userData != null && _userData!['following_count'] != null) {
      _followingCount = _userData!['following_count'];
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

  void _setUsername() async {
    if (_userData != null && _userData!['username'] != null) {
      _userName = _userData!['username'];
      posts =
          await getPostsForUsername(_userName); // Fetch posts for the username
    }
  }

  String getUsername() {
    return _userName;
  }

  Future<List<Map<String, dynamic>>> getPostsForUsername(String id) async {
    List<Map<String, dynamic>> posts = [];

    final QuerySnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection('users')
        .where('id', isEqualTo: id)
        .get();
    if (user.docs.isNotEmpty) {
      String username = user.docs.first.data()['username'];

      final QuerySnapshot<Map<String, dynamic>> postDocs =
          await FirebaseFirestore.instance
              .collection('posts')
              .where('username', isEqualTo: username)
              .orderBy('timestamp', descending: true)
              .get();
      print('Number of postDocs: ${postDocs.docs.length}');
      posts = postDocs.docs.map((doc) {
        final data = doc.data();
        return data;
      }).toList();
    }

    return posts;
  }

  void _clearData() {
    _userData = null;
    _followersCount = 0;
    _postsCount = 0;
    _followingCount = 0;
    posts.clear();
    _profilePicture =
        "https://cdn5.vectorstock.com/i/1000x1000/17/44/person-icon-in-line-style-man-symbol-vector-24741744.jpg";
    _userName = "";
    _description = "";
  }
}
