import 'dart:io';
import 'package:cafein_beta/page_store/11-11gallerymap_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final maxLines = 5;
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF));
  final _messageController = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl='';
  double? ratings ;
  var likecounts = 0;
  var user = FirebaseAuth.instance.currentUser!;
  String A = "11.11 Gallery and Coffee";
  String datetimenow = DateTime.now().toString().substring(0,16);
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
        A,
        user.uid,
        user.email!,
        _messageController.text.trim(),
        ratings,
        likecounts,
        imageUrl,
        datetimenow,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: 
        Text("Thank you for review")));
    }
  } on FirebaseAuthException catch (e) {
    print(e);
  }
}
  Future addReview(String A,String uid, String email, String message, rating, likecount, image,datetimenow) async {
    await FirebaseFirestore.instance.collection("reviews").add({
      'store_name' : A,
      'uid': uid,
      'email': email,
      'message': message,
      'rating' : rating,
      'likecount' : likecount,
      'image' : imageUrl,
      'date' : datetimenow,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          A,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MainColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder( //detail
              stream: FirebaseFirestore.instance.collection("search").where("string_name",isEqualTo: A).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    physics: ClampingScrollPhysics(), 
                    shrinkWrap: true,
                    itemBuilder: (context,i){
                      var data = snapshot.data!.docs[i];
                      String _ulr = data['facebook'];
                      var tel = data["contact"];
                      var rt = data["rating"];
                    return SingleChildScrollView(
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
                              Image.network(
                                data['img_cover'][0],
                                fit: BoxFit.cover,
                              ),
                              Image.network(
                                data['img_cover'][1],
                                fit: BoxFit.cover,
                              ),
                              Image.network(
                                data['img_cover'][2],
                                fit: BoxFit.cover,
                              ),
                            ],
                            isLoop: true,
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
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "DETAIL",
                                        style: TextStyle(color: MainColor),
                                      ),
                                      Text(
                                        data["address"],
                                        style: TextStyle(color: SecondColor),
                                      ),
                                    ],
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
                                            "${data["price"]}",
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
                                              data["open_daily"],
                                              style: TextStyle(color: SecondColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "CONTACT",
                                            style: TextStyle(color: MainColor),
                                          ),
                                          Text(
                                            data["contact"],
                                            style: TextStyle(color: SecondColor),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 50),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "TYPE",
                                              style: TextStyle(color: MainColor),
                                            ),
                                            Text(
                                              data["type"].toUpperCase(),
                                              style: TextStyle(color: SecondColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            launch('tel:$tel');
                                            print(tel);
                                          },
                                          child: Icon(
                                            Icons.call,
                                            color: SecondColor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            launchUrl(
                                              Uri.parse(_ulr)
                                            );
                                            print(_ulr);
                                          },
                                          child: Icon(
                                            Icons.facebook,
                                            color: SecondColor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => const GalleryMapPage()),
                                        );
                                          },
                                          child: Icon(
                                            Icons.near_me,
                                            color: SecondColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "RATTING",
                                      style: TextStyle(color: MainColor),
                                    ),
                                  ),
                                  RatingBarIndicator(
                                    rating: double.parse(rt),
                                    itemBuilder: (context, index) => TestIMG,
                                    itemCount: 5,
                                    itemSize: 15,
                                    itemPadding: EdgeInsets.symmetric(horizontal: 0),
                                    direction: Axis.horizontal,
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
                        ],
                      ),
                    );
                  });
              }else{
                return CircularProgressIndicator();
              }
            }),
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
                                  Container(
                                  height: 160 ,
                                  child: Text(
                                    data["message"],
                                    style: TextStyle(color: SecondColor),
                                  ),
                                ),
                                  Image.network(
                                    data["image"],
                                    width: 150,
                                    height: 150,
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
                                  Text(
                                      data["date"],
                                      style: TextStyle(color: SecondColor),
                                    ),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(datetimenow,style: TextStyle(
                        color: SecondColor
                      ),),
                  ),
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