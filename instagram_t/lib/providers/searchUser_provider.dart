import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_t/post_comments.dart';

import '../user_profile.dart';

class SearchUserProvider with ChangeNotifier {
  Future<Map<String, dynamic>?> getUserIdFromUsername(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      return userData;
    } else {
      return null;
    }
  }

  void searchUsers(String query) {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: query + 'z')
        .get()
        .then((snapshot) {
      final searchResults = List<String>.from(snapshot.docs.map(
          (doc) => (doc.data() as Map<String, dynamic>)['username'] as String));
      // Update the state with search results
      // ...
    }).catchError((error) {
      print('Error searching users: $error');
    });
  }

  void navigateToProfile(
      BuildContext context, User currentUser, String username) async {
    final user = await getUserIdFromUsername(username);
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfile(
            current_user: currentUser,
            user_follow: user,
          ),
        ),
      );
    }
  }

  void navigateToComments(
      BuildContext context, String username, String postId) async {
    final user = await getUserIdFromUsername(username);
    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostComments(
            postId: postId,
            user_id: username,
          ),
        ),
      );
    }
  }
}
