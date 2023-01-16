import 'package:cafein_beta/page_store/11-11gallerymap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("11.11 Gallery and Coffee"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => GalleryMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}