import 'package:flutter/material.dart';
import 'package:instagram_t/item_post.dart';
import 'package:instagram_t/colors.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> _listElements = [
    {
      "username": "icespice",
      "likes": "3",
      "imageUrl":
          "https://www.rollingstone.com/wp-content/uploads/2022/10/ice-spice-ayntk.jpg",
      "caption": "Take a look inside your heart."
    },
    {
      "username": "pinkpantheress",
      "likes": "20",
      "imageUrl":
          "https://www.nme.com/wp-content/uploads/2023/02/NME-HERO-PinkPantheress@2560x1625.jpg",
      "caption": "Waddup"
    },
    {
      "username": "fantano99",
      "likes": "201",
      "imageUrl":
          "https://i.discogs.com/N8oj_tHeuNzl7eaerClVWMIumaj0m39b2_NsDVGItC8/rs:fit/g:sm/q:90/h:400/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTQ1NzU1/MzItMTQ0MDU1MzY5/OC0yNjEzLmpwZWc.jpeg",
      "caption": "Waddup"
    },
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (AppColors.imageColor),
      appBar: AppBar(
        backgroundColor: (AppColors.appBar),
        title: Text(
          "Instagramt",
          style: TextStyle(color: AppColors.imageColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.message,
              color: AppColors.imageColor,
            ),
            onPressed: () {},
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.thumb_up_sharp,
                color: AppColors.imageColor,
              ))
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 550,
              width: 300,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _listElements.length,
                itemBuilder: (BuildContext context, int index) {
                  return InstagramtPost(
                      username: _listElements[index]["username"]!,
                      likes: _listElements[index]["likes"]!,
                      imageUrl: _listElements[index]["imageUrl"]!,
                      caption: _listElements[index]["caption"]!);
                },
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.appBar,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home),
                color: AppColors.imageColor,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add),
                color: AppColors.imageColor,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_2_rounded),
                color: AppColors.imageColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
