import 'package:cafein_beta/page_store/blendstormmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlendstormPage extends StatefulWidget {
  const BlendstormPage({super.key});

  @override
  State<BlendstormPage> createState() => _BlendstormPageState();
}

class _BlendstormPageState extends State<BlendstormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Blendstorm Coffee Roasters"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => BlendstormMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}