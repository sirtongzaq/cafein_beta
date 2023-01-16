import 'package:cafein_beta/page_store/phantaemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhantaePage extends StatefulWidget {
  const PhantaePage({super.key});

  @override
  State<PhantaePage> createState() => _PhantaePageState();
}

class _PhantaePageState extends State<PhantaePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phantae Coffee"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PhantaeMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}