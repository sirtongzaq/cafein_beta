import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class SpeedbarPage extends StatefulWidget {
  const SpeedbarPage({super.key});

  @override
  State<SpeedbarPage> createState() => _SpeedbarPageState();
}
class _SpeedbarPageState extends State<SpeedbarPage> {
  List<dynamic> slowbar_Data = [];
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF));
  getData() async {
    var url = Uri.https('8a08-2001-fb1-14b-4a38-2d8b-afc0-f89-2a37.ap.ngrok.io', '/type', {'type' : 'speedbar'},);
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body); 
    print('Response status: ${response.statusCode}');
    setState(() {
      slowbar_Data = jsonData;
    });
    print(slowbar_Data.length.toInt());
    print("Response success");
    }

  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speedbar'),
      ),
      body: ListView.builder(
        itemCount: slowbar_Data.length,
        itemBuilder: (context, index) {
        final bar = slowbar_Data[index];
        final name = bar['store'];
        final rating = bar['rating'];
        final address = bar['address\t'];
        final type = bar['type'];
        return Card( 
          child: ListTile(
            leading: FittedBox(
              child: Image(image: AssetImage('assets/coffee03.jpg'),fit: BoxFit.fill)),
            title: Text(name),
            subtitle: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address : ${address}'),
                  Text('Type : ${type}'),
                  Text('Rating : ${rating.toString()}'),
                  RatingBarIndicator(
                    rating: rating,
                    itemBuilder: (context, index) =>
                        TestIMG,
                    itemCount: 5,
                    itemSize: 20,
                    itemPadding:
                        EdgeInsets.symmetric(
                            horizontal: 0),
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Icon(Icons.arrow_forward_ios),
            ),
            onTap: () {
            },
            ),
        );
      }
      ),
    );
  }
}