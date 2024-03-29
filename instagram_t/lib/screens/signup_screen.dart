import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_t/home_page.dart';
import 'package:instagram_t/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/screens/userData.dart';

import '../colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _error = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<FirebaseApp> _intializeApp() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => HomePage(
                  current_user: user,
                )),
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: FutureBuilder(
            future: _intializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 200,
                            ),
                            Image.asset('assets/logo.png'),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            const Text(
                              'Instagram\'t!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                        const Text(
                          'Let\'s get you started',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 50),
                        // Email textfield

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Text('Your email address',
                                  style: TextStyle(
                                      color: AppColors.onPrimaryContainer,
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w300)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.background,
                                      border: Border.all(
                                        color: AppColors.outline,
                                      ),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        hintText: 'your_email@example.com',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                    color: AppColors.onPrimaryContainer,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.background,
                                      border: Border.all(
                                        color: AppColors.outline,
                                      ),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: '*********',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),

                        const SizedBox(height: 50),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: GestureDetector(
                            onTap: () async {
                              print(_emailController.value);
                              print(_passwordController.value);

                              try {
                                User? user =
                                    await Auth.registerUsingEmailPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);

                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UserData(current_user: user)),
                                  );
                                }
                              } on Exception catch (e) {
                                setState(() {
                                  _error = e.toString();
                                  _error = _error.replaceAll("Exception:", "");
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                  child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: AppColors.onPrimary,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500),
                              )),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin:
                                    EdgeInsets.only(left: 30.0, right: 15.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 50,
                                ),
                              ),
                            ),
                            Text("or"),
                            Expanded(
                              child: Container(
                                margin:
                                    EdgeInsets.only(left: 15.0, right: 30.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 50,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.all(14),
                              foregroundColor: Colors.black,
                              backgroundColor:
                                  Color(0xFFC4B2BC).withOpacity(0.1),
                              side: BorderSide(
                                  color: Color(0xFF0B3954).withOpacity(0.5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                'assets/g-logo.png',
                                height:
                                    18.0, // You can adjust the size as needed.
                              ),
                            ),
                            label: Text('Sign up with Google'),
                            onPressed: () async {
                              try {
                                var current_user =
                                    await Auth.signInWithGoogle();
                                if (current_user != null) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserData(
                                                current_user: current_user,
                                              )));
                                }
                              } on Exception catch (e) {
                                setState(() {
                                  _error = e.toString();
                                  _error = _error.replaceAll("Exception:", "");
                                });
                                print(e);
                              }
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            'Login instead',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        if (_error.isNotEmpty)
                          (Container(
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.errorContainer,
                              border: Border.all(
                                  color: AppColors.error, width: 2.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  _error,
                                  style: TextStyle(color: AppColors.error),
                                ),
                              ),
                            ),
                          ))
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
