// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:cafein_beta/forgot_pw_page.dart';
import 'package:cafein_beta/home_page.dart';
import 'package:cafein_beta/auth/main_page.dart';
import 'package:cafein_beta/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final MainColor = Color(0xFFF2D1AF);
  final Logo =
      Image(image: AssetImage('assets/cafein_logo.png'), fit: BoxFit.cover);
  final Google_login = Image(
      image: AssetImage('assets/google.png'),
      fit: BoxFit.cover,
      width: 16,
      height: 16,
      color: Color.fromRGBO(0, 0, 0, 0.50));
  final Facebook_login = Image(
      image: AssetImage('assets/facebook.png'),
      fit: BoxFit.cover,
      width: 16,
      height: 16,
      color: Color.fromRGBO(0, 0, 0, 0.50));
  final Apple_login = Image(
      image: AssetImage('assets/apple.png'),
      fit: BoxFit.cover,
      width: 16,
      height: 16,
      color: Color.fromRGBO(0, 0, 0, 0.50));
  //text controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  //sinIn controller
  Future singIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo,
              SizedBox(height: 50),
              Container(
                // email text field
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(color: SecondColor),
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                // password text field
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: TextField(
                  controller: _passwordController,
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
                // icon login
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
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const ForgotPasswordPage()),
                        );
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
                // login btn
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
                        singIn();
                      },
                      splashColor: Colors.white,
                      splashFactory: InkSplash.splashFactory,
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                children: <Widget>[
                                  Text('Login',
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
                // msg
                padding: (EdgeInsets.symmetric(horizontal: 60)),
                child: Row(
                  children: [
                    Text(
                      "Don‘t have an account?",
                      style: TextStyle(
                        color: SecondColor,
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: widget.showRegisterPage,
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
