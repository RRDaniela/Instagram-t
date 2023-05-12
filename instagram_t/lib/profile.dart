import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/add_post.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/home_page.dart';
import 'package:instagram_t/providers/profile_provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:instagram_t/user-edit.dart';

class Profile extends StatefulWidget {
  final User current_user;

  Profile({
    super.key,
    required this.current_user,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> _refreshPage() async {
    setState(() {});
  }

  late Future<Map<String, dynamic>> _userDataFuture;
  late Future<List<Map<String, dynamic>>> _postsFuture;
  bool _isListView = false;

  Map<String, dynamic>? _userData;
  TextStyle myTextStyle = TextStyle(
    fontSize: 15, // Set font size
    fontWeight: FontWeight.bold, // Set font weight
  );
  void fetchUserDataAndPosts() async {
    _userDataFuture = Provider.of<ProfileProvider>(context, listen: false)
        .getUserData(widget.current_user.uid, context);
    _postsFuture = Provider.of<ProfileProvider>(context, listen: false)
        .getPostsForUsername(widget.current_user.uid);
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
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    int crossAxisCount = _isListView ? 1 : 3;
    double aspectRatio = 1.0;
    /* if (itemCount > 4 && !_isListView) {
      crossAxisCount = 3;
      aspectRatio = 1.0;
    } */
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          context.read<ProfileProvider>().getUsername().toLowerCase(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.edit,
                color: AppColors.outlinedIcons,
              ),
              onPressed: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserEdit(current_user: widget.current_user,)),);
              })
        ],
      ),
      body: Consumer<ProfileProvider>(builder: (context, profileProvider, _) {
        return FutureBuilder(
            future: Future.wait([
              _userDataFuture,
              _postsFuture,
            ]),
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final userData = snapshot.data![0] as Map<String, dynamic>;
                final posts = snapshot.data![1] as List<Map<String, dynamic>>;

                return Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              child: ClipOval(
                                  child: SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  context
                                      .read<ProfileProvider>()
                                      .getProfilePicture()
                                      .toString(),
                                  fit: BoxFit.cover,
                                ),
                              )),
                              radius: 50,
                            ),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textColorGrey),
                              '@' +
                                  context
                                      .read<ProfileProvider>()
                                      .getUsername()
                                      .toLowerCase()),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          context
                              .read<ProfileProvider>()
                              .getDescription()
                              .toLowerCase()),
                    ]),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(style: myTextStyle, posts.length.toString()),
                              Text(
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.textColorGrey),
                                  "posts")
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  style: myTextStyle,
                                  context
                                      .read<ProfileProvider>()
                                      .getFollowersCount()
                                      .toString()),
                              Text(
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.textColorGrey),
                                  "followers")
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  style: myTextStyle,
                                  context
                                      .read<ProfileProvider>()
                                      .getFollowingCount()
                                      .toString()),
                              Text(
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: AppColors.textColorGrey),
                                  "following")
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isListView = false;
                            });
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Icon(
                              Icons.grid_3x3,
                              color: _isListView
                                  ? AppColors.outlinedIcons
                                  : Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isListView = true;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.list,
                              color: _isListView
                                  ? Colors.black
                                  : AppColors.outlinedIcons,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        userData['number_of_posts'] == 0
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                              "https://cliply.co/wp-content/uploads/2021/09/142109670_SAD_CAT_400.gif",
                                              height: 200,
                                              width: 200,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            'Nothing new.',
                                            textStyle: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins'),
                                            speed: const Duration(
                                                milliseconds: 200),
                                          ),
                                          TypewriterAnimatedText(
                                            'Add a post!',
                                            textStyle: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins'),
                                            speed: const Duration(
                                                milliseconds: 200),
                                          ),
                                        ],
                                        totalRepeatCount: 1,
                                        pause:
                                            const Duration(milliseconds: 100),
                                        displayFullTextOnTap: true,
                                        stopPauseOnTap: true,
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                child: SizedBox(
                                height: 300,
                                width: 350,
                                child: LiquidPullToRefresh(
                                    color: AppColors.primary,
                                    onRefresh: _refreshPage,
                                    child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 2.0,
                                        mainAxisSpacing: 2.0,
                                        childAspectRatio: aspectRatio,
                                      ),
                                      itemCount: posts.length,
                                      itemBuilder: (context, index) {
                                        final post = posts[index];
                                        return Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                  color: AppColors.background,
                                                  width: 2.0),
                                            ),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                child: CachedNetworkImage(
                                                    memCacheHeight: _isListView ? 1000 : 310,
                                                    memCacheWidth: _isListView ? 1000 : 310,
                                                    imageUrl: post['imageUrl'],
                                                    
                                                    fit: BoxFit.cover,
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Shimmer(
                                                              direction:
                                                                  ShimmerDirection
                                                                      .fromLeftToRight(), //Default value: Duration(seconds: 0)
                                                              child: Container(
                                                                width: 360,
                                                                height: 350,
                                                                color: Colors
                                                                    .grey[300],
                                                              ),
                                                            ))),
                                          ),
                                        );
                                      },
                                    )),
                              )),
                      ],
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
