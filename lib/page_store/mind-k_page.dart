import 'package:cafein_beta/page_store/Mind-kmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MindkPage extends StatefulWidget {
  const MindkPage({super.key});

  @override
  State<MindkPage> createState() => _MindkPageState();
}

class _MindkPageState extends State<MindkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MiND-K coffee and bake"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => MindkMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}