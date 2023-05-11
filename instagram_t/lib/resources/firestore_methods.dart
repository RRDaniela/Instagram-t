import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_t/models/posts.dart';

class FirestoreMethods {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirestoreMethods _firestoreMethods =
      FirestoreMethods._internal();

  factory FirestoreMethods() {
    return _firestoreMethods;
  }

  // Decrement the followers count of the other user
  Future<void> decrementFollowersCount(
      String otherUserId, String current_user_id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: otherUserId)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      int followersCount = documentSnapshot['followers_count'] ?? 0;

      await documentSnapshot.reference.update({
        'followers_count': followersCount - 1,
        'followers': FieldValue.arrayRemove([current_user_id]),
      });
    }
  }

  // Decrement the following count of the current user
  Future<void> decrementFollowingCount(
      String otherUserid, String currentUserId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: currentUserId)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      int followingCount = documentSnapshot['following_count'] ?? 0;

      await documentSnapshot.reference.update({
        'following_count': followingCount - 1,
        'following': FieldValue.arrayRemove([otherUserid])
      });
    }
  }

  // Decrement the followers count of the other user
  Future<void> incrementFollowersCount(
      String otherUserId, String current_user_id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: otherUserId)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      int followersCount = documentSnapshot['followers_count'] ?? 0;

      await documentSnapshot.reference.update({
        'followers_count': followersCount + 1,
        'followers': FieldValue.arrayUnion([current_user_id]),
      });
    }
  }

  // Decrement the following count of the current user
  Future<void> incrementFollowingCount(
      String otherUserid, String currentUserId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: currentUserId)
        .limit(1)
        .get();

    if (querySnapshot.size > 0) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
      int followingCount = documentSnapshot['following_count'] ?? 0;

      await documentSnapshot.reference.update({
        'following_count': followingCount + 1,
        'following': FieldValue.arrayUnion([otherUserid])
      });
    }
  }

  Future<bool> isFollowing(String idFollowing, String idFollower) async {
    final querySnapshot =
        await _db.collection("users").where("id", isEqualTo: idFollower).get();

    if (querySnapshot.docs.isNotEmpty) {
      final user = querySnapshot.docs.first.data();
      final followers = user['followers'] as List<dynamic>?;

      if (followers != null && followers.contains(idFollowing)) {
        return true;
      } else {
        return false;
      }
    }

    return false;
  }

  Future<bool> likePost(String postId, String uid) async {
    bool res = false;

    try {
      // Get post by document id
      DocumentSnapshot<Map<String, dynamic>> post =
          await _db.collection("posts").doc(postId).get();

      if (post.exists) {
        Post postObj = Post.fromSnap(post);

        if (postObj.likes.contains(uid)) {
          postObj.likes.remove(uid);
        } else {
          postObj.likes.add(uid);
          res = true;
        }

        await _db.collection("posts").doc(postId).update(postObj.toJson());
      }
    } catch (e) {
      print("Error liking post");
      print(e);
    }

    return res;
  }

  Future<bool> isPostLiked(String postId, String uid) async {
    bool res = false;

    try {
      DocumentSnapshot<Map<String, dynamic>> post =
          await _db.collection("posts").doc(postId).get();

      if (post.exists) {
        Post postObj = Post.fromSnap(post);

        if (postObj.likes.contains(uid)) {
          res = true;
        }
      }
    } catch (e) {}

    return res;
  }

  FirestoreMethods._internal();
}
