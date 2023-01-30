import 'package:cafein_beta/api_service/api_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

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
final user = FirebaseAuth.instance.currentUser!;
List SearchResult = [];

class _SearchPageState extends State<SearchPage> {
  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('search')
        .where(
          "index_name",
          arrayContains: query,
        )
        .get();

    setState(() {
      SearchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: MainColor,
          toolbarHeight: 70,
          title: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search',
                    border: InputBorder.none),
                onChanged: (query) {
                  searchFromFirebase(query.toUpperCase());
                },
              ),
            ),
          )),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: SearchResult.length,
                itemBuilder: (context, index) {
                  var rt = SearchResult[index]["rating"];
                  return Card(
                    child: ListTile(
                      leading: FittedBox(
                          child: Image(
                              image: AssetImage('assets/coffee03.jpg'),
                              fit: BoxFit.fill)),
                      title: Text(SearchResult[index]["string_name"].toString().toUpperCase()),
                      subtitle: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Address : ${SearchResult[index]["address"]}'),
                            Text('Type : ${SearchResult[index]["type"]}'),
                            RatingBarIndicator(
                              rating: double.parse(rt),
                              itemBuilder: (context, index) => TestIMG,
                              itemCount: 5,
                              itemSize: 20,
                              itemPadding: EdgeInsets.symmetric(horizontal: 0),
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
                        apiProvider.gotoPage(
                            SearchResult[index]["string_name"], context);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
