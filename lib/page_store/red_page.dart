import 'package:cafein_beta/page_store/abemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoguePage extends StatefulWidget {
  const RoguePage({super.key});

  @override
  State<RoguePage> createState() => _RoguePageState();
}

class _RoguePageState extends State<RoguePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("REDCOFFEE"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AbeMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}