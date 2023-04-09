import 'package:flutter/material.dart';
import 'package:instagram_t/colors.dart';

class InstagramtPost extends StatefulWidget {
  final String imageUrl;
  final String username;
  final String caption;
  final String likes;
  final String profileImageUrl;
  const InstagramtPost(
      {super.key,
      required this.imageUrl,
      required this.username,
      required this.caption,
      required this.likes,
      required this.profileImageUrl});

  @override
  State<InstagramtPost> createState() => _InstagramtPostState();
}

class _InstagramtPostState extends State<InstagramtPost> {
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post header
            Container(
              decoration: BoxDecoration(
                color: AppColors.headerColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(widget.profileImageUrl),
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      widget.username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // Post image
            ClipRRect(
              child: Container(
                width: 400,
                height: 400,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Post caption
            Container(
              decoration: BoxDecoration(
                color: AppColors.bottomColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
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
                            color: AppColors.outlinedIcons,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.message_outlined,
                            size: 20,
                            color: AppColors.outlinedIcons,
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Flexible(
                          child: Text(
                            widget.username,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColorGrey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .55,
                              child: Text(
                                widget.caption,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: AppColors.textColorGrey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
    );
  }
}
