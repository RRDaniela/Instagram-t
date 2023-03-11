import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      title: 'Material App',
      home: Scaffold(
          body: Column(children: [
        Container(
          margin: EdgeInsets.only(top: 70),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/stacked_logo.png'),

            // ignore: prefer_const_constructors
            Container(
              margin: EdgeInsets.only(left: 10),
              child: const Text(
                "Instagram't",
                // ignore: prefer_const_constructors
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
        ),
        const Text("Let's get you started",
            style: TextStyle(fontSize: 16, fontFamily: 'Montserrat-medium')),
        Container(
          margin: const EdgeInsets.only(top: 40),
        ),
        SizedBox(
          width: 350,
          height: 50,
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: 'your_email@example.com',
                fillColor: Color(0xC4B2BC)),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 40),
        ),
        SizedBox(
          width: 350,
          height: 50,
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                hintText: '**********',
                fillColor: Color(0xC4B2BC)),
          ),
        ),
      ])),
    );
  }
}
