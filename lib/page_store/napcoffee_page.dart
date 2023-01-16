import 'package:cafein_beta/page_store/napcoffeemap_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NapcoffeePage extends StatefulWidget {
  const NapcoffeePage({super.key});

  @override
  State<NapcoffeePage> createState() => _NapcoffeePageState();
}

class _NapcoffeePageState extends State<NapcoffeePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NAP's Coffee & Roasters"),),
      body: Center(child: Text("TEST")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => NapcoffeeMapPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}