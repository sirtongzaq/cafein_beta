import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CommunityPostPage extends StatefulWidget {
  const CommunityPostPage({super.key});

  @override
  State<CommunityPostPage> createState() => _CommunityPostPageState();
}

class _CommunityPostPageState extends State<CommunityPostPage> {
  final maxLines = 5;
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final TestIMG = ImageIcon(
    AssetImage(
      'assets/ratting.png',
    ),
    color: Color(0xFFF2D1AF),
    size: 1,
  );
  final Logo = Image(
    image: AssetImage('assets/cafein_logo.png'),
    fit: BoxFit.cover,
  );
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String datetimenow = DateTime.now().toString().substring(0, 16);
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/cafein-beta.appspot.com/o/images%2Fempty.jpg?alt=media&token=ffe447ef-ea0c-45cc-b44a-af71253ed675';
  var user = FirebaseAuth.instance.currentUser!;
  String postId = Uuid().v4();
  List<String> items = ["ความรู้", "สูตรกาแฟ", "เมล็ดกาแฟ"];
  String? selectedItem = "ความรู้";
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

  Future Post() async {
    try {
      if (_messageController.text.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please write some message")));
      }
      if (imageUrl.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please upload image")));
      }
      if (imageUrl.isNotEmpty) {
        addReview(
          _titleController.text.trim(),
          _messageController.text.trim(),
          user.uid,
          user.email!,
          datetimenow,
          imageUrl,
          postId,
          selectedItem.toString(),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Thank you for review")));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future addReview(String tile, String message, String uid, String email,
      datetimenow, image, String postid, String category) async {
    await FirebaseFirestore.instance.collection("community").doc(postId).set({
      'title': tile,
      'message': message,
      'uid': uid,
      'email': email,
      'date': datetimenow,
      'image': imageUrl,
      'postid': postid,
      'category': category,
      'likes': [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: Text(
                    user.email!,
                    style: TextStyle(color: MainColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  height: 45,
                  child: TextField(
                    controller: _titleController,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      hintText: "Title",
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  height: maxLines * 30,
                  child: TextField(
                    controller: _messageController,
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      hintText: "Enter a message",
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: "Category",
                        prefixIcon: Icon(Icons.category),
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
                Center(
                    child: Container(
                        child: Image.network(
                  imageUrl,
                  width: 310,
                  height: 300,
                ))),
                Row(children: [
                  //,img,post
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      datetimenow,
                      style: TextStyle(color: SecondColor),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                  ),
                  InkWell(
                    onTap: () {
                      UploadIMG();
                    },
                    child: Icon(
                      Icons.image,
                      color: MainColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Post();
                      _titleController.clear();
                      _messageController.clear();
                      imageUrl = '';
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_circle_right,
                      color: MainColor,
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
