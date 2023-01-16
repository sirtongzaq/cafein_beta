import 'package:cafein_beta/page_store/yuanjaimap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YuanjaiPage extends StatefulWidget {
  const YuanjaiPage({super.key});

  @override
  State<YuanjaiPage> createState() => _YuanjaiPageState();
}

class _YuanjaiPageState extends State<YuanjaiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yuanjai Café"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => YuanjaiMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}