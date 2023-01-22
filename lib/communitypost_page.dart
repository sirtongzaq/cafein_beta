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
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF),size: 1,);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'),fit: BoxFit.cover,);
  final _titleController= TextEditingController();
  final _messageController = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String datetimenow = DateTime.now().toString().substring(0,16);
  String imageUrl='';
  var likecounts = 0;
  var user = FirebaseAuth.instance.currentUser!;
  String postId = Uuid().v4();
  
  Future UploadIMG() async {
    ImagePicker imagePicker=ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if(file==null) return;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("images");
    Reference referenceImagesToUpload = referenceDirImages.child(uniqueFileName);
    //handle errors/success
    try{
      await referenceImagesToUpload.putFile(File("${file.path}"));
      imageUrl= await referenceImagesToUpload.getDownloadURL();
      setState(() {
        imageUrl = imageUrl;
      });
    }catch(error){
      print("error img");
    }
  }

  Future Post() async {
    try { 
      if(_messageController.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: 
          Text("Please write some message")));
      }
      if(imageUrl.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: 
          Text("Please upload image")));
      }
      if (imageUrl.isNotEmpty) {
        addReview(
          _titleController.text.trim(),
          _messageController.text.trim(),
          user.uid,
          user.email!,
          datetimenow,
          likecounts,
          imageUrl,
          postId,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: 
          Text("Thank you for review")));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
  Future addReview(String tile, String message, String uid, String email, datetimenow, likecount, image, String postid) async {
    await FirebaseFirestore.instance.collection("community").add({
      'title': tile,
      'message': message,
      'uid': uid,
      'email': email,
      'date' : datetimenow,
      'likecount' : likecount,
      'image' : imageUrl,
      'postid' : postid,
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post"),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Container(
        width: 350,
        height: 310,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
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
            Row(children: [ //,img,post
              Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(datetimenow,style: TextStyle(
                color: SecondColor
              ),),
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
    );
  }
}