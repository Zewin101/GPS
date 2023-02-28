

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeLayout extends StatelessWidget {

static const String routeName="HomeLayout";
  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        title: Text("GPS"),
      ),
    );
  }
  Location location = Location();
  PermissionStatus? permissionStatus;
  bool serviceEnabled = false;
  LocationData? locationData;

  void getCurrentLocation() async {
    var permission=await isPermissionGranted();
    if(permission==false){
      return;
    }
    var service=await isServiceEnabled();
    if(service==false){
      return;
    }
    locationData = await location.getLocation();
    print(
        'My location ------------- ${locationData?.altitude}\n${locationData?.longitude}');
   location.onLocationChanged.listen((event) {
     locationData=event;
     print(
         'My location ------------- ${locationData?.altitude}\n${locationData?.longitude}');
   });
  }

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
