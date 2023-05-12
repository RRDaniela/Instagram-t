import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/home_page.dart';
import 'package:instagram_t/item_post.dart';
import 'package:instagram_t/screens/post_info.dart';
import 'package:instagram_t/user_profile.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:instagram_t/models/posts.dart';
import 'package:instagram_t/profile.dart';

import 'add_post.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Obtén una instancia de Firestore
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Define una referencia a la colección "posts"
final CollectionReference postsCollection = firestore.collection('posts');

class UserList extends StatefulWidget {
  final User current_user;
  const UserList({super.key, required this.current_user});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  bool _showGridView = true;
  TextEditingController _userSearchController = TextEditingController();
  String _search = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBarAnimation(
                  textEditingController: _searchController,
                  isOriginalAnimation: false,
                  buttonBorderColour: Colors.black45,
                  trailingWidget: Icon(
                    Icons.search,
                    color: (AppColors.outlinedIcons),
                  ),
                  buttonWidget: Icon(Icons.search),
                  secondaryButtonWidget:
                      Icon(Icons.search, color: (AppColors.outlinedIcons)),
                  onChanged: (value) {
                    searchUsers(value);
                    setState(() {
                      _showGridView = false;
                    });
                  },
                  onFieldSubmitted: (String value) {
                    debugPrint('onFieldSubmitted value $value');
                  },
                ),
              ),
              if (_showGridView)
                StreamBuilder<QuerySnapshot>(
                  stream: postsCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final documents = snapshot.data!.docs;
                    documents.sort((a, b) {
                      final likesA = (a.data()
                          as Map<String, dynamic>)['likes_count'] as int;
                      final likesB = (b.data()
                          as Map<String, dynamic>)['likes_count'] as int;
                      return likesB.compareTo(likesA); // Orden descendente
                    });
                    return Container(
                      height: 550,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: postsCollection.snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  3, // Set the number of images per row here
                              crossAxisSpacing:
                                  5, // Set the spacing between images horizontally
                              mainAxisSpacing: 5,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final imageUrl = (documents[index].data()
                                  as Map<String, dynamic>)['imageUrl'];
                              final likes = (documents[index].data()
                                  as Map<String, dynamic>)['likes'];
                              final postId = (documents[index].data()
                                  as Map<String, dynamic>)['id'];
                              final username = (documents[index].data()
                                  as Map<String, dynamic>)['username'];
                              final caption = (documents[index].data()
                                  as Map<String, dynamic>)['caption'];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PostInfo(
                                        Nlikes: likes.toString(),
                                        postId: postId.toString(),
                                        imageUrl: imageUrl.toString(),
                                        username: username.toString(),
                                        caption: caption.toString(),
                                        current_user: widget.current_user,
                                        user: widget.current_user,
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) => Shimmer(
                                    direction: ShimmerDirection
                                        .fromLeftToRight(), //Default value: Duration(seconds: 0)
                                    child: Container(
                                      width: 300,
                                      height: 300,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              if (!_showGridView)
                Container(
                  height: 550,
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final username = _searchResults[index];

                      return ListTile(
                        title: Text(username),
                        onTap: () => navigateToProfile(username),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomePage(current_user: widget.current_user)));
                },
                icon: Icon(Icons.home),
                color: AppColors.onSurface,
              ),
              FloatingActionButton(
                backgroundColor: AppColors.onSurfaceVariant,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddPost(current_user: widget.current_user)),
                  );
                },
                child: Icon(Icons.add, color: AppColors.onTertiary),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Profile(current_user: widget.current_user)));
                },
                icon: Icon(Icons.person_2_rounded),
                color: AppColors.onSurface,
              )
            ],
          ),
        ),
      ),
    );
  }

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
    _usersCollection
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThan: query + 'z')
        .get()
        .then((snapshot) {
      setState(() {
        _searchResults = List<String>.from(snapshot.docs.map((doc) =>
            (doc.data() as Map<String, dynamic>)['username'] as String));
      });
    }).catchError((error) {
      print('Error searching users: $error');
    });
  }

  navigateToProfile(String username) async {
    final user = await getUserIdFromUsername(username);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserProfile(
                  current_user: widget.current_user,
                  user_follow: user,
                )));
  }
}
