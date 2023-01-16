import 'package:cafein_beta/page_store/songsarnmap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SongsarnPage extends StatefulWidget {
  const SongsarnPage({super.key});

  @override
  State<SongsarnPage> createState() => _SongsarnPageState();
}

class _SongsarnPageState extends State<SongsarnPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SongSarn"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SongsarnMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}