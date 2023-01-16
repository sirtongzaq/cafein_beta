import 'package:cafein_beta/page_store/roundmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundPage extends StatefulWidget {
  const RoundPage({super.key});

  @override
  State<RoundPage> createState() => _RoundPageState();
}

class _RoundPageState extends State<RoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("r o u n d"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => RoundMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}