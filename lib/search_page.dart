import 'package:cafein_beta/home_page.dart';
import 'package:cafein_beta/page_store/napwarin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  
  @override
  State<SearchPage> createState() => _SearchPageState();
}
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF),size: 1,);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'),fit: BoxFit.cover,);
  final user = FirebaseAuth.instance.currentUser!;
  List SearchResult =  [];

class _SearchPageState extends State<SearchPage> {
  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
    .collection('search')
    .where("index_name",arrayContains: query,)
    .get();

    setState(() {
      SearchResult = result.docs.map((e) => e.data()).toList();
    });
  }

  void gotoPage(String pageName){
   switch(pageName) { 
      case 'Home': { 
         // statements; 
   Navigator.push(context,CupertinoPageRoute(builder: (redContext) => HomePage())); 
      } 
      break; 
     
      case "NapswarinPage": { 
         //statements; 
   Navigator.push(context,CupertinoPageRoute(builder: (redContext) => NapswarinPage()));
      } 
      break; 
         
      default: { 
         throw Exception("Path ${pageName} not supported");
   
      }
      break; 
     }
  }   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              searchFromFirebase(query);
            },
          ),
        ),
      )),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
            itemCount: SearchResult.length,
            itemBuilder: (context, index){
              return Card( 
                child: ListTile(
                  leading: FittedBox(
                    child: Image(image: AssetImage('assets/coffee03.jpg'),fit: BoxFit.fill)),
                  title: Text(SearchResult[index]["string_name"]),
                  subtitle: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rating : ${SearchResult[index]["rating"]}'),
                        Text('Type : ${SearchResult[index]["type"]}'),
                        Text('Address : ${SearchResult[index]["address"]}'),
                      ],
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                  onTap: () {
                    gotoPage(SearchResult[index]["route"]);
                  },
                  ),
              );
            }
            ),
            ),
        ],
      ),
    );
  }
}