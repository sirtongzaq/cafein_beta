import 'package:cafein_beta/page_store/amarnamap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AmarnaPage extends StatefulWidget {
  const AmarnaPage({super.key});

  @override
  State<AmarnaPage> createState() => _AmarnaPageState();
}

class _AmarnaPageState extends State<AmarnaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Amarna"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AmarnaMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}