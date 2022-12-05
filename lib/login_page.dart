// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:cafein_beta/home_page.dart';
import 'package:cafein_beta/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: "Password",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        print('Button Pressed');
                      },
                      splashColor: MainColor,
                      child: Google_login),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        print('Button Pressed');
                      },
                      splashColor: MainColor,
                      child: Facebook_login),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        print('Button Pressed');
                      },
                      splashColor: MainColor,
                      child: Apple_login),
                    SizedBox(width: 100),
                    GestureDetector( 
                      onTap: () {
                        print("Forgot password");
                      },
                      child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: MainColor,
                        ),
                      ),
                    ),
                  ],
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
                        MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                      },
                      splashColor: Colors.white,
                      splashFactory: InkSplash.splashFactory,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Login',
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
                    Text("Don‘t have an account?",style: TextStyle(
                      color: SecondColor,
                    ),),
                    SizedBox(width: 20),
                    GestureDetector( 
                      onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                        );
                      },
                      child: Text(
                      "Signup here",
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
