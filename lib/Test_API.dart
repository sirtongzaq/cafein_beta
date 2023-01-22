import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class TestAPIPage extends StatefulWidget {
  const TestAPIPage({super.key});

  @override
  State<TestAPIPage> createState() => _TestAPIPageState();
}
class _TestAPIPageState extends State<TestAPIPage> {
  List<dynamic> latlong_data = [];
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF));
  getData() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final lat_user = position.latitude;
    final long_user = position.longitude;
    print(lat_user);
    print(long_user);
    final latlong_user = {'latitude' : '${lat_user}','longitude' : '${long_user}'};
    var url = Uri.https('8a08-2001-fb1-14b-4a38-2d8b-afc0-f89-2a37.ap.ngrok.io', '/nearby', latlong_user);
    var response = await http.get(url);
    var jsonData = jsonDecode(response.body); 
    print('Response status: ${response.statusCode}');
    setState(() {
      latlong_data = jsonData;
    });
    print(latlong_data.length.toInt());
    print(latlong_data[0]);
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
        title: const Text('Nearby'),
      ),
      body: ListView.builder(
        itemCount: latlong_data.length,
        itemBuilder: (context, index) {
        final latlong_info = latlong_data[index];
        final name = latlong_info['store'];
        final distance = latlong_info['distance'].toStringAsFixed(2);
        final lat = latlong_info['latitude'];
        final long = latlong_info['longitude'];
        return Card( 
          child: ListTile(
            leading: FittedBox(
              child: Image(image: AssetImage('assets/coffee03.jpg'),fit: BoxFit.fill)),
            title: Text(name),
            subtitle: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Distance : ${distance} Km'),
                  Text('Latitude : ${lat.toString()}'),
                  Text('Longitude : ${long.toString()}'),
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