import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_t/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';
import 'package:instagram_t/screens/userData.dart';

import '../colors.dart';

class SignupScreen extends StatefulWidget {
  final Auth auth;
  const SignupScreen({required this.auth, Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: StreamBuilder<User?>(
            stream: widget.auth.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserData(
                              auth: widget.auth,
                            )),
                  );
                });
              }

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
                                fontSize: 40,
                                fontFamily: 'PlayFair'),
                          ),
                        ],
                      ),
                      const Text(
                        'Let\'s get you started',
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Garamond',
                            fontWeight: FontWeight.bold),
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
                                    fontFamily: 'Garamond',
                                    fontWeight: FontWeight.normal)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                  fontFamily: 'Garamond',
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
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
                              await widget.auth.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);

                              // Add navigator push to home page

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserData(
                                            auth: widget.auth,
                                          )));
                            } on FirebaseException catch (e) {
                              print(e);
                              _error = e.message!;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: AppColors.onPrimary,
                                  fontSize: 20,
                                  fontFamily: 'Garamond',
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen(auth: widget.auth)),
                          );
                        },
                        child: Text(
                          'Already have an account? Sign In',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontFamily: 'Garamond',
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      Text(
                        _error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
