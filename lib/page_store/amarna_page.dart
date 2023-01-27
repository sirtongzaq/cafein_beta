import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:cafein_beta/page_store/amarnamap_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class AmarnaPage extends StatefulWidget {
  const AmarnaPage({super.key});

  @override
  State<AmarnaPage> createState() => _AmarnaPageState();
}

class _AmarnaPageState extends State<AmarnaPage> {
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final maxLines = 5;
  final TestIMG = ImageIcon(
      AssetImage(
        'assets/ratting.png',
      ),
      color: Color(0xFFF2D1AF));
  final _messageController = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/cafein-beta.appspot.com/o/images%2Fempty.jpg?alt=media&token=ffe447ef-ea0c-45cc-b44a-af71253ed675';
  double? ratings;
  var likecounts = 0;
  var user = FirebaseAuth.instance.currentUser!;
  String A = "Amarna";
  String datetimenow = DateTime.now().toString().substring(0, 16);
  String postId = Uuid().v4();
  String doc_store = "HhtoeYfALfZ3wfpCTil9";

  Future<void> likePost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection("reviews")
            .doc(postid)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("reviews")
            .doc(postid)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeStore(String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection("search")
            .doc(doc_store)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("search")
            .doc(doc_store)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

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
          A,
          user.uid,
          user.email!,
          _messageController.text.trim(),
          ratings,
          likecounts,
          imageUrl,
          datetimenow,
          postId,
        );
        postUserData(
          user.uid,
          ratings,
          A,
          _messageController.text.trim(),
          datetimenow,
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Thank you for review")));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future addReview(String A, String uid, String email, String message, rating,
      likecount, image, datetimenow, String postid) async {
    await FirebaseFirestore.instance.collection("reviews").doc(postId).set({
      'store_name': A,
      'uid': uid,
      'email': email,
      'message': message,
      'rating': rating,
      'likecount': likecount,
      'image': imageUrl,
      'date': datetimenow,
      'postid': postid,
      'likes': []
    });
  }

  Future postUserData(
    String uid,
    rating,
    String store,
    String message,
    String date,
  ) async {
    try {
      var url = Uri.https(
          'e48d-2001-fb1-14a-79d7-9a5-bb29-b802-41ec.ap.ngrok.io', '/review');
      final response = await http.post(url,
          body: jsonEncode({
            "uid": uid,
            "rating": rating,
            "store": A,
            "message": message,
            "date": datetimenow,
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
            StreamBuilder(
                //detail
                stream: FirebaseFirestore.instance
                    .collection("search")
                    .where("string_name", isEqualTo: A)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.docs[i];
                          String _ulr = data['facebook'];
                          var tel = data["contact"];
                          var rt = data["rating"];
                          int likesStore = data["likes"].length;
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
                                Card(
                                  // detail body
                                  margin: EdgeInsets.all(15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "DETAIL",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
                                            Text(
                                              data["address"],
                                              style:
                                                  TextStyle(color: SecondColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "PRICE",
                                                  style: TextStyle(
                                                      color: MainColor),
                                                ),
                                                Text(
                                                  "${data["price"]}",
                                                  style: TextStyle(
                                                      color: SecondColor),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 97),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "OPEN DAILY",
                                                    style: TextStyle(
                                                        color: MainColor),
                                                  ),
                                                  Text(
                                                    data["open_daily"],
                                                    style: TextStyle(
                                                        color: SecondColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "CONTACT",
                                                  style: TextStyle(
                                                      color: MainColor),
                                                ),
                                                Text(
                                                  data["contact"],
                                                  style: TextStyle(
                                                      color: SecondColor),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "TYPE",
                                                    style: TextStyle(
                                                        color: MainColor),
                                                  ),
                                                  Text(
                                                    data["type"][0].toUpperCase(),
                                                    style: TextStyle(
                                                        color: SecondColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
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
                                                  launchUrl(Uri.parse(_ulr));
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
                                                        builder: (context) =>
                                                            const AmarnaMapPage()),
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
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Text(
                                            "RATTING",
                                            style: TextStyle(color: MainColor),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            RatingBarIndicator(
                                              rating: double.parse(rt),
                                              itemBuilder: (context, index) =>
                                                  TestIMG,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 0),
                                              direction: Axis.horizontal,
                                            ),
                                            SizedBox(
                                              width: 75,
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: (data["likes"]
                                                            .contains(user.uid))
                                                        ? MainColor
                                                        : SecondColor,
                                                  ),
                                                  onTap: () {
                                                    likeStore(
                                                      user.uid,
                                                      data["likes"],
                                                    );
                                                  },
                                                ),
                                                Text(
                                                  likesStore.toString(),
                                                  style: TextStyle(
                                                      color: SecondColor),
                                                ),
                                              ],
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "MENU",
                                        style: TextStyle(
                                            color: SecondColor, fontSize: 15),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                        ),
                                      ])),
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
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
            StreamBuilder(
                //reviews
                stream: FirebaseFirestore.instance
                    .collection("reviews")
                    .where("store_name", isEqualTo: A)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      height: 400,
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            var data = snapshot.data!.docs[i];
                            int likesCount = data["likes"].length;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Card(
                                elevation: 10,
                                margin: EdgeInsets.all(10),
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Email ",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
                                            Text(
                                              data["email"],
                                              style:
                                                  TextStyle(color: SecondColor),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 300,
                                          child: Text(
                                            data["message"],
                                            style:
                                                TextStyle(color: SecondColor),
                                          ),
                                        ),
                                        Image.network(data["image"],
                                            width: 300),
                                        Row(
                                          children: [
                                            Text(
                                              "RATING ",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
                                            RatingBarIndicator(
                                              rating: data["rating"],
                                              itemBuilder: (context, index) =>
                                                  TestIMG,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 0),
                                              direction: Axis.horizontal,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "DATE ",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
                                            Text(
                                              data["date"],
                                              style:
                                                  TextStyle(color: SecondColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              child: Icon(
                                                Icons.favorite,
                                                color: (data["likes"]
                                                        .contains(user.uid))
                                                    ? MainColor
                                                    : SecondColor,
                                              ),
                                              onTap: () {
                                                likePost(
                                                  data["postid"],
                                                  user.uid,
                                                  data["likes"],
                                                );
                                              },
                                            ),
                                            Text(
                                              likesCount.toString(),
                                              style:
                                                  TextStyle(color: SecondColor),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
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
            Card(
              // comment
              margin: EdgeInsets.all(20),
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
                  Center(
                      child: Container(
                          child: Image.network(
                    imageUrl,
                    width: 330,
                    height: 300,
                  ))),
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
                        setState(() {
                          imageUrl =
                              'https://firebasestorage.googleapis.com/v0/b/cafein-beta.appspot.com/o/images%2Fempty.jpg?alt=media&token=ffe447ef-ea0c-45cc-b44a-af71253ed675';
                        });
                      },
                      child: Icon(
                        Icons.arrow_circle_right,
                        color: MainColor,
                      ),
                    ),
                  ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      datetimenow,
                      style: TextStyle(color: SecondColor),
                    ),
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
