import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:web_socket_channel/io.dart';
// import 'package:location/location.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/model/ride/rideDetail.dart';
import 'package:yatree/model/ride/ride_master_modle.dart';
import 'package:yatree/model/ride/ride_modle.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/createBooking.dart';
import 'package:yatree/services/cutomListTable.dart';
import 'package:yatree/ui/booking/complete_page.dart';
import 'package:yatree/utils/commonFunctions.dart';
import 'package:yatree/utils/sharedPreference.dart';

import '../../Screens/perspective.dart';

class BookingConfirm extends StatefulWidget {
  BookingConfirm({Key? key, this.ridesdata}) : super(key: key);
  GetUserRide? ridesdata;

  @override
  _BookingConfirmState createState() => _BookingConfirmState();
}

class _BookingConfirmState extends State<BookingConfirm> {
  RideMasterModel? ridedata;
  Completer<GoogleMapController> _googleMapController = Completer();
  AllPackageDataModel? packageListdata;

  late GoogleMapController controller;

  // for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<PolylineWayPoint> wayPoint = [];
  GetRideDetails? ridedetails;

  PolylinePoints polylinePoints = PolylinePoints();
  var rideStatus, placeId;
  var placeIdIndex = -1;
  List<CustomListTable> customListdata = [];

  var operation;
  Set<Marker> markers = Set();

  double CAMERA_ZOOM = 16;

  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor pickupIcon, destinationIcon;

  @override
  void initState() {
    super.initState();
    rideStatus = widget.ridesdata!.status;
    print(rideStatus);
    getData();
    setDriverMarkerIcons();
    setLocationMarkerIcons();
    getRideDetails();
    fetchDriverData();
    getRideMasterStream();
    getRideMasterStreamtwo();
    // fetchDriverLocation();
  }

  createMarkers() {
    print(
        "lat lng ${customListdata[0].startLocationLatitude!} ${customListdata[0].startLocationLongitude!}");
    var marker1 = Marker(
      markerId: MarkerId("1"),
      position: LatLng(customListdata[0].startLocationLatitude!,
          customListdata[0].startLocationLongitude!),
      icon: pickupIcon,
      infoWindow: InfoWindow(
        title: "${customListdata[0].startLocationName}",
      ),
    );
    var marker2 = Marker(
      markerId: MarkerId("2"),
      position: LatLng(customListdata[0].endLocationLatitude!,
          customListdata[0].endLocationLongitude!),
      icon: destinationIcon,
      infoWindow: InfoWindow(
        title: "${customListdata[0].endLocationName}",
      ),
    );
    setState(() {
      markers.add(marker1);
      markers.add(marker2);
    });
    print(markers);

    if (widget.ridesdata!.rideType.toString() == "1") {
      for (var i = 0;
          i <
              packageListdata!
                  .getPackagesDetails![0].packagePlaceMappingDetails!.length;
          i++) {
        var marker = Marker(
          markerId: MarkerId(packageListdata!
              .getPackagesDetails![0].packagePlaceMappingDetails![i].placeId
              .toString()),
          position: LatLng(
              packageListdata!.getPackagesDetails![0]
                  .packagePlaceMappingDetails![i].latitude!
                  .toDouble(),
              packageListdata!.getPackagesDetails![0]
                  .packagePlaceMappingDetails![i].longitude!
                  .toDouble()),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: InfoWindow(
            title:
                "${packageListdata!.getPackagesDetails![0].packagePlaceMappingDetails![i].placeName}",
          ),
        );
        setState(() {
          markers.add(marker);
        });
      }
    }
  }

