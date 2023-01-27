import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class TestAPIPage extends StatefulWidget {
  const TestAPIPage({super.key});

  @override
  State<TestAPIPage> createState() => _TestAPIPageState();
}

class _TestAPIPageState extends State<TestAPIPage> {
  List<dynamic> popularData = [];
  


  @override
  void initState() {
   
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TESTAPI'),
      ),
      body: Text("S"),
    );
  }
}
