import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class WhereiamPage extends StatefulWidget {
  const WhereiamPage({super.key});

  @override
  State<WhereiamPage> createState() => _WhereiamPageState();
}
class _WhereiamPageState extends State<WhereiamPage> {
  final maxLines = 5;
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF),size: 1,);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'),fit: BoxFit.cover,);
  final _messageController = TextEditingController();
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl='';
  double? ratings ;
  var likecounts = 0;
  var user = FirebaseAuth.instance.currentUser!;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TEST API PROVIDER"),),
      body: Text("TEST API PROVIDER"),
      
    );
  }
  
}

