import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/add_post.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/item_post.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/profile.dart';
import 'package:instagram_t/screens/login_screen.dart';

class HomePage extends StatefulWidget {
  final Auth auth;

  HomePage({required this.auth, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  Future<List<Map<String, String>>> getUsers() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("posts");
    QuerySnapshot posts = await collectionReference.get();

    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: widget.auth.currentUser!.uid)
        .get();
    final QueryDocumentSnapshot<Map<String, dynamic>> userDoc =
        qs.docs.first as QueryDocumentSnapshot<Map<String, dynamic>>;
    final List<String> friends = List<String>.from(userDoc.data()['friends']);
    List<Map<String, String>> listElements = [];

    if (posts.docs.length != 0) {
      for (var doc in posts.docs) {
        String username = doc.get('username');
        String postImageUrl = doc.get('imageUrl');
        String postLikes = doc.get('likes').toString();
        String postCaption = doc.get('caption');
        if (friends.contains(username)) {
          DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: username)
              .get()
              .then((value) => value.docs.first);
          String profileImageUrl = ''; // check if the 'image' field is present
          if (userDocSnapshot.exists) {
            profileImageUrl = userDocSnapshot.get('image');
          }
          listElements.add({
            'username': username,
            'likes': postLikes,
            'imageUrl': postImageUrl,
            'caption': postCaption,
            'userImageUrl': profileImageUrl,
          });
        }
      }
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
                widget.auth.signOut();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(auth: widget.auth)),
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
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemCount: listElements.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: InstagramtPost(
                                username: listElements[index]["username"]!,
                                likes: listElements[index]["likes"]!,
                                imageUrl: listElements[index]["imageUrl"]!,
                                caption: listElements[index]["caption"]!,
                                profileImageUrl: listElements[index]
                                    ["userImageUrl"]!),
                          ),
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
                        builder: (context) => AddPost(auth: widget.auth)),
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
                          builder: (context) => Profile(auth: widget.auth)));
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
