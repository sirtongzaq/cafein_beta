import 'dart:async';

import 'package:cafein_beta/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';


class WhereiamPage extends StatefulWidget {
  const WhereiamPage({super.key});

  @override
  State<WhereiamPage> createState() => _WhereiamPageState();
}
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  final TestIMG = ImageIcon(AssetImage('assets/ratting.png',),color: Color(0xFFF2D1AF),size: 1,);
  final Logo = Image(image: AssetImage('assets/cafein_logo.png'),fit: BoxFit.cover,);
  final user = FirebaseAuth.instance.currentUser!;
  var latitude = '';
  var longitude = '';
  var address = '';
  late StreamSubscription<Position> streamSubscription;

class _WhereiamPageState extends State<WhereiamPage> {
  
  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address = '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
    print(address);
  }

  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  LocationData? currentLocation;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 
  streamSubscription = Geolocator.getPositionStream().listen((Position position) {
      latitude = 'Latitude : ${position.latitude}';
      longitude = 'Longitude : ${position.longitude}';
      getAddressFromLatLang(position);
    });
  return await Geolocator.getCurrentPosition();
}

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CHECK LAT LONGS"),),
      body: Text(address),
    );
  }
  
}

