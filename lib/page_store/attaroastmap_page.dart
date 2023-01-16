import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class AttaroastMapPage extends StatefulWidget {
  const AttaroastMapPage({super.key});

  @override
  State<AttaroastMapPage> createState() => _AttaroastMapPageState();
}

class _AttaroastMapPageState extends State<AttaroastMapPage> {
  Completer<GoogleMapController> _controller = Completer();
  final ShawdowColor = Color.fromRGBO(0, 0, 0, 0.25);
  final SecondColor = Color.fromRGBO(0, 0, 0, 0.50);
  final BgColor = Color(0xFFE6E6E6);
  final MainColor = Color(0xFFF2D1AF);
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyDDmD362j1kUlrRXcAJ8OoHBYCKVpzt1D8";
  static const LatLng sourceLocation = LatLng(15.282450569719284, 104.8333997276588);
  static const LatLng destination = LatLng(15.22733454, 104.8586385);
  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;

  void getCurrentLocation (){
    Location location = Location();

    location.getLocation().then(
      (location) {
      currentLocation = location;
    },);

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      setState(() {});
    },);
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
          ),
      );
      setState(() {  
      });
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attaroast Map",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MainColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: currentLocation == null
            ? const Center(child: CircularProgressIndicator(),)
          :GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          polylines: {
            Polyline(polylineId: PolylineId("route"),
            points: polylineCoordinates,
            color: MainColor,
            width: 5,
            ),
          },
          markers: {
            Marker(
              markerId: MarkerId("currentLocation"),
              position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            ),
            const Marker(
              markerId: MarkerId("source"),
              position: sourceLocation,
            ),
            const Marker(
              markerId: MarkerId("destination"),
              position: destination,
            ),
          },
        ),
      );
    }
  }