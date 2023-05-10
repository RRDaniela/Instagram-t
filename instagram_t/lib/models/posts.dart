import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String username;
  final String id;
  final timestamp;
  final String imageUrl;
  final List<dynamic> likes;

  Post({
    required this.caption,
    required this.username,
    required this.id,
    required this.timestamp,
    required this.imageUrl,
    required this.likes,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    print(snapshot);

    return Post(
      caption: snapshot["caption"],
      username: snapshot["username"],
      id: snap.id,
      timestamp: snapshot["timestamp"],
      imageUrl: snapshot["imageUrl"],
      likes: snapshot["likes"],
    );
  }

  Map<String, dynamic> toJson() => {
        'caption': caption,
        'username': username,
        'id': id,
        'timestamp': timestamp,
        'imageUrl': imageUrl,
        'likes': likes,
      };
}
