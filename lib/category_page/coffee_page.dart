import 'package:cafein_beta/api_service/api_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class CoffeePage extends StatefulWidget {
  const CoffeePage({super.key});

  @override
  State<CoffeePage> createState() => _CoffeePageState();
}

class _CoffeePageState extends State<CoffeePage> {
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

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee'),
        toolbarHeight: 70,
        elevation: 0,
      ),
      body: StreamBuilder(
          //reviews
          stream: FirebaseFirestore.instance
              .collection("search")
              .orderBy("rating", descending: true)
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
