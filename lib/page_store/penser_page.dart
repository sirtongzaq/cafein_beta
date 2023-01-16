import 'package:cafein_beta/page_store/pensermap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PenserPage extends StatefulWidget {
  const PenserPage({super.key});

  @override
  State<PenserPage> createState() => _PenserPageState();
}

class _PenserPageState extends State<PenserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PENSER CAFE"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PenserMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}