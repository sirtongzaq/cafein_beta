import 'package:cafein_beta/page_store/mypapiliomap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MypapilioPage extends StatefulWidget {
  const MypapilioPage({super.key});

  @override
  State<MypapilioPage> createState() => _MypapilioPageState();
}

class _MypapilioPageState extends State<MypapilioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Papilio"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => MypapilioMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}