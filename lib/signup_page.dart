// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:cafein_beta/home_page.dart';
import 'package:cafein_beta/login_page.dart';
import 'package:cafein_beta/signup_page.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
    final MainColor = Color(0xFFF2D1AF);
    final Logo = Image(image: AssetImage('assets/cafein_logo.png'), fit: BoxFit.cover);
    final Google_login = Image(image: AssetImage('assets/google.png'), fit: BoxFit.cover , width: 16, height: 16, color: Color.fromRGBO(0, 0, 0, 0.50));
    final Facebook_login = Image(image: AssetImage('assets/facebook.png'), fit: BoxFit.cover , width: 16 , height: 16, color: Color.fromRGBO(0, 0, 0, 0.50));
    final Apple_login = Image(image: AssetImage('assets/apple.png'), fit: BoxFit.cover , width: 16 ,height: 16, color: Color.fromRGBO(0, 0, 0, 0.50));
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo,
              SizedBox(height: 50),
              Container(
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: TextField(
                  style: TextStyle(color: SecondColor),
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.people),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: TextField(
                  style: TextStyle(color: SecondColor),
                  decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Icon(Icons.people),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: TextField(
                  style: TextStyle(color: SecondColor),
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: TextField(
                  style: TextStyle(color: SecondColor),
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Confirm Password",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                child: Container(
                  width: 297,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: MainColor,
                          offset: Offset(0, 4),
                          blurRadius: 10.0),
                      BoxShadow(
                          color: MainColor,
                          offset: Offset(4, 0),
                          blurRadius: 10.0)
                    ],
                    borderRadius: BorderRadius.circular(12.0),
                    color: MainColor,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(12.0),
                    color: MainColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.0),
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                      },
                      splashColor: Colors.white,
                      splashFactory: InkSplash.splashFactory,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Signup',
                              style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: (EdgeInsets.symmetric(horizontal: 60)),
                child: Row(
                  children: [
                    Text("You already have account?",style: TextStyle(
                      color: SecondColor,
                    ),),
                    SizedBox(width: 10),
                    GestureDetector( 
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Text(
                      "Login here",
                      style: TextStyle(
                        color: MainColor,
                        ),
                      ),
                    ),
                  ],
                ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
