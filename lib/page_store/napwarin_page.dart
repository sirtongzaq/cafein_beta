import 'package:flutter/material.dart';

class NapswarinPage extends StatefulWidget {
  const NapswarinPage({super.key});

  @override
  State<NapswarinPage> createState() => _NapswarinPageState();
}

class _NapswarinPageState extends State<NapswarinPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Naps X Warin"),
      ),
      body: Row(
        children: [
          Text("Nap's_Page_Test"),
          Text("data"),
          Text("data"),
        ],
      ),
    );
  }
}