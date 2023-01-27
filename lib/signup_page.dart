// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:core';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const SignupPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  List<String> items = ["Male", "Female"];
  String? selectedItem = "Male";
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.5);
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
  final Seed = Image(
      image: AssetImage('assets/ratting.png'),
      fit: BoxFit.cover,
      width: 16,
      height: 16,
      color: Color.fromRGBO(0, 0, 0, 0.50));
  String imageUrl =
      "https://firebasestorage.googleapis.com/v0/b/cafein-beta.appspot.com/o/images%2Fuser.png?alt=media&token=78d5b9ab-7620-4983-abf8-c9550ef9a14b";
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  //controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  bool _isLoading = false;

  Future UploadIMG() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("images");
    Reference referenceImagesToUpload =
        referenceDirImages.child(uniqueFileName);
    //handle errors/success
    try {
      await referenceImagesToUpload.putFile(File("${file.path}"));
      imageUrl = await referenceImagesToUpload.getDownloadURL();
      setState(() {
        imageUrl = imageUrl;
      });
    } catch (error) {
      print("error img");
    }
  }

  Future signUp() async {
    try {
      setState(() {
        _isLoading = true;
      });
      // authenticate user
      if (passwordConfrimed()) {
        final UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim());
        final User? user = result.user;
        String uid = user!.uid;
        // add user details
        addUserDetails(
          uid,
          _emailController.text.trim(),
          _usernameController.text.trim(),
          int.parse(_ageController.text),
          selectedItem.toString(),
          imageUrl,
        );
        // add user to api
        postUserData(
          _usernameController.text.trim(),
          selectedItem.toString(),
          int.parse(_ageController.text),
          uid,
        );
        setState(() {
          _isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
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
    _confirmpasswordController.dispose();
    _usernameController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future addUserDetails(String uid, String email, String username, int age,
      String gender, image) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'age': age,
      'gender': gender,
      'image': imageUrl,
    });
  }

  bool passwordConfrimed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future postUserData(
    String username,
    String gender,
    int age,
    String uid,
  ) async {
    try {
      var url = Uri.https(
          '6336-2001-fb1-148-7898-c1af-9299-adf3-5e89.ap.ngrok.io', '/take');
      final response = await http.post(url,
          body: jsonEncode({
            "name": username,
            "gender": gender,
            "age": age,
            "uid": uid,
          }),
          headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Logo,
                SizedBox(height: 50),
                Container(
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: NetworkImage(imageUrl),
                    backgroundColor: Color(0xFFE6E6E6),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                    onTap: () async {
                      UploadIMG();
                    },
                    child: Icon(Icons.camera_alt)),
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
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: "Gender",
                        prefixIcon: Icon(Icons.add_reaction),
                      ),
                      value: selectedItem,
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: TextStyle(color: SecondColor),
                              )))
                          .toList(),
                      onChanged: (item) => setState(() => selectedItem = item),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: (EdgeInsets.symmetric(horizontal: 50)),
                  child: TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(color: SecondColor),
                    decoration: InputDecoration(
                      hintText: "Age",
                      prefixIcon: Icon(Icons.person_search),
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
                                    Text('Signup',
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
                      Text(
                        "You already have account?",
                        style: TextStyle(
                          color: SecondColor,
                        ),
                      ),
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
      ),
    );
  }
}
