import 'package:flutter/material.dart';
import 'package:instagram_t/colors.dart';

class InstagramtPost extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Container(
            color: AppColors.headerColor,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                    backgroundImage: NetworkImage(
                      'https://wac-cdn.atlassian.com/dam/jcr:ba03a215-2f45-40f5-8540-b2015223c918/Max-R_Headshot%20(1).jpg?cdnVersion=836',
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // Post image
          Image.network(imageUrl),
          // Post caption
          Container(
            color: AppColors.bottomColor,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.thumb_up_sharp,
                          size: 20,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.comment,
                          size: 20,
                          color: Colors.white,
                        ))
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Flexible(
                        child: Text(
                          caption,
                          style: TextStyle(fontSize: 16.0),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
