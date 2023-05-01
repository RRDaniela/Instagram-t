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
                      backgroundImage: NetworkImage(widget.profileImageUrl),
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
    );
  }
}
