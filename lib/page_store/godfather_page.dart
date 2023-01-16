import 'package:cafein_beta/page_store/godfathermap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GodfatherPage extends StatefulWidget {
  const GodfatherPage({super.key});

  @override
  State<GodfatherPage> createState() => _GodfatherPageState();
}

class _GodfatherPageState extends State<GodfatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GODFATHER COFFEE"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => GodfatherMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}