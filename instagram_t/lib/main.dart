import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/home_page.dart';
import 'package:instagram_t/providers/profile_provider.dart';
import 'package:instagram_t/providers/searchUser_provider.dart';
import 'package:instagram_t/providers/userData_provider.dart';
import 'package:instagram_t/providers/user_profile_provider.dart';
import 'package:instagram_t/screens/signup_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => SearchUserProvider(),
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
        home: FutureBuilder(
          future: Auth.isLoggedIn(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == true) {
                return HomePage(
                  current_user: Auth.getCurrentUser(),
                );
              } else {
                return SignupScreen();
              }
            } else {
              return Container(color: Colors.white);
            }
          },
        ));
  }
}
