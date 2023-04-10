import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_t/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:instagram_t/auth.dart';

import '../home_page.dart';

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
        backgroundColor: Colors.white,
        body: StreamBuilder<User?>(
            stream: widget.auth.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.hasData) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(
                              auth: widget.auth,
                            )),
                  );
                });
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png'),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        const Text(
                          'Instagram\'t!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Let\'s get you started',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50),
                    // Email textfield

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Your email address',
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border.all(color: Colors.grey[100]!),
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
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border.all(color: Colors.grey[100]!),
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
                                    builder: (context) => HomePage(
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
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

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
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      _error,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              );
            }));
  }
}
