import 'dart:io';

import 'package:cafein_beta/page_store/napwarinmap_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class NapswarinPage extends StatefulWidget {
  const NapswarinPage({super.key});

  @override
  State<NapswarinPage> createState() => _NapswarinPageState();
}

class _NapswarinPageState extends State<NapswarinPage> {
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final maxLines = 5;
  List images = ["coffee01.jpg", "coffee02.jpg", "coffee03.jpg"];
  final TestIMG = ImageIcon(
      AssetImage(
        'assets/ratting.png',
      ),
      color: Color(0xFFF2D1AF));
  final Googlemap = ImageIcon(
    AssetImage(
      'assets/google_map.png',
    ),
    color: Color.fromRGBO(0, 0, 0, 0.60),
  );
  final _messageController = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl='';
  double? ratings ;
  var likecounts = 0;
  var user = FirebaseAuth.instance.currentUser!;
  String A = 'Naps X Warin';
  String store_name = "Naps X Warin";
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
        store_name,
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
  Future addReview(String store_name,String uid, String email, String message, rating, likecount, image,) async {
    await FirebaseFirestore.instance.collection("reviews").add({
      'store_name' : store_name,
      'uid': uid,
      'email': email,
      'message': message,
      'rating' : rating,
      'likecount' : likecount,
      'image' : imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Naps X Warin",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MainColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlideshow(
              //Img slide
              width: double.infinity,
              height: 400,
              initialPage: 0,
              indicatorColor: MainColor,
              indicatorBackgroundColor: Colors.grey,
              // ignore: sort_child_properties_last
              children: [
                Image.asset(
                  'assets/' + images[0],
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/' + images[1],
                  fit: BoxFit.cover,
                ),
                Image.asset(
                  'assets/' + images[2],
                  fit: BoxFit.cover,
                ),
              ],
              onPageChanged: (value) {
                print('Page changed: $value');
              },
              isLoop: false,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // detail body
              width: 350,
              height: 250,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: ShawdowColor,
                      offset: Offset(0, 4),
                      blurRadius: 10.0),
                  BoxShadow(
                      color: ShawdowColor,
                      offset: Offset(4, 0),
                      blurRadius: 10.0)
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DETAIL",
                      style: TextStyle(color: MainColor),
                    ),
                    Text(
                      "ร้านกาแฟบรรยากาศสบายๆ ฝั่งวาริน กาแฟรสดี มีเมนูหลากหลาย",
                      style: TextStyle(color: SecondColor),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PRICE",
                              style: TextStyle(color: MainColor),
                            ),
                            Text(
                              "฿45-300",
                              style: TextStyle(color: SecondColor),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "OPEN DAILY",
                                style: TextStyle(color: MainColor),
                              ),
                              Text(
                                "07.00-16.00",
                                style: TextStyle(color: SecondColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "CONTACT",
                      style: TextStyle(color: MainColor),
                    ),
                    Text(
                      "083-365-5536",
                      style: TextStyle(color: SecondColor),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.facebook,
                          color: SecondColor,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const NapswarinMapPage()),
                        );
                          },
                          child: Icon(
                            Icons.near_me,
                            color: SecondColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "RATTING",
                      style: TextStyle(color: MainColor),
                    ),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: 5,
                          itemBuilder: (context, index) => TestIMG,
                          itemCount: 5,
                          itemSize: 15,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0),
                          direction: Axis.horizontal,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 85,
                          ),
                          child: LikeButton(
                              mainAxisAlignment: MainAxisAlignment.start,
                              size: 20,
                              likeCount: 5,
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color: isLiked ? MainColor : Colors.grey,
                                  size: 20,
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              // CONTENT header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "MENU",
                    style: TextStyle(color: SecondColor, fontSize: 15),
                  )),
            ),
            Container(
              width: 1000,
              height: 150,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: <Widget>[
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU1",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU2",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU3",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU4",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU5",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU6",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU7",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU8",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU9",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(0, 4),
                              blurRadius: 10.0),
                          BoxShadow(
                              color: ShawdowColor,
                              offset: Offset(4, 0),
                              blurRadius: 10.0)
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/menu_1.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "MENU10",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ])),
            ),
            Padding(
              // CONTENT header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "REVIEW",
                    style: TextStyle(color: SecondColor, fontSize: 15),
                  )),
            ),
            StreamBuilder( //reviews
              stream: FirebaseFirestore.instance.collection("reviews").where("store_name",isEqualTo: A).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData){
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  height: 400,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context,i){
                      var data = snapshot.data!.docs[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
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
                                          likeCount: data["likecount"],
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
                          ),
                        ],
                      ),
                    );
                  }),
                );
              }else{
                return CircularProgressIndicator();
              }
            }),
            Padding(
              // COMMEND header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "COMMEND",
                    style: TextStyle(color: SecondColor, fontSize: 15),
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Container( // comment
              width: 350,
              height: 250,
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
