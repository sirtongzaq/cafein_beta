import 'package:cafein_beta/page_store/roofmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoofPage extends StatefulWidget {
  const RoofPage({super.key});

  @override
  State<RoofPage> createState() => _RoofPageState();
}

class _RoofPageState extends State<RoofPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ROOF COFFEE"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => RoofMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}