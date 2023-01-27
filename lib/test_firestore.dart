import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int? _age = 0;
  String? _username = "";
  String? _email = "";
  String? _uid = "";
  var user = FirebaseAuth.instance.currentUser!;
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final Logo = Image(
    image: AssetImage('assets/cafein_logo.png'),
    fit: BoxFit.cover,
  );
  final TestIMG = ImageIcon(
      AssetImage(
        'assets/ratting.png',
      ),
      color: Color(0xFFF2D1AF));
  Future getDataFromDatabase() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        setState(() {
          _username = snapshot.data()!["username"];
          _email = snapshot.data()!["email"];
          _uid = snapshot.data()!["uid"];
          _age = snapshot.data()!["age"];
        });
      }
    }
  }

  Future<void> likePostCommunity(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection("community")
            .doc(postid)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("community")
            .doc(postid)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeStore(String store_id, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection("search")
            .doc(store_id)
            .update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("search")
            .doc(store_id)
            .update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

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

  @override
  void initState() {
    getDataFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              // category header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "STORE LIKED",
                    style: TextStyle(color: SecondColor, fontSize: 15),
                  )),
            ),
            StreamBuilder(
                //reviews user liked
                stream: FirebaseFirestore.instance
                    .collection("search")
                    .where("likes", arrayContains: user.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 400,
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            var data = snapshot.data!.docs[i];
                            var rt = data["rating"];
                            int likesCount = data["likes"].length;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                              "Store ",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
                                            Text(
                                              data["string_name"],
                                              style:
                                                  TextStyle(color: SecondColor),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Address ",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
                                            Container(
                                              width: 300,
                                              child: Text(
                                                data["address"],
                                                style: TextStyle(
                                                    color: SecondColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: Image.network(
                                            data["img_cover"][0],
                                            width: 300,
                                            height: 200,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "TYPE ",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
                                            Container(
                                              width: 300,
                                              child: Text(
                                                data["type"].toString(),
                                                style: TextStyle(
                                                    color: SecondColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "RATING ",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
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
                                                likeStore(
                                                  data["store_id"],
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
              // category header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "REVIEW LIKED",
                    style: TextStyle(color: SecondColor, fontSize: 15),
                  )),
            ),
            StreamBuilder(
                //reviews user liked
                stream: FirebaseFirestore.instance
                    .collection("reviews")
                    .where("likes", arrayContains: user.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
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
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                            Text(
                                              "STORE ",
                                              style:
                                                  TextStyle(color: MainColor),
                                            ),
                                            Text(
                                              data["store_name"],
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
              // category header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "COMMUNITY POST LIKED",
                    style: TextStyle(color: SecondColor, fontSize: 15),
                  )),
            ),
            StreamBuilder(
                //reviews user liked
                stream: FirebaseFirestore.instance
                    .collection("community")
                    .where("likes", arrayContains: user.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.docs[i];
                          int likesCount = data["likes"].length;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                            "TITLE ",
                                            style: TextStyle(color: MainColor),
                                          ),
                                          Text(
                                            data["title"],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "CATEGORY ",
                                            style: TextStyle(color: MainColor),
                                          ),
                                          Text(
                                            data["category"],
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        data["message"],
                                        style: TextStyle(color: SecondColor),
                                      ),
                                      Image.network(
                                        data["image"],
                                        fit: BoxFit.cover,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "POST ",
                                            style: TextStyle(color: MainColor),
                                          ),
                                          Text(
                                            data["email"],
                                            style:
                                                TextStyle(color: SecondColor),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "DATE ",
                                            style: TextStyle(color: MainColor),
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
                                              likePostCommunity(
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
                        });
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }
}
