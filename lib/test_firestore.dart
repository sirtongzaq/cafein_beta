import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});
  @override
  State<TestPage> createState() => _TestPageState();
}
  
class _TestPageState extends State<TestPage> {
  String? name = "";
  String? email = "";
  
  Future _getDataFromDatabase() async {
    await FirebaseFirestore.instance.collection("users")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get()
    .then((snapshot) async 
    {
      if(snapshot.exists) 
      {
        setState(() {
          name = snapshot.data()!["username"];
          email = snapshot.data()!["email"];
        });
      }
    });
  }
  @override
  void initState() {
    _getDataFromDatabase();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
      body: Column(
        children: [
          Text(name!),
          Text(email!),
        ],
      ),
    );
  }
}