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
import 'package:instagram_t/screens/login_screen.dart';

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
            onPressed: () {},
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
      body: FutureBuilder(
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
                        return InstagramtPost(
                          username: listElements[index]["username"]!,
                          imageUrl: listElements[index]["imageUrl"]!,
                          caption: listElements[index]["caption"]!,
                          postId: listElements[index]["postId"]!,

                        );
                      },
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.surface,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
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
                  //TODO: SEND TO ADD SCREEN
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddScreen()),
                  );*/
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
