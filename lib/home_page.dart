import 'dart:convert';
import 'package:cafein_beta/Test_API.dart';

import 'package:cafein_beta/home_page.dart';
import 'package:cafein_beta/login_page.dart';
import 'package:cafein_beta/auth/main_page.dart';
import 'package:cafein_beta/page_store/napwarin_page.dart';
import 'package:cafein_beta/category_page/slowbar_page.dart';
import 'package:cafein_beta/profile_page.dart';
import 'package:cafein_beta/test_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:like_button/like_button.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  late ScrollController _scrollViewController;
  bool _showAppbar = true;
  bool isScrollingDown = false;
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'),fit: BoxFit.cover,);
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF));
  List images = ["coffee01.jpg", "coffee02.jpg", "coffee03.jpg"];
  List names = ["Nap's x Warin", "Songsarn", "NoteCoffee"];
  List des = [
    "ร้านกาแฟบรรยากาศสบายๆ ฝั่งวาริน กาแฟรสดี มีเมนูหลากหลาย",
    "Normal Taste",
    "Bad Taste"
  ];
  List Lc = [
    1,
    2,
    3,
  ];
  List<double> Rt = [3.5, 4, 5];

  List Routes = [
    NapswarinPage(),
    NapswarinPage(),
    NapswarinPage(),
  ];
  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewController.removeListener(() {});
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollViewController = new ScrollController();
    _scrollViewController.addListener(() {
      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          setState(() {});
        }
      }

      if (_scrollViewController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      drawer: Drawer(//drawer
        child: Column(
          children: [
            Material(
              color: MainColor,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: Container(
                  width: 500,
                  child: Column(
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("users").where("uid", isEqualTo: user.uid).snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if(snapshot.hasData){
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context,i){
                              var data = snapshot.data!.docs[i];
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 52,
                                  backgroundImage: NetworkImage(data["image"]),
                                ),
                                Text(
                                  data["username"],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  data["email"],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            );
                          });
                        }else{
                          return CircularProgressIndicator();
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text(
                        "Home",
                        style: TextStyle(color: SecondColor),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite),
                      title: Text(
                        "Favorite",
                        style: TextStyle(color: SecondColor),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text(
                        "Notification",
                        style: TextStyle(color: SecondColor),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const HomePage()),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        "Logout",
                        style: TextStyle(color: SecondColor),
                      ),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const MainPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            AnimatedContainer(// appbar
              height: _showAppbar ? 56.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: AppBar(
                title: Logo,
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: MainColor),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollViewController,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(// search bar
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          style: TextStyle(color: SecondColor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(// tab hearder
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: MainColor,
                          isScrollable: true,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          labelColor: MainColor,
                          unselectedLabelColor: SecondColor,
                          tabs: [
                            Tab(
                              text: "RECOMMEND",
                            ),
                            Tab(
                              text: "POPULAR",
                            ),
                            Tab(
                              text: "NEARBY",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(// tab body
                      width: double.maxFinite,
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ListView.builder(
                              // recommend
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => Routes[index]),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        // img
                                        height: 300,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/" + images[index],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // body
                                        height: 300,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              // title store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Text(
                                                names[index],
                                                style: TextStyle(
                                                  color: MainColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              // like btn
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Container(
                                                width: 40,
                                                height: 20,
                                                child: LikeButton(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    size: 20,
                                                    likeCount: Lc[index],
                                                    likeBuilder:
                                                        (bool isLiked) {
                                                      return Icon(
                                                        Icons.favorite,
                                                        color: isLiked
                                                            ? MainColor
                                                            : Colors.grey,
                                                        size: 20,
                                                      );
                                                    }),
                                              ),
                                            ),
                                            SizedBox(height: 30),
                                            Padding(
                                              // des store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Container(
                                                width: 150,
                                                height: 115,
                                                child: Text(
                                                  des[index],
                                                  style: TextStyle(
                                                    color: SecondColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 30),
                                            Padding(
                                              // ratting store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: RatingBarIndicator(
                                                rating: Rt[index],
                                                itemBuilder: (context, index) =>
                                                    TestIMG,
                                                itemCount: 5,
                                                itemSize: 20,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                );
                              }),
                          ListView.builder(
                              // popular
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Routes[index]),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        // img
                                        height: 300,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/" + images[index],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // body
                                        height: 300,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              // title store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Text(
                                                names[index],
                                                style: TextStyle(
                                                  color: MainColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              // like btn
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Container(
                                                width: 40,
                                                height: 20,
                                                child: LikeButton(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    size: 20,
                                                    likeCount: Lc[index],
                                                    likeBuilder:
                                                        (bool isLiked) {
                                                      return Icon(
                                                        Icons.favorite,
                                                        color: isLiked
                                                            ? MainColor
                                                            : Colors.grey,
                                                        size: 20,
                                                      );
                                                    }),
                                              ),
                                            ),
                                            SizedBox(height: 30),
                                            Padding(
                                              // des store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Container(
                                                width: 150,
                                                height: 115,
                                                child: Text(
                                                  des[index],
                                                  style: TextStyle(
                                                    color: SecondColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 30),
                                            Padding(
                                              // ratting store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: RatingBarIndicator(
                                                rating: Rt[index],
                                                itemBuilder: (context, index) =>
                                                    TestIMG,
                                                itemCount: 5,
                                                itemSize: 20,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                );
                              }),
                          ListView.builder(
                              // nearby
                              itemCount: 3,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Routes[index]),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        // img
                                        height: 300,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5),
                                            bottomLeft: Radius.circular(5),
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(
                                              "assets/" + images[index],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // body
                                        height: 300,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              // title store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Text(
                                                names[index],
                                                style: TextStyle(
                                                  color: MainColor,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              // like btn
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Container(
                                                width: 40,
                                                height: 20,
                                                child: LikeButton(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    size: 20,
                                                    likeCount: Lc[index],
                                                    likeBuilder:
                                                        (bool isLiked) {
                                                      return Icon(
                                                        Icons.favorite,
                                                        color: isLiked
                                                            ? MainColor
                                                            : Colors.grey,
                                                        size: 20,
                                                      );
                                                    }),
                                              ),
                                            ),
                                            SizedBox(height: 30),
                                            Padding(
                                              // des store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: Container(
                                                width: 150,
                                                height: 115,
                                                child: Text(
                                                  des[index],
                                                  style: TextStyle(
                                                    color: SecondColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 30),
                                            Padding(
                                              // ratting store
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 50),
                                              child: RatingBarIndicator(
                                                rating: Rt[index],
                                                itemBuilder: (context, index) =>
                                                    TestIMG,
                                                itemCount: 5,
                                                itemSize: 20,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 0),
                                                direction: Axis.horizontal,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(// category header
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "CATEGORY",
                            style: TextStyle(color: SecondColor, fontSize: 15),
                          )),
                    ),
                    Padding(// category body
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(builder: (context) => const SlowbarPage()),
                                  );
                                },
                                child: Padding( // slowbar tab
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
                                            'assets/slowbar.png',
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        Text(
                                          "SLOWBAR",
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
                                    CupertinoPageRoute(builder: (context) => const TestPage()),
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
                                            'assets/speedbar.png',
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        Text(
                                          "SPEEDBAR",
                                          style: TextStyle(
                                            color: MainColor,
                                          ),
                                        ),
                                      ],
                                    )),
                                  ),
                                ),
                              ),
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
                                          'assets/hybridbar.png',
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      Text(
                                        "HYBRIDBAR",
                                        style: TextStyle(
                                          color: MainColor,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ],
                          ),
                          Row(
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
                                          'assets/coffee-cup.png',
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      Text(
                                        "COFFEE",
                                        style: TextStyle(
                                          color: MainColor,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
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
                                          'assets/cupcake.png',
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                      Text(
                                        "SWEET",
                                        style: TextStyle(
                                          color: MainColor,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
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
                                        "COMMUNITY",
                                        style: TextStyle(
                                          color: MainColor,
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      // CONTENT header
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "CONTENT",
                            style: TextStyle(color: SecondColor, fontSize: 15),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
