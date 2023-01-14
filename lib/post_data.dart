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
    var url = Uri.https('eae1-2001-fb1-149-cb0e-c8ac-b6cc-37bb-e43.ap.ngrok.io', '/add');
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