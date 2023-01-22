import 'dart:async';
import 'dart:ffi';
import 'package:cafein_beta/category_page/bakery_page.dart';
import 'package:cafein_beta/communitypost_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'dart:io';

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
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF),size: 1,);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'),fit: BoxFit.cover,);
  final _titleController= TextEditingController();
  final _messageController = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String datetimenow = DateTime.now().toString().substring(0,16);
  String imageUrl='';
  var likecounts = 0;
  var user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Community"),),
      body: Column(
        children: [
          SizedBox(height: 15),
          Padding( //category
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Padding(
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
                            'assets/blogging.png',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                        Text(
                          "แนะนำร้าน",
                          style: TextStyle(
                            color: MainColor,
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                InkWell(
                  onTap: () {
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
                              'assets/blogging.png',
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          Text(
                            "โปรโมชั่น",
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
                      CupertinoPageRoute(builder: (context) => const CommunityPage()),
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
                              'assets/blogging.png',
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
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(// category header
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "CONTENT",
                  style: TextStyle(color: SecondColor, fontSize: 15),
                )),
          ),
          SizedBox(height: 15),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection("community").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.hasData){
              return Container(
                height: 400,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context,i){
                    var data = snapshot.data!.docs[i];
                    int lc = data["likecount"];
                    handleliked(){    
                    final washingtonRef =  FirebaseFirestore.instance.collection("community").doc("Fu4fRrw4hyapVjjqsOqc");
                    washingtonRef.update({
                      "likecount" : lc,
                    });
                  }
                  return 
                  Padding(
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
                                      likeCount: lc,
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          Icons.favorite,
                                          color: isLiked ? MainColor : Colors.grey,
                                          size: 20,
                                        );
                                    }),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("TITLE",style: TextStyle(color: MainColor),),
                                    SizedBox(width: 10),
                                    Text(data["title"],style: TextStyle(color: SecondColor),),
                                  ],
                                ),
                                Container(
                                  height: 135 ,
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
                                SizedBox(
                                  height: 10,
                                ),  
                                Row(children: [
                                  Text(
                                    "DATE",
                                    style: TextStyle(color: MainColor),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                  data["date"],
                                  style: TextStyle(color: SecondColor),
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
        ],
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

