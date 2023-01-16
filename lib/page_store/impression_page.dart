import 'package:cafein_beta/page_store/impressionmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImpressionPage extends StatefulWidget {
  const ImpressionPage({super.key});

  @override
  State<ImpressionPage> createState() => _ImpressionPageState();
}

class _ImpressionPageState extends State<ImpressionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Impression Sunrise"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ImpressionMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}