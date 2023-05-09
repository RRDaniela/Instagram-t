import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/colors.dart';

class InstagramtPost extends StatefulWidget {
  final String imageUrl;
  final String username;
  final String caption;
  final String likes;
  const InstagramtPost(
      {super.key,
      required this.imageUrl,
      required this.username,
      required this.caption,
      required this.likes});

  // Find profile image from username using firebase

  @override
  State<InstagramtPost> createState() => _InstagramtPostState();
}

class _InstagramtPostState extends State<InstagramtPost> {
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrl();
  }

  Future<String> getProfileImageUrl(String username) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    final QuerySnapshot userSnapshot = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final imageUrl = userSnapshot.docs.first['image'];
      return imageUrl;
    }

    return 'https://static.vecteezy.com/system/resources/previews/008/442/086/original/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg'; // Return an empty string or default image URL if not found
  }

  Future<void> _fetchProfileImageUrl() async {
    final imageUrl = await getProfileImageUrl(widget.username);
    setState(() {
      _profileImageUrl = imageUrl;
    });
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post header
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: NetworkImage(_profileImageUrl ??
                              'https://static.vecteezy.com/system/resources/previews/008/442/086/original/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg'),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          widget.username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onPrimaryContainer),
                        ),
                      ],
                    ),
                  ),
                ),
                // Post image
                Container(
                  color: AppColors.surface,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 300,
                          height: 300,
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Post caption
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border_outlined,
                                size: 20,
                                color: AppColors.onSurfaceVariant,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.message_outlined,
                                size: 20,
                                color: AppColors.onSurfaceVariant,
                              ))
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              widget.username,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurfaceVariant),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .8,
                              child: Text(
                                widget.caption,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppColors.onSurfaceVariant),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
