import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_t/models/posts.dart';

class FirestoreMethods {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirestoreMethods _firestoreMethods =
      FirestoreMethods._internal();

  factory FirestoreMethods() {
    return _firestoreMethods;
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
