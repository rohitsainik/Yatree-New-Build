import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yatree/services/placesService.dart';
import 'package:yatree/ui/booking/bookingForm.dart';
import 'package:yatree/ui/packages/mapScreen.dart';
import 'package:yatree/ui/pick%20and%20drop/searchpage.dart';
import 'package:yatree/utils/commonFunctions.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class PickAndDrop extends StatefulWidget {
   PickAndDrop({Key? key,this.appBar}) : super(key: key);

   bool? appBar;

  @override
  _PickAndDropState createState() => _PickAndDropState();
}

class _PickAndDropState extends State<PickAndDrop> {
  TextEditingController _Pickcontroller = TextEditingController();
  TextEditingController _Dropcontroller = TextEditingController();
  Completer<GoogleMapController> _googleMapController = Completer();
  Position? currentLocation;
  var startPosition,endPosition;
  String _address = ""; // create this variable
  late BitmapDescriptor sourceIcon,destinationIcon;
  late GoogleMapController controller;


  //polylines

  Set<Polyline> _polylines = Set<Polyline>();
  List<PolylineWayPoint> wayPoint = [];
  PolylinePoints polylinePoints = PolylinePoints();


  _getstartPlace(lat,long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    // this is all you need
    Placemark placeMark  = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? address = "${name}, ${subLocality}, ${locality}, ${administrativeArea}";

    print(address);

    setState(() {
      _address = address;
      _Pickcontroller.text = _address;
      // update _address
    });
  }

  _getEndPlace(lat,long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    // this is all you need
    Placemark placeMark  = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? address = "${name}, ${subLocality}, ${locality}, ${administrativeArea}";

    print(address);

    setState(() {
      _address = address;
      _Dropcontroller.text = _address;
      // update _address
    });
  }

  @override
  void initState() {
    getData();
    setLocationMarkerIcons();
    super.initState();
    // setSourceAndDestinationIcons();
  }

