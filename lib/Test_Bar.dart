import 'dart:async';
import 'package:cafein_beta/Test_API.dart';
import 'package:cafein_beta/Test_Bar.dart';
import 'package:cafein_beta/home_page.dart';
import 'package:cafein_beta/login_page.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
class TestBar extends StatefulWidget {
  const TestBar({Key? key}) : super(key: key);
  @override
  _TestBarState createState() => _TestBarState();
}
class _TestBarState extends State<TestBar> with TickerProviderStateMixin {
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'), fit: BoxFit.cover,);
  List images=[
    "coffee01.jpg",
    "coffee02.jpg",
    "coffee03.jpg"
  ];
  List names=[
    "Nap's x Warin",
    "Songsarn",
    "NoteCoffee"
  ];
  List des=[
    "Good Taste",
    "Normal Taste",
    "Bad Taste"
  ];
  @override
  Widget build(BuildContext context) {

    TabController _tabController = 
    TabController(length: 3, vsync: this);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: Column(
            children: [
              Material(
                color: MainColor,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TestAPI()),
                        );
                  },
                  child: Container(
                    width: 500,
                    child: Column(
                      children: [
                        SizedBox(height: 62,),
                        CircleAvatar(
                          radius: 52,
                          backgroundImage: NetworkImage("https://i.pinimg.com/originals/de/33/55/de3355cabf1ae02a58523df7ca252966.png"),
                        ),
                        SizedBox(height: 12,),
                        Text("Park ju-hyun",style: TextStyle(
                          color: Colors.white
                        ),),
                        Text("Park-ju-hyun@gmail.com",style: TextStyle(
                          color: Colors.white
                        ),),
                        SizedBox(height: 12,)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 0
                  ),
                child: Container(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.home),
                        title: Text("Home",style: TextStyle(
                              color: SecondColor
                            ),),
                        onTap: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text("Favorite",style: TextStyle(
                              color: SecondColor
                            ),),
                        onTap: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                        );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.notifications),
                        title: Text("Notification",style: TextStyle(
                              color: SecondColor
                            ),),
                        onTap: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TestBar()),
                        );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Logout",style: TextStyle(
                              color: SecondColor
                            ),),
                        onTap: () {
                          Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
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
        appBar: AppBar(
          title: Logo,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation:  0,
          iconTheme: IconThemeData(color: MainColor),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
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
              Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: MainColor,
                    isScrollable: true,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                    labelColor: MainColor,
                    unselectedLabelColor: SecondColor,
                    tabs: [
                      Tab(text: "RECOMMEND",),
                      Tab(text: "POPULAR",),
                      Tab(text: "NEARBY",),
                    ],
                  ),
                ),
              ), 
              SizedBox(height: 10),
              Container(
                width: double.maxFinite,
                height: 300,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index){
                      return Row(
                        children: [
                          Container(
                            height: 300,
                            width: 200,
                            decoration: BoxDecoration(                         
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/"+images[index],
                                  ),
                                  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
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
                              children: [
                                Text(names[index],style: TextStyle(
                                  color: MainColor,
                                ),),
                                Text(des[index],style: TextStyle(
                                  color: SecondColor,
                                ),),
                                LikeButton(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        size: 20,
                                        likeCount: 0,
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      );
                    }),
                    ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index){
                      return Row(
                        children: [
                          Container(
                            height: 300,
                            width: 200,
                            decoration: BoxDecoration(                         
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/"+images[index],
                                  ),
                                  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
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
                              children: [
                                Text(names[index]),
                                Text(des[index]),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      );
                    }),
                    ListView.builder(
                      itemCount: 3,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index){
                      return Row(
                        children: [
                          Container(
                            height: 300,
                            width: 200,
                            decoration: BoxDecoration(                         
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/"+images[index],
                                  ),
                                  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
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
                              children: [
                                Text(names[index]),
                                Text(des[index]),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text("CATEGORY",style: TextStyle(color: SecondColor,fontSize: 15),)
                  ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
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
                              )
                              ),
                            child: Center(child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/slowbar.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,),
                                ),
                                Text("SLOWBAR",style: TextStyle(
                                  color: MainColor,
                                ),),
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
                              )
                              ),
                            child: Center(child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/speedbar.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,),
                                ),
                                Text("SPEEDBAR",style: TextStyle(
                                  color: MainColor,
                                ),),
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
                              )
                              ),
                            child: Center(child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/hybridbar.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,),
                                ),
                                Text("HYBRIDBAR",style: TextStyle(
                                  color: MainColor,
                                ),),
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
                              )
                              ),
                            child: Center(child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/coffee-cup.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,),
                                ),
                                Text("COFFEE",style: TextStyle(
                                  color: MainColor,
                                ),),
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
                              )
                              ),
                            child: Center(child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/cupcake.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,),
                                ),
                                Text("SWEET",style: TextStyle(
                                  color: MainColor,
                                ),),
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
                              )
                              ),
                            child: Center(child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/blogging.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                    height: 50,),
                                ),
                                Text("COMMUNITY",style: TextStyle(
                                  color: MainColor,
                                ),),
                              ],
                            )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}