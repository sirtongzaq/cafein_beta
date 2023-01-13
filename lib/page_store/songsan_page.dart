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
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 250,
        child: ListView(
          // This next line does the trick.
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
              width: 350,
              color: Colors.white,
              child: Column(
                children: [
                  Text("data"),
                  Text("data"),
                  Text("data"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}