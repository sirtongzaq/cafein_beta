import 'package:cafein_beta/page_store/stufemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StufePage extends StatefulWidget {
  const StufePage({super.key});

  @override
  State<StufePage> createState() => _StufePageState();
}

class _StufePageState extends State<StufePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stufe coffee"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => StufeMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}