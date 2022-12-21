import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/team.dart';

class TestAPI extends StatefulWidget {
  const TestAPI({Key? key}) : super(key: key);
  @override
  _TestAPIState createState() => _TestAPIState();
}

class _TestAPIState extends State<TestAPI> {
  List<Team> teams = [];

  // get team
  Future Getdata() async {
    var response = await http.get(Uri.http("795c-2001-fb1-14b-2778-9568-10c4-d412-d385.ap.ngrok.io", "/test"));
    var jsonData = jsonDecode(response.body);
    var x = jsonData['data'];
    print(x);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        Store: eachTeam['Store'],
        score: eachTeam['score'],
      );
      teams.add(team);
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
        title: const Text('Test API'),
      ),
      body: FutureBuilder(
        future: Getdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: teams.length,
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
                        Text(teams[index].Store),
                        Text(teams[index].score.toString()),
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
