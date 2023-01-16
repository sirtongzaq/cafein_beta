import 'package:cafein_beta/page_store/bluescoffeemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BluescoffeePage extends StatefulWidget {
  const BluescoffeePage({super.key});

  @override
  State<BluescoffeePage> createState() => _BluescoffeePageState();
}

class _BluescoffeePageState extends State<BluescoffeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blues Coffee"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => BluescoffeeMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}