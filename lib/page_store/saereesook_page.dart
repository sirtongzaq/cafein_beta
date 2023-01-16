import 'package:cafein_beta/page_store/saereesookmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SaereesookPage extends StatefulWidget {
  const SaereesookPage({super.key});

  @override
  State<SaereesookPage> createState() => _SaereesookPageState();
}

class _SaereesookPageState extends State<SaereesookPage> {
  final MainColor = Color(0xFFF2D1AF);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saereesook"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SaereesookMapPage()),
          );
        },
        backgroundColor: MainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}