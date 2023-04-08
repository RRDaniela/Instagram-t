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
      backgroundColor: (AppColors.blackColor),
      appBar: AppBar(
        backgroundColor: (AppColors.blackColor),
        title: Text(
          "Instagramt",
          style: TextStyle(color: AppColors.imageColor),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.message_outlined,
              color: AppColors.outlinedIcons,
            ),
            onPressed: () {},
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.favorite_border_outlined,
                color: AppColors.outlinedIcons,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
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
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.navBar,
        child: Container(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.home),
                color: AppColors.imageColor,
              ),
              FloatingActionButton(
                backgroundColor: AppColors.navBarButton,
                onPressed: () {
                  //TODO: SEND TO ADD SCREEN
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddScreen()),
                  );*/
                },
                child: Icon(Icons.add),
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
