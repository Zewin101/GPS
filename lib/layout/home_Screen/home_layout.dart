import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeLayout extends StatefulWidget {
  static const String routeName = "HomeLayout";

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 300.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 40.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPS"),
      ),
      body:GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),

    );



  }
  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Location location = Location();
  PermissionStatus? permissionStatus;
  bool serviceEnabled = false;
  LocationData? locationData;

  void getCurrentLocation() async {
    var permission = await isPermissionGranted();
    if (permission == false) {
      return;
    }
    var service = await isServiceEnabled();
    if (service == false) {
      return;
    }
    locationData = await location.getLocation();
    print(
        'My location ------------- ${locationData?.altitude}\n${locationData?.longitude}');
    // listen to location
    // location.onLocationChanged.listen((event) {
    //   locationData = event;
    //   print(
    //       'My location ------------- ${locationData?.altitude}\n${locationData?.longitude}');
    // });
  }

//AIzaSyC_-cPR0SHC--w2dj7mDzZupyjtwYditfQ
  Future<bool> isServiceEnabled() async {
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled == false) {
      serviceEnabled == await location.requestService();
      return serviceEnabled;
    }
    return serviceEnabled;
  }

  Future<bool> isPermissionGranted() async {
    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      return permissionStatus == PermissionStatus.granted;
    } else {
      return permissionStatus == PermissionStatus.granted;
    }
  }
}
