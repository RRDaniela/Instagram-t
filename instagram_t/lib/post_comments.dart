import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class PostComments extends StatefulWidget {
  final String postId;
  final String user_id;

  const PostComments({Key? key, required this.user_id, required this.postId})
      : super(key: key);

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  final TextEditingController _commentController = TextEditingController();

  late Future<Map<String, dynamic>> _userDataFuture;
  late Future<List<Map<String, dynamic>>> _postsFuture;

  late Stream<DocumentSnapshot> _postStream;
  void fetchUserDataAndPosts() async {
    _userDataFuture = Provider.of<ProfileProvider>(context, listen: false)
        .getUserData(widget.user_id, context);
    _postsFuture = Provider.of<ProfileProvider>(context, listen: false)
        .getPostsForUsername(widget.user_id);
    await _userDataFuture;
    await _postsFuture;
  }

  @override
  void initState() {
    super.initState();
    fetchUserDataAndPosts();
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _postStream = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .snapshots();
    final profileProvider = Provider.of<ProfileProvider>(context);
    final imageUrl = profileProvider.getProfilePicture();
    final username = profileProvider.getUsername();

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: Text(
            'Comments',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.onSurface,
            ),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: _postStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var post = snapshot.data!.data() as Map<String, dynamic>;
              return Container(
                color: AppColors.background,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: post['comments'].length,
                        itemBuilder: (context, index) {
                          final comment = post['comments'][index];
                          return ListTile(
                            title: Text(comment['username'] ?? ''),
                            subtitle: Text(comment['comment'] ?? ''),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(comment['imageUrl'] ?? ''),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                            hintText: 'Add a comment...',
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.outline)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.primary))),
                        onSubmitted: (comment) {
                          addComment(comment);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void addComment(String comment) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final username = profileProvider.getUsername();
    final imageUrl = profileProvider.getProfilePicture();

    final commentData = {
      'username': username,
      'comment': comment,
      'imageUrl': imageUrl,
    };

    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.postId);
    final postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      final commentsList =
          List<Map<String, dynamic>>.from(postSnapshot['comments']);
      commentsList.add(commentData);
      await postRef.update({'comments': commentsList});
    }

    // Clear the comment text field
    _commentController.clear();
  }
}
