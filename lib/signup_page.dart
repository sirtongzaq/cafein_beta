// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'package:cafein_beta/home_page.dart';
import 'package:cafein_beta/login_page.dart';
import 'package:cafein_beta/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({Key? key,required this.showLoginPage}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final MainColor = Color(0xFFF2D1AF);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'), fit: BoxFit.cover);
  final Google_login = Image(image: AssetImage('assets/google.png'), fit: BoxFit.cover , width: 16, height: 16, color: Color.fromRGBO(0, 0, 0, 0.50));
  final Facebook_login = Image(image: AssetImage('assets/facebook.png'), fit: BoxFit.cover , width: 16 , height: 16, color: Color.fromRGBO(0, 0, 0, 0.50));
  final Apple_login = Image(image: AssetImage('assets/apple.png'), fit: BoxFit.cover , width: 16 ,height: 16, color: Color.fromRGBO(0, 0, 0, 0.50));
  final Seed = Image(image: AssetImage('assets/ratting.png'), fit: BoxFit.cover , width: 16 ,height: 16, color: Color.fromRGBO(0, 0, 0, 0.50));
  //controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future signUp() async {
    try {  
      // authenticate user
      if (passwordConfrimed()) {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(), 
        password: _passwordController.text.trim()
      );
      // add user details
      addUserDetails(
        _emailController.text.trim(),
        _usernameController.text.trim(), 
      );
    }

    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context){
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
  
  Future addUserDetails(String email,String username) async {
    await FirebaseFirestore.instance.collection("users").add({
      'email':email,
      'username':username,
    });
  }

  bool passwordConfrimed() {
    if (_passwordController.text.trim() == _confirmpasswordController.text.trim()){
      return true;
    }else{
      return false;
    }
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
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: TextField(
                  controller: _usernameController,
                  style: TextStyle(color: SecondColor),
                  decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
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
              SizedBox(height: 10),
              Container(
                padding: (EdgeInsets.symmetric(horizontal: 50)),
                child: TextField(
                  controller: _confirmpasswordController,
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
                        signUp();
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
                      onTap: widget.showLoginPage,
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
