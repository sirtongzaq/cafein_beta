import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TestCPage extends StatefulWidget {
  const TestCPage({super.key});
  @override
  State<TestCPage> createState() => _TestCPageState();
}
  
class _TestCPageState extends State<TestCPage> {
  int? _age = 0 ;
  String? _username = "";
  String? _email = "";
  String? _uid = "";
  Future getDataFromDatabase() async {
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    var snapshot = await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
    if (snapshot.exists) {
      setState(() {
        _username = snapshot.data()!["username"];
        _email = snapshot.data()!["email"];
        _uid = snapshot.data()!["uid"];
        _age = snapshot.data()!["age"];
      });
    }
  }
}

  @override
  void initState() {
    getDataFromDatabase();
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
          Text(_username!),
          Text(_email!),
          Text(_uid!),
          Text(_age.toString()),
        ],
      ),
    );
  }
}