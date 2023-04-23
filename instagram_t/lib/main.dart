import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/providers/userData_provider.dart';

import 'package:instagram_t/screens/login_screen.dart';
import 'package:instagram_t/screens/signup_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_t/home_page.dart';
import 'package:instagram_t/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Auth auth;
  Firebase.initializeApp().then((value) {
    auth = Auth();
    runApp(MultiBlocProvider(providers: [
      ChangeNotifierProvider(
        create: (context) => UserDataProvider(),
      )
    ], child: MyApp(auth: auth)));
  });
}

class MyApp extends StatelessWidget {
  final Auth auth;

  MyApp({required this.auth, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      debugShowCheckedModeBanner: false,
      home: SignupScreen(auth: auth),
    );
  }
}
