import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getUserName(String userId) async {
    final userSnapshot =
        await _db.collection('users').where('id', isEqualTo: userId).get();
    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data();
      return userData['username'];
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> addPost(String caption, String userId, File imageFile) async {
    // Upload image to Firebase Storage
    final storageRef = _storage.ref().child(
        'PostsPictures/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);
    final imageUrl = await snapshot.ref.getDownloadURL();
    final DateTime timestamp = DateTime.now();
    // Add post to Firestore
    await _db.collection('posts').add({
      'caption': caption,
      'id': userId,
      'imageUrl': imageUrl,
      'likes': [],
      'username': await getUserName(userId),
      'timestamp': await Timestamp.fromDate(timestamp),
    });

    final userRef = _db.collection('users').where('id', isEqualTo: userId);
    final userDocSnapshot = await userRef.get();
    if (userDocSnapshot.docs.isNotEmpty) {
      final userDoc = userDocSnapshot.docs.first.reference;
      await userDoc.update({'number_of_posts': FieldValue.increment(1)});
    } else {
      throw Exception('User not found');
    }
  }
}
