// ignore_for_file: prefer_const_constructors

import 'package:cafein_beta/Test_star.dart';
import 'package:cafein_beta/login_page.dart';
import 'package:cafein_beta/auth/main_page.dart';
import 'package:cafein_beta/page_store/napwarin_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: Color(0xFFF2D1AF),
            ),
        primaryColor: Color(0xFFF2D1AF),
        textTheme: GoogleFonts.mitrTextTheme(), 
        scaffoldBackgroundColor: Color(0xFFE6E6E6),
      ),
      home: MainPage(),
    );
  }
}
