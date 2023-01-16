import 'package:cafein_beta/page_store/abemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AbePage extends StatefulWidget {
  const AbePage({super.key});

  @override
  State<AbePage> createState() => _AbePageState();
}

class _AbePageState extends State<AbePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Abe Specialty Coffee"),),
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