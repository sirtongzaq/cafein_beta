import 'package:cafein_beta/page_store/annamap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnnaPage extends StatefulWidget {
  const AnnaPage({super.key});

  @override
  State<AnnaPage> createState() => _AnnaPageState();
}

class _AnnaPageState extends State<AnnaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Anna Roasters"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AnnaMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}