  getData() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    await  _getstartPlace(position.latitude,position.longitude);
    // await  _getEndPlace(position.latitude,position.longitude);
    setState(() {
      currentLocation = position;
      startPosition = LatLng(position.latitude,position.longitude);
      // endPosition = LatLng(position.latitude,position.longitude);
    });
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/svg/Pick Up.svg');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/svg/drop.svg');
  }

  void onError(PlacesAutocompleteResponse? response) {
    showToast(message:response!.errorMessage.toString());
    // homeScaffoldKey.currentState!.showSnackBar(
    //   SnackBar(content: Text(response!.errorMessage.toString())),
    // );
  }

  Future<void> _handlePressButton({var location}) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected


    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: Mode.overlay,
        radius: 20000,
        types: [],
        // location: Location!,
        strictbounds: false,
        region: "in",
        decoration: InputDecoration(
          hintText: 'Search',
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(
          //     color: Colors.white,
          //   ),
          // ),
        ),
        components: [Component(Component.country, "in")] );
    print("data is " + p!.description.toString());
    displayPrediction(p, homeScaffoldKey.currentState,location);
    FocusScope.of(context).unfocus();
  }


  Future<Null> displayPrediction(Prediction? p, ScaffoldState? scaffold,var location) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId.toString());
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      if(location == "start"){
        setState(() {
          _Pickcontroller.text = p.description!;
          startPosition = LatLng(lat,lng);
          setPolylines();
        });
      }else{
        setState(() {
          _Dropcontroller.text = p.description!;
          endPosition = LatLng(lat,lng);
          setPolylines();

        });

      }

      await updateCameraLocation(startPosition, endPosition, controller);
      //
      // setState(() {
      //
      // });

      // scaffold!.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }

  }


  void setPolylines() async {
    List<LatLng> polylineCoordinates = [];

    // Position position = await Geolocator.getCurrentPosition();

    PolylineResult result = await getPolylineResult(lat:startPosition.latitude, lng:startPosition.longitude,
        dlat: endPosition.latitude ,
        dlng: endPosition.longitude,
        polylinePoints: polylinePoints);

    if (result.points.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar == null ? null : AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration:const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                color: Colors.grey
            ),
            child: GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              polylines: _polylines,
              markers:
              endPosition != null ? {Marker(
                onTap: () {
                  print('destination');
                },
                markerId: MarkerId("2"),
                draggable: true,
                position: endPosition as LatLng,
                onDragEnd: ((newPosition) async {
                  setState(() {
                    endPosition = newPosition;
                  });

                  setPolylines();
                  await updateCameraLocation(
                      startPosition!, endPosition!, controller);
                  print(newPosition.latitude);
                  print(newPosition.longitude);
                  await _getEndPlace(
                      newPosition.latitude, newPosition.longitude);
                }),
                icon: destinationIcon,
                infoWindow: const InfoWindow(
                  title: 'End Location',
                ),
              ), Marker(
                onTap: () {
                  print('Tapped');
                },
                markerId: MarkerId("1"),
                draggable: true,
                position: startPosition as LatLng,
                onDragEnd: ((newPosition) async {
                  print(newPosition.latitude);
                  print(newPosition.longitude);
                  setState(() {
                    startPosition = newPosition;
                  });
                  setPolylines();
                  await _getstartPlace(
                      newPosition.latitude, newPosition.longitude);
                }),
                icon: sourceIcon,
                infoWindow: const InfoWindow(
                  title: 'Start Location',
                ),
              ),} : {
                Marker(
                  onTap: () {
                    print('Tapped');
                  },
                  markerId: MarkerId("1"),
                  draggable: true,
                  position: startPosition as LatLng,
                  onDragEnd: ((newPosition) async {
                    print(newPosition.latitude);
                    print(newPosition.longitude);
                    setState(() {
                      startPosition = newPosition;
                    });
                    setPolylines();
                    await _getstartPlace(
                        newPosition.latitude, newPosition.longitude);
                  }),
                  icon: sourceIcon,
                  infoWindow: const InfoWindow(
                    title: 'Start Location',
                  ),
                ),
              },

              onMapCreated:(GoogleMapController mapController) async{
                _googleMapController.complete(mapController);

                setState(() {
                  controller = mapController;
                });
                await updateCameraLocation(startPosition, endPosition, controller);
                // my map has completed being created;
                // i'm ready to show the pins on the map
              },

              initialCameraPosition: CameraPosition(
                target: LatLng(currentLocation!.latitude,currentLocation!.longitude),
                zoom: 14.4746,
              ),
              // markers: markers,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset("assets/svg/Pick Up.svg"),
                      title: TextFormField(
                        maxLines: 2,
                        controller: _Pickcontroller,
                        onTap: (){_handlePressButton(location: "start");
                        FocusScope.of(context).unfocus();},
                        style:GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 0.0),
                          border: InputBorder.none,

                          hintText: "Pick Up Address",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: SvgPicture.asset("assets/svg/drop.svg"),
                      title: TextFormField(
                        maxLines: 2,
                        controller: _Dropcontroller,
                        onTap: (){_handlePressButton(location: "end");
                        FocusScope.of(context).unfocus();},
                        style:GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding: new EdgeInsets.symmetric(vertical: 0.0),
                          border: InputBorder.none,
                          hintText: "Drop Address",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold),),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if(_Dropcontroller.text.isNotEmpty){
                          Get.to(() => BookingPage(
                            rideType: "2",
                            startposition: startPosition,
                            endposition: endPosition,
                            startLocation: _Pickcontroller.text,
                            endLocation: _Dropcontroller.text,
                            price: 0,
                            packageid: 0,
                          ));
                        }else{
                          showToast(message: "Please select Drop Location");
                        }

                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                            image:const DecorationImage(
                                image: AssetImage(
                                    "assets/png/buttonColor.png"),
                                fit: BoxFit.cover),
                            border:
                            Border.all(color: Colors.blue),
                            borderRadius:
                            BorderRadius.circular(25)),
                        child: Center(
                            child: Text("Ride Now",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ),
                    ),
                    const  SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),


        ],
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () async{
          await getData();
          setPolylines();
          await updateCameraLocation(startPosition, endPosition, controller);
        },
        backgroundColor: Colors.white,
      child: Icon(Icons.my_location,color: Colors.blue,),),
    );
  }


  void setLocationMarkerIcons() async {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.0), 'assets/png/pickUp.png')
        .then((onValue) {
      sourceIcon = onValue;
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1.0), 'assets/png/drop.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }


  void _currentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState((){
      currentLocation = position;
      startPosition = LatLng(position.latitude, position.longitude);
    });
  }
}
