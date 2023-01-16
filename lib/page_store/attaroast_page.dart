import 'package:cafein_beta/page_store/attaroastmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AttaroastPage extends StatefulWidget {
  const AttaroastPage({super.key});

  @override
  State<AttaroastPage> createState() => _AttaroastPageState();
}

class _AttaroastPageState extends State<AttaroastPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attaroast"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AttaroastMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}