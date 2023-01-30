import 'dart:async';
import 'dart:ffi';
import 'package:cafein_beta/category_page/bakery_page.dart';
import 'package:cafein_beta/community/communitypost_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'community_page.dart';

class CommunityKnowledgePage extends StatefulWidget {
  const CommunityKnowledgePage({super.key});

  @override
  State<CommunityKnowledgePage> createState() => _CommunityKnowledgePageState();
}

class _CommunityKnowledgePageState extends State<CommunityKnowledgePage> {
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
  String A ="ความรู้";
  var user = FirebaseAuth.instance.currentUser!;
  Future<void> likePost(String postid, String uid, List likes) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(A),
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              // category header
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "TREND",
                    style: TextStyle(color: SecondColor, fontSize: 15),
                  )),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("community")
                    .where("category",isEqualTo: A)
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
