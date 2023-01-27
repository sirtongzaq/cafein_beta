import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
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
  List<dynamic> Data = [];
  getRecData() async {
    var test = {
      'name': 'chunnfriend',
    };
    var url = Uri.https(
        '6336-2001-fb1-148-7898-c1af-9299-adf3-5e89.ap.ngrok.io',
        '/recommend',
        test);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        Data = jsonData["data"];
      });
      print(Data);
      print("Response success");
    } else if (response.statusCode == 400) {
      print('Bad Request: ${response.statusCode}');
    } else {
      print('Response status: ${response.statusCode}');
    }
  }

  

  @override
  void initState() {
    getRecData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POST DATA'),
      ),
      body: ListView.builder(
          // nearby
          itemCount: Data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final data_info = Data[index];
            final name = data_info['store'];
            final rating = data_info['rating'];
            final address = data_info['address\t'];
            final review = data_info['count_rating'].toStringAsFixed(0);
            return InkWell(
              onTap: () {},
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          // title store
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            name,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: RatingBarIndicator(
                            rating: rating,
                            itemBuilder: (context, index) => TestIMG,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0),
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
    );
  }
}
