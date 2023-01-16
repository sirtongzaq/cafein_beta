import 'package:cafein_beta/page_store/balconymap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BalconyPage extends StatefulWidget {
  const BalconyPage({super.key});

  @override
  State<BalconyPage> createState() => _BalconyPageState();
}

class _BalconyPageState extends State<BalconyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BalconyKiss Coffee"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => BalconyMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}