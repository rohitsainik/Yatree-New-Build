import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

showToast({var message}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}


getDuration({var endPosition,var startPosition }) async{
  var response = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${endPosition.latitude}%2C${endPosition.longitude}&origins=${startPosition.latitude}%2C${startPosition.longitude}&key=AIzaSyCpUax37RAfu-mXq5_JSq9Jog0bbpO8qhk"));
  var responseData = json.decode(response.body);
  var duration = responseData["rows"][0]["elements"][0]["duration"]["value"];
  print("Maps DistanceMatrix Api Response \n ${response.body}");
  var rideDuration = double.parse((duration/60).toString()).round();
  print("Maps DistanceMatrix Api Response duration \n ${double.parse((duration/60).toString()).round()}");
  return rideDuration;
}

getPolylineResult({lat, lng,dlat,dlng,polylinePoints}) async {
  return await polylinePoints.getRouteBetweenCoordinates(
    "AIzaSyCpUax37RAfu-mXq5_JSq9Jog0bbpO8qhk",
    PointLatLng(lat, lng),
    PointLatLng(dlat,dlng),
    travelMode: TravelMode.driving,
    // wayPoints: wayPoint,
  );
}


Future<void> updateCameraLocation(
    LatLng source,
    LatLng destination,
    GoogleMapController mapController,
    ) async {
  if (mapController == null) return;

  LatLngBounds bounds;

  if (source.latitude > destination.latitude &&
      source.longitude > destination.longitude) {
    bounds = LatLngBounds(southwest: destination, northeast: source);
  } else if (source.longitude > destination.longitude) {
    bounds = LatLngBounds(
        southwest: LatLng(source.latitude, destination.longitude),
        northeast: LatLng(destination.latitude, source.longitude));
  } else if (source.latitude > destination.latitude) {
    bounds = LatLngBounds(
        southwest: LatLng(destination.latitude, source.longitude),
        northeast: LatLng(source.latitude, destination.longitude));
  } else {
    bounds = LatLngBounds(southwest: source, northeast: destination);
  }

  CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 70);

  return checkCameraLocation(cameraUpdate, mapController);
}

getPrice(var data) {
  if (data.packageDiscountDetails![0].type == 1) {
    var percent = 100 / data.packageDiscountDetails![0].amount;
    var total = data.packagePrice / percent;
    return total.round();
  } else {
    var total = data.packagePrice - data.packageDiscountDetails![0].amount;
    return total.round();
  }
}

Future<void> checkCameraLocation(
    CameraUpdate cameraUpdate, GoogleMapController mapController) async {
  mapController.animateCamera(cameraUpdate);
  LatLngBounds l1 = await mapController.getVisibleRegion();
  LatLngBounds l2 = await mapController.getVisibleRegion();

  if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
    return checkCameraLocation(cameraUpdate, mapController);
  }
}