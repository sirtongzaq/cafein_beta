import 'package:cafein_beta/page_store/lifemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LifePage extends StatefulWidget {
  const LifePage({super.key});

  @override
  State<LifePage> createState() => _LifePageState();
}

class _LifePageState extends State<LifePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LIFE Roasters"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => LifeMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}