import 'package:flutter/material.dart';
import 'package:instagram_t/providers/profile_provider.dart';
import 'package:instagram_t/providers/userData_provider.dart';
import 'package:instagram_t/screens/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
    ),
    ChangeNotifierProvider(create: (context) => ProfileProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      debugShowCheckedModeBanner: false,
      home: SignupScreen(),
    );
  }
}
