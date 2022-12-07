import 'dart:convert';

import 'package:cafein_beta/model/slowbar_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SlowbarPage extends StatefulWidget {
  const SlowbarPage({super.key});

  @override
  State<SlowbarPage> createState() => _SlowbarPageState();
}

class _SlowbarPageState extends State<SlowbarPage> {
  List<Teams> tiles = [];

  // get team
  Future Getdata() async {
    var response = await http.get(Uri.http("e5f7-2001-fb1-14b-2778-9568-10c4-d412-d385.ap.ngrok.io", "store/slowbar"));
    var jsonData = jsonDecode(response.body);
    var x = jsonData['data'];
    print(x);

    for (var eachTeam in jsonData['data']) {
      final team = Teams(
        Name: eachTeam['Name'],
      );
      tiles.add(team);
    }
  }

  @override
  void dispose() {
    Getdata();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slowbar'),
      ),
      body: FutureBuilder(
        future: Getdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(tiles[index].Name),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}