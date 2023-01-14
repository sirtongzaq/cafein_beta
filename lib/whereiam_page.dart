import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'dart:io';

class WhereiamPage extends StatefulWidget {
  const WhereiamPage({super.key});

  @override
  State<WhereiamPage> createState() => _WhereiamPageState();
}
class _WhereiamPageState extends State<WhereiamPage> {
  final maxLines = 5;
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF),size: 1,);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'),fit: BoxFit.cover,);
  final _messageController = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl='';
  double? ratings ;
  var likecounts = 0;
  var user = FirebaseAuth.instance.currentUser!;

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
        user.uid,
        user.email!,
        _messageController.text.trim(),
        ratings,
        likecounts,
        imageUrl,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: 
        Text("Thank you for review")));
    }
  } on FirebaseAuthException catch (e) {
    print(e);
  }
}
  Future addReview(String uid, String email, String message, rating, likecount, image,) async {
    await FirebaseFirestore.instance.collection("napsxwarinreviews").add({
      'uid': uid,
      'email': email,
      'message': message,
      'rating' : rating,
      'likecount' : likecount,
      'image' : imageUrl,
    });
  }

  @override
  void initState() {
    print(user.uid);
    print(user.email);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("COMMENT AND DISPLAY"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15,),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("napsxwarinreviews").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData){
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 400,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context,i){
                      var data = snapshot.data!.docs[i];
                    return Container(
                      width: 350,
                      height: 400,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Text(
                                  data["email"],
                                  style: TextStyle(color: MainColor),
                                ),
                                SizedBox(
                                  width: 150,
                                ),
                                LikeButton(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    size: 20,
                                    likeCount: data["likecount"].toInt(),
                                    likeBuilder: (bool isLiked) {
                                      return Icon(
                                        Icons.favorite,
                                        color: isLiked ? MainColor : Colors.grey,
                                        size: 20,
                                      );
                                    }),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              data["message"],
                              style: TextStyle(color: SecondColor),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Image.network(
                              data["image"],
                              width: 150,
                              height: 150,
                              ),
                            SizedBox(
                              height: 15,
                            ),  
                            Row(children: [
                              Text(
                                "RATING",
                                style: TextStyle(color: MainColor),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              RatingBarIndicator(
                                rating: data["rating"],
                                itemBuilder: (context, index) => TestIMG,
                                itemCount: 5,
                                itemSize: 15,
                                itemPadding: EdgeInsets.symmetric(horizontal: 0),
                                direction: Axis.horizontal,
                              ),
                            ]),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }else{
                return CircularProgressIndicator();
              }
            }),
            SizedBox(height: 15),
            Container(
              width: 350,
              height: 250,
              color: Colors.white, 
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
                    height: maxLines * 30.0,
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
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        "RATTING",
                        style: TextStyle(color: MainColor),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 15,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemBuilder: (context, _) => TestIMG,
                      onRatingUpdate: (rating) {
                        ratings = rating.toDouble();
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      width: 130,
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
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      
    );
  }
  
}

