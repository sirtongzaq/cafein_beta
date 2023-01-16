import 'package:cafein_beta/page_store/sangobmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SagnobPage extends StatefulWidget {
  const SagnobPage({super.key});

  @override
  State<SagnobPage> createState() => _SagnobPageState();
}

class _SagnobPageState extends State<SagnobPage> {
  final MainColor = Color(0xFFF2D1AF);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sangob"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SangobMapPage()),
          );
        },
        backgroundColor: MainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}