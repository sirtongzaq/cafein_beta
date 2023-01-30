import 'package:cafein_beta/api_service/api_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SpeedbarPage extends StatefulWidget {
  const SpeedbarPage({super.key});

  @override
  State<SpeedbarPage> createState() => _SpeedbarPageState();
}

class _SpeedbarPageState extends State<SpeedbarPage> {
  List<dynamic> slowbar_Data = [];
  final TestIMG = ImageIcon(
      AssetImage(
        'assets/ratting.png',
      ),
      color: Color(0xFFF2D1AF));

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speedbar'),
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: StreamBuilder(
          //reviews
          stream: FirebaseFirestore.instance
              .collection("search")
              .where("type", arrayContains: "speedbar")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    var data = snapshot.data!.docs[i];
                    var rt = data["rating"];
                    return Card(
                      child: ListTile(
                        leading: FittedBox(
                            child: Image(
                                image: AssetImage('assets/coffee03.jpg'),
                                fit: BoxFit.fill)),
                        title: Text(data["string_name"].toString().toUpperCase()),
                        subtitle: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Address : ${data["address"]}'),
                              Text('Type : ${data["type"]}'),
                              RatingBarIndicator(
                                rating: double.parse(rt),
                                itemBuilder: (context, index) => TestIMG,
                                itemCount: 5,
                                itemSize: 20,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                        onTap: () {
                          apiProvider.gotoPage(data["string_name"], context);
                        },
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
