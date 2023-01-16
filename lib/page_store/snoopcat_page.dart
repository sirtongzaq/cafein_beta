import 'package:cafein_beta/page_store/snoopcatmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnoopcatPage extends StatefulWidget {
  const SnoopcatPage({super.key});

  @override
  State<SnoopcatPage> createState() => _SnoopcatPageState();
}

class _SnoopcatPageState extends State<SnoopcatPage> {
  final MainColor = Color(0xFFF2D1AF);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Snoopcat Cafe"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SnoopcatMapPage()),
          );
        },
        backgroundColor: MainColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}