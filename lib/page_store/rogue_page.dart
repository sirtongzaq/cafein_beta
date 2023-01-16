import 'package:cafein_beta/page_store/abemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RedPage extends StatefulWidget {
  const RedPage({super.key});

  @override
  State<RedPage> createState() => _RedPageState();
}

class _RedPageState extends State<RedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rogue Roasters"),),
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