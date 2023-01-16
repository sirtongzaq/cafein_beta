import 'package:cafein_beta/page_store/lavamap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LavaPage extends StatefulWidget {
  const LavaPage({super.key});

  @override
  State<LavaPage> createState() => _LavaPageState();
}

class _LavaPageState extends State<LavaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LAVA JAVA Coffee Roasters"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => LavaMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}