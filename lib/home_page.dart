import 'dart:async';
import 'dart:convert';
import 'package:cafein_beta/api_service/api_provider.dart';
import 'package:cafein_beta/auth/main_page.dart';
import 'package:cafein_beta/category_page/bakery_page.dart';
import 'package:cafein_beta/category_page/coffee_page.dart';
import 'package:cafein_beta/category_page/hybridbar_page.dart';
import 'package:cafein_beta/category_page/speedbar_page.dart';
import 'package:cafein_beta/community/community_page.dart';
import 'package:cafein_beta/category_page/slowbar_page.dart';
import 'package:cafein_beta/post_data.dart';
import 'package:cafein_beta/profile_page.dart';
import 'package:cafein_beta/search_page.dart';
import 'package:cafein_beta/test_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
  var latitude = '';
  var longitude = '';
  var address = 'Loading';
  late StreamSubscription<Position> streamSubscription;
  late String _username;
  late String _email;
  late String _uid;
  late int _age;

  Future<void> likePost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection("reviews")
            .doc(postid)
            .update({
          "likes": FieldValue.arrayRemove([uid]),
          "likes_count": FieldValue.increment(-1),
        });
      } else {
        await FirebaseFirestore.instance
            .collection("reviews")
            .doc(postid)
            .update({
          "likes": FieldValue.arrayUnion([uid]),
          "likes_count": FieldValue.increment(1),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address =
        'Address : ${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    LocationData? currentLocation;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude = 'Latitude : ${position.latitude}';
      longitude = 'Longitude : ${position.longitude}';
      getAddressFromLatLang(position);
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    TabController _tabController = TabController(length: 3, vsync: this);
    return Scaffold(
      drawer: Drawer(
        //drawer
        child: Column(
          children: [
            Material(
              color: MainColor,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
                child: Container(
                  width: 500,
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .where("uid", isEqualTo: user.uid)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    var data = snapshot.data!.docs[i];
                                    _username = data["username"];
                                    _email = data["uid"];
                                    _uid = data["gender"];
                                    _age = data["age"];
                                    return Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 52,
                                          backgroundImage:
                                              NetworkImage(data["image"]),
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
                            } else {
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
                      leading: Icon(Icons.search),
                      title: Text(
                        "Search",
                        style: TextStyle(color: SecondColor),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => const SearchPage()),
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
                              builder: (context) => const TestPage()),
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
                              builder: (context) => const PostPage()),
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
            AppBar(
              toolbarHeight: 70,
              title: Logo,
              centerTitle: true,
              backgroundColor: BgColor,
              elevation: 0,
              iconTheme: IconThemeData(color: MainColor),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Container(
                      // tab hearder
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: MainColor,
                          isScrollable: false,
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
                    Container(
                      // tab body
                      width: double.maxFinite,
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          FutureBuilder(
                            // recommend
                            future: apiProvider.fetchDataRec({
                              'name': user.uid,
                            }),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                  // recommend
                                  itemCount: apiProvider.dataRec.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final data_info =
                                        apiProvider.dataRec[index];
                                    final name = data_info['store'];
                                    final rating = data_info['rating'];
                                    final address = data_info['address\t'];
                                    final review = data_info['count_rating']
                                        .toStringAsFixed(0);
                                    return InkWell(
                                      onTap: () {
                                        apiProvider.gotoPage(name, context);
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
                                                  "assets/coffee01.jpg",
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
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    name.toString().toUpperCase(),
                                                    style: TextStyle(
                                                      color: MainColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  // address store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Card(
                                                    elevation: 0,
                                                    child: Text(
                                                      address,
                                                      style: TextStyle(
                                                        color: SecondColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  // distance store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "REVIEW ",
                                                        style: TextStyle(
                                                          color: MainColor,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 120,
                                                        child: Text(
                                                          "${review}",
                                                          style: TextStyle(
                                                            color: SecondColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Padding(
                                                  // ratting store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: RatingBarIndicator(
                                                    rating: rating,
                                                    itemBuilder:
                                                        (context, index) =>
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
                                  });
                            },
                          ),
                          FutureBuilder(
                            // popular
                            future: apiProvider.fetchDataPop(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                  // popular
                                  itemCount: apiProvider.dataPop.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, i) {
                                    var data = apiProvider.dataPop[i];
                                    var name = data["Store_name"];
                                    var address = data["addr"];
                                    var rating = data["rating"];
                                    var cont_rating =
                                        data["count_rating"].toStringAsFixed(0);
                                    return InkWell(
                                      onTap: () {
                                        apiProvider.gotoPage(name, context);
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
                                                  "assets/coffee01.jpg",
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
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    name.toString().toUpperCase(),
                                                    style: TextStyle(
                                                      color: MainColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  // address store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Card(
                                                    elevation: 0,
                                                    child: Text(
                                                      address,
                                                      style: TextStyle(
                                                        color: SecondColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  // distance store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "REVIEW ",
                                                        style: TextStyle(
                                                          color: MainColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        cont_rating,
                                                        style: TextStyle(
                                                          color: SecondColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Padding(
                                                  // ratting store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: RatingBarIndicator(
                                                    rating: rating,
                                                    itemBuilder:
                                                        (context, index) =>
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
                                  });
                            },
                          ),
                          FutureBuilder(
                            // nearby
                            future: apiProvider.fetchDataNear(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                  // nearby
                                  itemCount: apiProvider.dataNear.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final latlong_info =
                                        apiProvider.dataNear[index];
                                    final name = latlong_info['store'];
                                    final distance = latlong_info['distance']
                                        .toStringAsFixed(2);
                                    final rating = latlong_info['rating'];
                                    final address = latlong_info['address\t'];
                                    return InkWell(
                                      onTap: () {
                                        apiProvider.gotoPage(name, context);
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
                                                  "assets/coffee01.jpg",
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
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    name.toString().toUpperCase(),
                                                    style: TextStyle(
                                                      color: MainColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  // address store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Card(
                                                    elevation: 0,
                                                    child: Text(
                                                      address,
                                                      style: TextStyle(
                                                        color: SecondColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  // distance store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "DISTANCE ",
                                                        style: TextStyle(
                                                          color: MainColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${distance} Km",
                                                        style: TextStyle(
                                                          color: SecondColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Padding(
                                                  // ratting store
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: RatingBarIndicator(
                                                    rating: rating,
                                                    itemBuilder:
                                                        (context, index) =>
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
                                  });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      // category header
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "CATEGORY",
                            style: TextStyle(color: SecondColor, fontSize: 15),
                          )),
                    ),
                    Padding(
                      // category body
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const SlowbarPage()),
                                  );
                                },
                                child: Padding(
                                  // slowbar tab
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
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const SpeedbarPage()),
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
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const HybridPage()),
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
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const CoffeePage()),
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
                                          "COFFEE",
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
                                        builder: (context) =>
                                            const BakeryPage()),
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
                                            'assets/cupcake.png',
                                            fit: BoxFit.cover,
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                        Text(
                                          "BAKERY",
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
                                        builder: (context) =>
                                            const CommunityPage()),
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
                                          "COMMUNITY",
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
                        ],
                      ),
                    ),
                    Padding(
                      // CONTENT header
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "latest review".toUpperCase(),
                            style: TextStyle(color: SecondColor, fontSize: 15),
                          )),
                    ),
                    StreamBuilder(
                        //reviews
                        stream: FirebaseFirestore.instance
                            .collection("reviews")
                            .orderBy("date", descending: true)
                            .limit(5)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              height: 420,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    var data = snapshot.data!.docs[i];
                                    int likesCount = data["likes"].length;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
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
                                                      style: TextStyle(
                                                          color: MainColor),
                                                    ),
                                                    Text(
                                                      data["email"],
                                                      style: TextStyle(
                                                          color: SecondColor),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: 300,
                                                  child: Text(
                                                    data["message"],
                                                    style: TextStyle(
                                                        color: SecondColor),
                                                  ),
                                                ),
                                                Image.network(data["image"],
                                                    width: 300),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "RATING ",
                                                      style: TextStyle(
                                                          color: MainColor),
                                                    ),
                                                    RatingBarIndicator(
                                                      rating: data["rating"],
                                                      itemBuilder:
                                                          (context, index) =>
                                                              TestIMG,
                                                      itemCount: 5,
                                                      itemSize: 15,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0),
                                                      direction:
                                                          Axis.horizontal,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "DATE ",
                                                      style: TextStyle(
                                                          color: MainColor),
                                                    ),
                                                    Text(
                                                      data["date"],
                                                      style: TextStyle(
                                                          color: SecondColor),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "STORE ",
                                                      style: TextStyle(
                                                          color: MainColor),
                                                    ),
                                                    Text(
                                                      data["store_name"],
                                                      style: TextStyle(
                                                          color: SecondColor),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    GestureDetector(
                                                      child: Icon(
                                                        Icons.favorite,
                                                        color: (data["likes"]
                                                                .contains(
                                                                    user.uid))
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
                                                      style: TextStyle(
                                                          color: SecondColor),
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
                    SizedBox(
                      height: 15,
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
