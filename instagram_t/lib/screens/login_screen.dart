import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Hello Again!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
              const SizedBox(height: 10),
              const Text(
                'Log into your account',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 50),
              // Email textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                        ),
                      ),
                    )),
              ),
              const SizedBox(height: 10),

              // Password textfield
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                        ),
                      ),
                    )),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Text(
                    'Sign In',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              )
            ],
          ),
        ));
  }
}
