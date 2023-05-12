import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/add_post.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/item_post.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/models/posts.dart';
import 'package:instagram_t/profile.dart';
import 'package:instagram_t/providers/searchUser_provider.dart';
import 'package:instagram_t/screens/login_screen.dart';
import 'package:instagram_t/user_profile.dart';
import 'package:instagram_t/users_search.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User current_user;

  HomePage({required this.current_user, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  Future<List<Map<String, String>>> getUsers() async {
    QuerySnapshot posts = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .get();

    //final List<String> friends = List<String>.from(userDoc.data()['friends']);
    List<Map<String, String>> listElements = [];

    for (var doc in posts.docs) {
      Post post = Post.fromSnap(doc);

      listElements.add({
        'username': post.username,
        'imageUrl': post.imageUrl,
        'caption': post.caption,
        'postId': post.id,
        'Nlikes': post.likes.length.toString()
      });
    }

    return listElements;
  }

  Future<void> _refreshPage() async {
    setState(() {});
  }

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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: AppColors.outlinedIcons,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserList(
                          current_user: widget.current_user,
                        )),
              );
            },
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border_outlined,
                color: AppColors.outlinedIcons,
              )),
          IconButton(
              onPressed: () {
                Auth.signOut();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              icon: Icon(
                Icons.logout,
                color: AppColors.outlinedIcons,
              )),
        ],
      ),
      body: Consumer<SearchUserProvider>(builder: (context, searchProvider, _) {
        return FutureBuilder(
            future: getUsers(),
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, String>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Map<String, String>> listElements = snapshot.data!;
                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshPage,
                        child: ListView.builder(
                          cacheExtent: 9999,
                          controller: _scrollController,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemCount: listElements.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                String username =
                                    listElements[index]["username"]!;
                                searchProvider.navigateToProfile(
                                    context, widget.current_user, username);
                              },
                              child: InstagramtPost(
                                username: listElements[index]["username"]!,
                                imageUrl: listElements[index]["imageUrl"]!,
                                caption: listElements[index]["caption"]!,
                                postId: listElements[index]["postId"]!,
                                Nlikes: listElements[index]["Nlikes"]!,
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              }
            });
      }),
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
}
