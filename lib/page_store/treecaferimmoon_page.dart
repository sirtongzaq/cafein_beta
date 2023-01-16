import 'package:cafein_beta/page_store/treecaferimmoonmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TreecaferimmoonPage extends StatefulWidget {
  const TreecaferimmoonPage({super.key});

  @override
  State<TreecaferimmoonPage> createState() => _TreecaferimmoonPageState();
}

class _TreecaferimmoonPageState extends State<TreecaferimmoonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tree Cafe Rim Moon"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => TreecaferimmoonMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}