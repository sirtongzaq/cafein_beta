import 'package:cafein_beta/page_store/bannmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BannPage extends StatefulWidget {
  const BannPage({super.key});

  @override
  State<BannPage> createState() => _BannPageState();
}

class _BannPageState extends State<BannPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BaanHuakham Cafe & Farmstay"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => BannMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}