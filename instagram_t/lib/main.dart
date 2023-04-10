import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:instagram_t/screens/login_screen.dart';
import 'package:instagram_t/screens/signup_screen.dart';
import 'package:instagram_t/home_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      debugShowCheckedModeBanner: false,
      home: SignupScreen(),
    );
  }
}
