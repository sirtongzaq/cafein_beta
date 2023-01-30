import 'dart:async';
import 'dart:ffi';
import 'package:cafein_beta/community/community_coffee_page.dart';
import 'package:cafein_beta/community/community_knowledge_page.dart';
import 'package:cafein_beta/community/community_seed_page.dart';
import 'package:cafein_beta/community/communitypost_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
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
  String imageUrl = '';
  var user = FirebaseAuth.instance.currentUser!;

  Future<void> likePostCommunity(String postid, String uid, List likes,
      String ownpost, String title) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection("community")
            .doc(postid)
            .update({
          "likes": FieldValue.arrayRemove([uid]),
          "likes_count": FieldValue.increment(-1),
        });
      } else {
        await FirebaseFirestore.instance
            .collection("community")
            .doc(postid)
            .update({
          "likes": FieldValue.arrayUnion([uid]),
          "likes_count": FieldValue.increment(1),
        });
        await FirebaseFirestore.instance.collection("notifications").add({
          "email": user.email,
          "event": "Like",
          "title": title,
          "email_own_post": ownpost,
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Community"),
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              //category
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) =>
                                const CommunityKnowledgePage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
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
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            )),
                        child: Center(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/light-bulb.png',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            Text(
                              "ความรู้",
                              style: TextStyle(
                                color: MainColor,
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const CommunityCoffeePage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
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
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            )),
                        child: Center(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/coffee-cup.png',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            Text(
                              "สูตรเครื่องดื่ม",
                              style: TextStyle(
                                color: MainColor,
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const CommunitySeedPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
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
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            )),
                        child: Center(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.asset(
                                'assets/seed.png',
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            ),
                            Text(
                              "เมล็ดกาแฟ",
                              style: TextStyle(
                                color: MainColor,
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              // category header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "trending review".toUpperCase(),
                    style: TextStyle(color: SecondColor, fontSize: 15),
                  )),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("community")
                    .orderBy("likes_count", descending: true)
                    .limit(10)
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
                                                data["email"],
                                                data["title"],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: MainColor,
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const CommunityPostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
