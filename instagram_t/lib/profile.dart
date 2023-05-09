import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/colors.dart';
import 'package:instagram_t/providers/profile_provider.dart';
import 'package:provider/provider.dart';

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
  late Future<Map<String, dynamic>> _userDataFuture;
  late Future<List<Map<String, dynamic>>> _postsFuture;
  bool _isListView = false;
  Map<String, dynamic>? _userData;
  TextStyle myTextStyle = TextStyle(
    fontSize: 15, // Set font size
    fontWeight: FontWeight.bold, // Set font weight
  );
  @override
  void initState() {
    super.initState();
    _userDataFuture = Provider.of<ProfileProvider>(context, listen: false)
        .getUserData(widget.current_user.uid);
    _postsFuture = Provider.of<ProfileProvider>(context, listen: false)
        .getPostsForUsername(widget.current_user.uid);
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = _isListView ? 1 : 3;
    int itemCount = context.read<ProfileProvider>().getPostsCount().toInt();
    double aspectRatio = 1.0;
    if (itemCount > 4 && !_isListView) {
      crossAxisCount = 3;
      aspectRatio = 1.0;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: Text(
            context.read<ProfileProvider>().getUsername().toLowerCase(),
          ),
        ),
        body: FutureBuilder(
            future: Future.wait([_userDataFuture, _postsFuture]),
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
                              Text(
                                  style: myTextStyle,
                                  context
                                      .read<ProfileProvider>()
                                      .getPostsCount()
                                      .toString()),
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
                            print('tap');
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
                      children: [
                        SingleChildScrollView(
                          child: SizedBox(
                              height: 360,
                              width: 350,
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 2.0,
                                  childAspectRatio: aspectRatio,
                                ),
                                itemCount: itemCount,
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
                                          child: Image.network(post['imageUrl'],
                                              fit: BoxFit.cover)),
                                    ),
                                  );
                                },
                              )),
                        ),
                      ],
                    )
                  ],
                );
              }
            }));
  }
}
