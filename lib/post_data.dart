import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cafein_beta/api_service/api_provider.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<dynamic> _data = [];
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
  var user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOTIFICATION'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("notifications")
              .where("email_own_post", isEqualTo: user.email)
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        elevation: 10,
                        margin: EdgeInsets.all(10),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 150,
                                      child: Text(data["email"].toString().toUpperCase(),style: TextStyle(
                                        color: SecondColor
                                      ),),
                                    ),
                                    SizedBox(width: 10,),
                                    Text(data["event"].toString().toUpperCase(),style: TextStyle(
                                      color: MainColor
                                    ),),
                                    SizedBox(width: 10,),
                                    Container(
                                      width: 140,
                                      child: Text(data["title"].toString().toUpperCase(),style: TextStyle(
                                        color: SecondColor
                                      ),),
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
    );
  }
}
