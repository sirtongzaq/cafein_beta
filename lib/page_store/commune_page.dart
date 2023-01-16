import 'package:cafein_beta/page_store/communemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommunePage extends StatefulWidget {
  const CommunePage({super.key});

  @override
  State<CommunePage> createState() => _CommunePageState();
}

class _CommunePageState extends State<CommunePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Commune Drink/Talk/Share"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => CommuneMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}