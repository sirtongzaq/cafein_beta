import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}
class _PostPageState extends State<PostPage> {
 getData() async {
  try {
    var url = Uri.https('8a08-2001-fb1-14b-4a38-2d8b-afc0-f89-2a37.ap.ngrok.io', '/add');
    final response = await http.post(url, body: jsonEncode({
      "name":"MindTong",
      "token":"asldkfjasl;dkfjas;ld",
      "age":21,
      "gender":"famale",
      "fav": [
        "Nap X warin",
        "Nap X Roaster",
        "Seeresok"
    ]
    }),
    headers: {'Content-Type': 'application/json'}
    );
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error: ${response.statusCode}');
    }
    }catch (e) {
      print('Error: $e');
    }
    }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POST DATA'),
      ),
      body: Text("POST DATA"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}