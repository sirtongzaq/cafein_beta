import 'package:cafein_beta/page_store/bossamap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BossaPage extends StatefulWidget {
  const BossaPage({super.key});

  @override
  State<BossaPage> createState() => _BossaPageState();
}

class _BossaPageState extends State<BossaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bossa cafe"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => BossaMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}