  void updatePinOnMap(lat, lng) async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      // tilt: CAMERA_TILT,
      // bearing: CAMERA_BEARING,
      target: LatLng(lat, lng),
    );

    GoogleMapController? controller = await _googleMapController.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(lat, lng);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      markers.removeWhere((m) => m.markerId.value == "sourcePin");
      markers.add(Marker(
          markerId: MarkerId("sourcePin"),
          position: pinPosition, // updated position
          icon: sourceIcon));
    });

    setPolylines(lat, lng);
  }

  void setPolylines(lat, lng) async {
    List<LatLng> polylineCoordinates = [];
    // for (var i = 0;
    //     i <
    //         packageListdata!
    //             .getPackagesDetails![0].packagePlaceMappingDetails!.length;
    //     i++) {
    //   setState(() {
    //     wayPoint.add(PolylineWayPoint(
    //         location:
    //             "${packageListdata!.getPackagesDetails![0].packagePlaceMappingDetails![i].latitude},${packageListdata!.getPackagesDetails![0].packagePlaceMappingDetails![i].longitude}",
    //         stopOver: true));
    //   });
    // }
    Position position = await Geolocator.getCurrentPosition();
    print(
        "---------------------------------------------------------------------------");
    print("place id is $placeId");
    print("ride type is ${widget.ridesdata!.rideType}");
    print("ridestatus is $rideStatus");
    print(
        "---------------------------------------------------------------------------");
    print(packageListdata!
        .getPackagesDetails![0].packagePlaceMappingDetails!.length);
    print(packageListdata!.getPackagesDetails!);
    print(
        "---------------------------------------------------------------------------");

    PolylineResult? result;
    int index = packageListdata!
        .getPackagesDetails![0].packagePlaceMappingDetails!
        .indexWhere((element) => element.placeId == placeId);
    if (placeId != null && widget.ridesdata!.rideType != 2 && index >= 0) {
      print("index is $index");
      print(
          "---------------------------------------------------------------------------");

      if (index !=
          packageListdata!
                  .getPackagesDetails![0].packagePlaceMappingDetails!.length -
              1) {
        result = await getPolylineResult(
            lat: packageListdata!.getPackagesDetails![0]
                .packagePlaceMappingDetails![index].latitude!,
            lng: packageListdata!.getPackagesDetails![0]
                .packagePlaceMappingDetails![index].longitude!,
            dlat: packageListdata!.getPackagesDetails![0]
                .packagePlaceMappingDetails![index + 1].latitude!,
            dlng: packageListdata!.getPackagesDetails![0]
                .packagePlaceMappingDetails![index + 1].longitude!,
            polylinePoints: polylinePoints);

        await updateCameraLocation(
            LatLng(
                packageListdata!.getPackagesDetails![0]
                    .packagePlaceMappingDetails![index].latitude!,
                packageListdata!.getPackagesDetails![0]
                    .packagePlaceMappingDetails![index].longitude!),
            LatLng(
                packageListdata!.getPackagesDetails![0]
                    .packagePlaceMappingDetails![index + 1].latitude!,
                packageListdata!.getPackagesDetails![0]
                    .packagePlaceMappingDetails![index + 1].longitude!),
            controller);
      } else if (index ==
          packageListdata!
                  .getPackagesDetails![0].packagePlaceMappingDetails!.length -
              1) {
        result = await getPolylineResult(
            lat: packageListdata!.getPackagesDetails![0]
                .packagePlaceMappingDetails![index].latitude!,
            lng: packageListdata!.getPackagesDetails![0]
                .packagePlaceMappingDetails![index].longitude!,
            dlat: customListdata[0].startLocationLatitude,
            dlng: customListdata[0].startLocationLongitude,
            polylinePoints: polylinePoints);

        await updateCameraLocation(
            LatLng(
                packageListdata!.getPackagesDetails![0]
                    .packagePlaceMappingDetails![index].latitude!,
                packageListdata!.getPackagesDetails![0]
                    .packagePlaceMappingDetails![index].longitude!),
            LatLng(
              customListdata[0].startLocationLatitude ?? 0.0,
              customListdata[0].startLocationLongitude ?? 0.0,
            ),
            controller);
      }
    } else if (widget.ridesdata!.rideType != 2 && rideStatus == 3) {
      result = await getPolylineResult(
          lat: lat,
          lng: lng,
          dlat: customListdata[0].startLocationLatitude,
          dlng: customListdata[0].startLocationLongitude,
          polylinePoints: polylinePoints);

      await updateCameraLocation(
          LatLng(lat, lng),
          LatLng(customListdata[0].startLocationLatitude!,
              customListdata[0].startLocationLongitude!),
          controller);
    } else if (widget.ridesdata!.rideType != 2) {
      result = await getPolylineResult(
          lat: lat,
          lng: lng,
          dlat: packageListdata!
              .getPackagesDetails![0].packagePlaceMappingDetails![0].latitude!,
          dlng: packageListdata!
              .getPackagesDetails![0].packagePlaceMappingDetails![0].longitude!,
          polylinePoints: polylinePoints);

      await updateCameraLocation(
          LatLng(lat, lng),
          LatLng(
              packageListdata!.getPackagesDetails![0]
                  .packagePlaceMappingDetails![0].latitude!,
              packageListdata!.getPackagesDetails![0]
                  .packagePlaceMappingDetails![0].longitude!),
          controller);
    } else if (widget.ridesdata!.rideType == 2 && rideStatus == 3) {
      result = await getPolylineResult(
          lat: lat,
          lng: lng,
          dlat: customListdata[0].startLocationLatitude,
          dlng: customListdata[0].startLocationLongitude,
          polylinePoints: polylinePoints);

      await updateCameraLocation(
          LatLng(lat, lng),
          LatLng(customListdata[0].startLocationLatitude!,
              customListdata[0].startLocationLongitude!),
          controller);
    } else {
      result = await getPolylineResult(
          lat: customListdata[0].startLocationLatitude,
          lng: customListdata[0].startLocationLongitude,
          dlat: customListdata[0].endLocationLatitude,
          dlng: customListdata[0].endLocationLongitude,
          polylinePoints: polylinePoints);

      await updateCameraLocation(
          LatLng(customListdata[0].startLocationLatitude!,
              customListdata[0].startLocationLongitude!),
          LatLng(customListdata[0].endLocationLatitude!,
              customListdata[0].endLocationLongitude!),
          controller);
    }

// print("result is");
// print(result!.points.toList().toString());
// print(result.errorMessage.toString());

    if (result!.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 2,
            geodesic: true,
            // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  void setDriverMarkerIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0), 'assets/png/Auto.png')
        .then((onValue) {
      sourceIcon = onValue;
    });
  }

  void setLocationMarkerIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.0), 'assets/png/pickUp.png')
        .then((onValue) {
      pickupIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 1.0), 'assets/png/drop.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  getData() async {
    SharedPref pref = SharedPref();
    var userId = await pref.getUserId();
    var userName = await pref.getUsername();
    print(userId);
    print("Ride ID in confirm" + widget.ridesdata!.id.toString());
    RideMasterModel rides = await getRideMaster(id: widget.ridesdata!.id);
    var rideDetail = await getCustomTableData(
        tableName: "RideDetails", condition: "rideId=${widget.ridesdata!.id}");

    print("rideDetail is " + rideDetail.toString());
    print("rideDetail is " + rideDetail["customListTable"].toString());
    print("===============================");
    for (var json in json.decode(rideDetail["customListTable"])) {
      setState(() {
        customListdata.add(CustomListTable(
          id: json["id"],
          rideId: json["rideId"],
          startLocationLongitude: json["startLocationLongitude"].toDouble(),
          startLocationLatitude: json["startLocationLatitude"].toDouble(),
          endLocationLongitude: json["endLocationLongitude"].toDouble(),
          endLocationLatitude: json["endLocationLatitude"].toDouble(),
          startDateTime: DateTime.parse(json["startDateTime"]),
          endDateTime: json["endDateTime"],
          entryBy: json["entryBy"],
          entryDateTime: json["entryDateTime"],
          updatedDateTime: DateTime.parse(json["updatedDateTime"]),
          startLocationName: json["startLocationName"],
          endLocationName: json["endLocationName"],
          placeId: json["placeId"],
        ));
      });
      print("place id from custom ${json["placeId"]} ");
    }
    // Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // setPolylines(
    //     position.latitude,
    //     position.longitude);

    AllPackageDataModel packagedata = AllPackageDataModel();
    if (widget.ridesdata!.packageId != null) {
      packagedata = await getPackageDetailsData(
          subServiceId: 0,
          serviceId: 0,
          categoryId: 0,
          packageId: widget.ridesdata!.packageId,
          currentTime: "00:00:00");
    }
    setState(() {
      ridedata = rides;
      placeId = customListdata[0].placeId;

      // ridedetails = getRideDetailsFromJson(rideDetail.toString());
      // print('ride data is ' + customListdata[0].startLocationName.toString());
      if (widget.ridesdata!.packageId != null) {
        packageListdata = packagedata;
        placeIdIndex = packageListdata!
            .getPackagesDetails![0].packagePlaceMappingDetails!
            .indexWhere((element) => element.placeId == placeId);
      }
    });
    createMarkers();
  }

  fetchDriverData() {
    var channel = IOWebSocketChannel.connect(
        Uri.parse(
          'wss://api.yatre-e.com',
        ),
        protocols: {"graphql-ws"});
    print("message");
    channel.sink.add('{"type":"connection_init","payload":{}}');
    channel.sink.add(json.encode({
      "id": "1",
      "type": "start",
      "payload": {
        "variables": {"driverId": "${widget.ridesdata!.autoId}"},
        "extensions": {},
        "operationName": null,
        "query":
            "subscription Subscription(\$driverId: String) {\n  onCreateDriverLocation(driverId: \$driverId) {\n    driverId\n    currentTimeStamp\n    currentLatitude\n    currentLongitude\n    entryTTL\n    createdAt\n    updatedAt\n  }\n}"
      }
    }));
    channel.stream.listen((message) {
      // if (rideStatus == 2) {
      // print("message :" + message);
      var data = json.decode(message);
      if (data["type"] != "connection_ack") {
        updatePinOnMap(
            data["payload"]["data"]["onCreateDriverLocation"]
                ["currentLatitude"],
            data["payload"]["data"]["onCreateDriverLocation"]
                ["currentLongitude"]);
      }
      // }
      // channel.sink.close(status.goingAway);
    });
  }

  getRideMasterStream() {
    var channel = IOWebSocketChannel.connect(
        Uri.parse(
          'wss://api.yatre-e.com',
        ),
        protocols: {"graphql-ws"});
    print("message");
    channel.sink.add('{"type":"connection_init","payload":{}}');
    channel.sink.add(json.encode({
      "id": "2",
      "type": "start",
      "payload": {
        "variables": {"rideId": widget.ridesdata!.id, "status": 2},
        "extensions": {},
        "operationName": null,
        "query":
            "subscription Subscription(\$rideId: Int, \$status: Int) {\n  onUpdateRideMaster(rideId: \$rideId, status: \$status) {\n    id\n    bookingId\n    userId\n    rideDuration\n    rideStartDateTime\n    rideEndDateTime\n    driverId\n    status\n    entryBy\n    entryDateTime\n    updatedDateTime\n    otp\n    rideType\n  }\n}"
      }
    }));
    channel.stream.listen((message) {
      print("rideMasterData :" + message);
      var data = json.decode(message);
      if (data["type"] != "connection_ack") {
        setState(() {
          rideStatus = data["payload"]["data"]["onUpdateRideMaster"]["status"];
          if (rideStatus == 1) {
            Get.off(CompletePage(
              rideDetail: ridedata,
            ));
          }
        });
      }
      // channel.sink.close(status.goingAway);
    });
  }

  getRideMasterStreamtwo() {
    var channel = IOWebSocketChannel.connect(
        Uri.parse(
          'wss://api.yatre-e.com',
        ),
        protocols: {"graphql-ws"});
    print("message");
    channel.sink.add('{"type":"connection_init","payload":{}}');
    channel.sink.add(json.encode({
      "id": "3",
      "type": "start",
      "payload": {
        "variables": {"rideId": widget.ridesdata!.id, "status": 1},
        "extensions": {},
        "operationName": null,
        "query":
            "subscription Subscription(\$rideId: Int, \$status: Int) {\n  onUpdateRideMaster(rideId: \$rideId, status: \$status) {\n    id\n    bookingId\n    userId\n    rideDuration\n    rideStartDateTime\n    rideEndDateTime\n    driverId\n    status\n    entryBy\n    entryDateTime\n    updatedDateTime\n    otp\n    rideType\n  }\n}"
      }
    }));
    channel.stream.listen((message) {
      print("rideMasterData :" + message);
      var data = json.decode(message);
      if (data["type"] != "connection_ack") {
        setState(() {
          rideStatus = data["payload"]["data"]["onUpdateRideMaster"]["status"];
          if (rideStatus == 1) {
            Get.off(CompletePage(
              rideDetail: ridedata,
              rideDuration: data["payload"]["data"]["onUpdateRideMaster"]
                  ["rideDuration"],
              price: widget.ridesdata!.totalAmount,
            ));
          }
        });
      }
      // channel.sink.close(status.goingAway);
    }, onDone: () {
      var channel = IOWebSocketChannel.connect(
          Uri.parse(
            'wss://api.yatre-e.com',
          ),
          protocols: {"graphql-ws"});
      print("message");
      channel.sink.add('{"type":"connection_init","payload":{}}');
      channel.sink.add(json.encode({
        "id": "4",
        "type": "start",
        "payload": {
          "variables": {"rideId": widget.ridesdata!.id, "status": 1},
          "extensions": {},
          "operationName": null,
          "query":
              "subscription Subscription(\$rideId: Int, \$status: Int) {\n  onUpdateRideMaster(rideId: \$rideId, status: \$status) {\n    id\n    bookingId\n    userId\n    rideDuration\n    rideStartDateTime\n    rideEndDateTime\n    driverId\n    status\n    entryBy\n    entryDateTime\n    updatedDateTime\n    otp\n    rideType\n  }\n}"
        }
      }));
      channel.stream.listen((message) {
        print("rideMasterData :" + message);
        var data = json.decode(message);
        if (data["type"] != "connection_ack") {
          setState(() {
            rideStatus =
                data["payload"]["data"]["onUpdateRideMaster"]["status"];
            if (rideStatus == 1) {
              Get.off(CompletePage(
                rideDetail: ridedata,
                rideDuration: data["payload"]["data"]["onUpdateRideMaster"]
                    ["rideDuration"],
                price: widget.ridesdata!.totalAmount,
              ));
            }
          });
        }
        // channel.sink.close(status.goingAway);
      });
    });
  }

  getRideDetails() {
    var channel = IOWebSocketChannel.connect(
        Uri.parse(
          'wss://api.yatre-e.com',
        ),
        protocols: {"graphql-ws"});
    print("message");
    channel.sink.add('{"type":"connection_init","payload":{}}');
    channel.sink.add(json.encode({
      "id": "5",
      "type": "start",
      "payload": {
        "variables": {
          "rideId": widget.ridesdata!.id,
        },
        "extensions": {},
        "operationName": null,
        "query":
            "subscription Subscription(\$rideId: Int) {\n  onCreateUpdateRideDetails(rideId: \$rideId) {\n    id\n    rideId\n    startLocationLongitude\n    startLocationLatitude\n    endLocationLongitude\n    endLocationLatitude\n    startDateTime\n    endDateTime\n    entryBy\n    entryDateTime\n    updatedDateTime\n    startLocationName\n    endLocationName\n    placeId\n  }\n}"
      }
    }));
    channel.stream.listen((message) {
      print("rideDetailData :" + message);
      var data = json.decode(message);
      if (data["type"] != "connection_ack") {
        setState(() {
          placeId =
              data["payload"]["data"]["onCreateUpdateRideDetails"]["placeId"];
          placeIdIndex = packageListdata!
              .getPackagesDetails![0].packagePlaceMappingDetails!
              .indexWhere((element) => element.placeId == placeId);
        });
        print("=====================================");
        print("place id is $placeId");
      }
      // channel.sink.close(status.goingAway);
    }, onDone: () {
      var channel = IOWebSocketChannel.connect(
          Uri.parse(
            'wss://api.yatre-e.com',
          ),
          protocols: {"graphql-ws"});
      print("message");
      channel.sink.add('{"type":"connection_init","payload":{}}');
      channel.sink.add(json.encode({
        "id": "6",
        "type": "start",
        "payload": {
          "variables": {
            "rideId": widget.ridesdata!.id,
          },
          "extensions": {},
          "operationName": null,
          "query":
              "subscription Subscription(\$rideId: Int) {\n  onCreateUpdateRideDetails(rideId: \$rideId) {\n    id\n    rideId\n    startLocationLongitude\n    startLocationLatitude\n    endLocationLongitude\n    endLocationLatitude\n    startDateTime\n    endDateTime\n    entryBy\n    entryDateTime\n    updatedDateTime\n    startLocationName\n    endLocationName\n    placeId\n  }\n}"
        }
      }));
      channel.stream.listen((message) {
        print("rideDetailData :" + message);
        var data = json.decode(message);
        if (data["type"] != "connection_ack") {
          setState(() {
            placeId =
                data["payload"]["data"]["onCreateUpdateRideDetails"]["placeId"];
          });
        }

        // channel.sink.close(status.goingAway);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ridePageKey.currentState?.onRefresh();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
              ridePageKey.currentState?.onRefresh();
            },
          ),
        ),
        body: ridedata == null
            ? Container(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(
                              text: "Booking Id: ",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                              children: [
                            TextSpan(
                                text: "${widget.ridesdata!.bookingId}",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue))
                          ])),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 350,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(30)),
                              color: Colors.grey),
                          child: GoogleMap(
                            myLocationButtonEnabled: true,
                            zoomControlsEnabled: true,
                            markers: markers,
                            polylines: _polylines,
                            onMapCreated: (GoogleMapController mapController) {
                              _googleMapController.complete(mapController);

                              setState(() {
                                controller = mapController;
                              });
                              // my map has completed being created;
                              // i'm ready to show the pins on the map
                            },
                            initialCameraPosition: CameraPosition(
                                target: widget.ridesdata!.rideType != 2
                                    ? LatLng(
                                        packageListdata!
                                            .getPackagesDetails![0]
                                            .packagePlaceMappingDetails![0]
                                            .latitude!
                                            .toDouble(),
                                        packageListdata!
                                            .getPackagesDetails![0]
                                            .packagePlaceMappingDetails![0]
                                            .longitude!
                                            .toDouble())
                                    : LatLng(
                                        customListdata[0]
                                            .startLocationLatitude!
                                            .toDouble(),
                                        customListdata[0]
                                            .startLocationLongitude!
                                            .toDouble()),
                                zoom: 11.5),
                            // markers: markers,
                          ),
                        ),
                        rideStatus == 3
                            ? Positioned(
                                right: 0.0,
                                top: 20,
                                child: Container(
                                  height: 50,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/png/bookingBack.png"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30))),
                                  child: Center(
                                    child: Text(
                                      "Ride Not Started",
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        rideStatus == 3
                            ? Positioned(
                                left: 5.0,
                                bottom: 30,
                                child: Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${ridedata!.getRideMaster!.otp}",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            "Start OTP",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 11),
                                          )
                                        ])),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Driver Details",
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.ridesdata!.regNo}",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.blue),
                                    ),
                                    Text(
                                      "${widget.ridesdata!.driverName}",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                // Container(height: 55,width:90,child: Image.asset("assets/png/autoConfirmPage.png",fit: BoxFit.cover,))
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blue,
                                  backgroundImage: NetworkImage(
                                      "${AppStrings.imageUrl}${widget.ridesdata!.imageLocation}"),
                                )
                              ],
                            )),
                        Container(
                          height: 70,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: 50,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/contactDark.svg",
                                            height: 15,
                                          ),
                                          Text(
                                            "Contact",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 9),
                                          )
                                        ])),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Share.share(
                                        'Yatree Ride Details Driver Name :${widget.ridesdata!.driverName} Vehicle Number : ${widget.ridesdata!.regNo} Driver Contact : ${widget.ridesdata!.driverPhoneNumber} for support : https://yatreedestination.com/');
                                  },
                                  child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/shareDark.svg",
                                              height: 15,
                                            ),
                                            Text(
                                              "Share",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize: 9),
                                            )
                                          ])),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    _buildDialog();
                                  },
                                  child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/icons/cancelDark.svg",
                                              height: 15,
                                            ),
                                            Text(
                                              "Cancel",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize: 9),
                                            )
                                          ])),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Container(
                              //       height: 50,
                              //       width: 10033,
                              //       decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(10),
                              //           color: Colors.white
                              //       ),
                              //       child:Row(
                              //           mainAxisAlignment: MainAxisAlignment.center,
                              //           crossAxisAlignment: CrossAxisAlignment.center,
                              //           children:[
                              //             SvgPicture.asset("assets/icons/supportDark.svg",height: 15,)
                              //             ,Text("Support",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.black,fontSize: 9),)
                              //           ]
                              //       )
                              //
                              //
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Ride Details",
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey)),
                        ),
                        widget.ridesdata!.rideType.toString() != "1"
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 26,
                                        backgroundColor: Colors.grey,
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: Colors.white,
                                          child: SvgPicture.asset(
                                              "assets/svg/Pick Up.svg"),
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pick up",
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          // Text(
                                          //   "Pick up Location will be ask at the time of booking",
                                          //   style: GoogleFonts.poppins(fontSize: 12),
                                          // )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        widget.ridesdata!.rideType.toString() != "1"
                            ? Column(
                                children: [
                                  ListTile(
                                    leading: SvgPicture.asset(
                                        "assets/svg/Pick Up.svg"),
                                    title: Text(
                                      '${customListdata[0].startLocationName}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  ),
                                  ListTile(
                                    leading:
                                        SvgPicture.asset("assets/svg/drop.svg"),
                                    title: Text(
                                      '${customListdata[0].endLocationName}',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                children: List.generate(
                                    packageListdata!
                                        .getPackagesDetails![0]
                                        .packagePlaceMappingDetails!
                                        .length, (index) {
                                  return Column(children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 32.0),
                                        child: Container(
                                          height: 30,
                                          width: 3,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 26,
                                            backgroundColor: Colors.grey,
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.white,
                                              child: placeIdIndex < index
                                                  ? Text("L${index + 1}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))
                                                  : Icon(
                                                      Icons.done_all,
                                                      color: Colors.blueAccent,
                                                    ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${packageListdata!.getPackagesDetails![0].packagePlaceMappingDetails![index].placeName}",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "stop : ${packageListdata!.getPackagesDetails![0].packagePlaceMappingDetails![index].duration} min",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12),
                                                ),
                                                // GestureDetector(
                                                //   onTap: () {
                                                //     _buildOtpDialog();
                                                //   },
                                                //   child: Text(
                                                //     "Mark As Complete",
                                                //     style: GoogleFonts.poppins(
                                                //       fontSize: 12,
                                                //       decoration: TextDecoration.underline,
                                                //     ),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]);
                                }),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DottedLine(
                            direction: Axis.horizontal,
                            lineLength: double.infinity,
                            lineThickness: 1.0,
                            dashLength: 4.0,
                            dashColor: Colors.blue,
                            dashRadius: 0.0,
                            dashGapLength: 4.0,
                            dashGapColor: Colors.transparent,
                            dashGapRadius: 0.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 70,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  //background color of box
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0, // soften the shadow
                                    spreadRadius: .1, //extend the shadow
                                    offset: Offset(
                                      1.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: ListTile(
                                onTap: () {
                                  Get.back();
                                },
                                title: Text(
                                  "TotalFare",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  "Rs ${widget.ridesdata!.basePrice}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                trailing: Text(
                                  "view",
                                  style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _buildDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 150,
              width: 500,
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Are You Sure",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "You want to cancel this ride",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, color: Colors.blue),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await updateRideMaster(
                              id: ridedata!.getRideMaster!.id, status: 0);
                          Get.offAll(() => PerspectivePage());
                          ridePageKey.currentState?.onRefresh();
                        },
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
