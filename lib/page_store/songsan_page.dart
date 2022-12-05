import 'package:flutter/material.dart';

class SongsanPage extends StatefulWidget {
  const SongsanPage({super.key});

  @override
  State<SongsanPage> createState() => _SongsanPageState();
}

class _SongsanPageState extends State<SongsanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Naps X Warin"),
      ),
      body: Row(
        children: [
          Text("Songsan_Page"),
        ],
      ),
    );
  }
}