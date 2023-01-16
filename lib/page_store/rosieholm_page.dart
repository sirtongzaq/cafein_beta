import 'package:cafein_beta/page_store/rosieholmmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RosieholmPage extends StatefulWidget {
  const RosieholmPage({super.key});

  @override
  State<RosieholmPage> createState() => _RosieholmPageState();
}

class _RosieholmPageState extends State<RosieholmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ROSIEHOLM"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => RosieholmMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}