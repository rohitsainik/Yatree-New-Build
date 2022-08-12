import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/ui/booking/bookingForm.dart';
import 'package:yatree/utils/commonFunctions.dart';

class PackageDetailPage extends StatefulWidget {
  PackageDetailPage({Key? key, required this.getPackagesDetail})
      : super(key: key);

  GetPackagesDetail getPackagesDetail;

  @override
  _PackageDetailPageState createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  openImageDialog(String url) {
    showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.6),
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: EdgeInsets.all(10),
            elevation: 5,
            backgroundColor: Colors.transparent,
            child: Material(
                elevation: 50,
                child: Image.network(
                  url,
                  fit: BoxFit.fitWidth,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                )),
          );
        });
  }

  GoogleMapController? _googleMapController;
  Set<Marker> markers = Set();

  @override
  void initState() {
    createMarkers();
  }

  createMarkers() {
    for (var i = 0;
        i < widget.getPackagesDetail.packagePlaceMappingDetails!.length;
        i++) {
      var marker = Marker(
        markerId: MarkerId(widget
            .getPackagesDetail.packagePlaceMappingDetails![i].placeId
            .toString()),
        position: LatLng(
            widget.getPackagesDetail.packagePlaceMappingDetails![i].latitude!
                .toDouble(),
            widget.getPackagesDetail.packagePlaceMappingDetails![i].longitude!
                .toDouble()),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
        infoWindow: InfoWindow(
          title:
              "${widget.getPackagesDetail.packagePlaceMappingDetails![i].placeName}",
        ),
      );
      markers.add(marker);
    }
  }

  @override
  void dispose() {
    _googleMapController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Color(0xffBBE7FF),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.8,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl:
                        "https://d19y8r79r2sdoe.cloudfront.net/public/${widget.getPackagesDetail.packagePlaceMappingDetails![0].imageLocation}",
                    imageBuilder: (context, imageProvider) => BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: new BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                          child: new Container(
                            decoration: new BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SafeArea(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.1),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Text(
                                        "${widget.getPackagesDetail.packageName}",
                                        style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 24)),
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.symmetric(horizontal: 20.0),
                                  //   child: Text("5 km from current location",
                                  //       style: GoogleFonts.roboto(
                                  //           color: Colors.white,
                                  //           fontWeight: FontWeight.w400,
                                  //           fontSize: 12)),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return Container(
                        color: Colors.grey,
                      );
                    },
                    placeholder: (context, url) {
                      return Container(
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.width * 0.5,
              ),
              Container(
                height: MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.width * 0.75),
                width: MediaQuery.of(context).size.width - 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 1),
                    ]),
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Text(
                          "About",
                          style: GoogleFonts.roboto(
                            color: Color(0xff0d4b81),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (int i = 0;
                          i <
                              widget.getPackagesDetail
                                  .packagePlaceMappingDetails!.length;
                          i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5.0),
                          child: Text(
                            "${widget.getPackagesDetail.packagePlaceMappingDetails![i].placeName} - ${widget.getPackagesDetail.packagePlaceMappingDetails![i].description}",
                            style: GoogleFonts.roboto(
                                color: Color(0xff042b4e), fontSize: 13),
                          ),
                        ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Photos",
                          style: GoogleFonts.roboto(
                            color: Color(0xff0d4b81),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 66,
                          child: ListView.builder(
                              itemCount: widget.getPackagesDetail
                                  .packagePlaceMappingDetails!.length,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, top: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          openImageDialog(
                                              "https://d19y8r79r2sdoe.cloudfront.net/public/${widget.getPackagesDetail.packagePlaceMappingDetails![index].imageLocation}");
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  "https://d19y8r79r2sdoe.cloudfront.net/public/${widget.getPackagesDetail.packagePlaceMappingDetails![index].imageLocation}",
                                                ),
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Itinerary",
                          style: GoogleFonts.roboto(
                            color: Color(0xff0d4b81),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
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
                                          "You'll Will Picked Up",
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Pick up Location will be ask at the time of booking",
                                          style:
                                              GoogleFonts.poppins(fontSize: 12),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: List.generate(
                                  widget
                                      .getPackagesDetail
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
                                            child: Text("L${index + 1}",
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.w500)),
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
                                                "${widget.getPackagesDetail.packagePlaceMappingDetails![index].placeName}",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "stop : ${widget.getPackagesDetail.packagePlaceMappingDetails![index].duration} min",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              }),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              child: GoogleMap(
                                myLocationButtonEnabled: true,
                                zoomControlsEnabled: true,
                                onMapCreated: (controller) =>
                                    _googleMapController,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        widget
                                            .getPackagesDetail
                                            .packagePlaceMappingDetails![0]
                                            .latitude!
                                            .toDouble(),
                                        widget
                                            .getPackagesDetail
                                            .packagePlaceMappingDetails![0]
                                            .longitude!
                                            .toDouble()),
                                    zoom: 11.5),
                                markers: markers,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.width * 0.25,
                width: MediaQuery.of(context).size.width - 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "₹ ${widget.getPackagesDetail.packagePrice}",
                            style: GoogleFonts.poppins(
                                color: Color(0xffFA871C),
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "for ${widget.getPackagesDetail.packagePlaceMappingDetails!.length} locations",
                            style: GoogleFonts.poppins(
                                color: Color(0xff0D4B81),
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => BookingPage(
                                rideType: "1",
                                packagename:
                                    widget.getPackagesDetail.packageName,
                                packageid: widget.getPackagesDetail.packageId,
                                price: widget.getPackagesDetail
                                            .packageDiscountDetails!.length ==
                                        0
                                    ? widget.getPackagesDetail.packagePrice
                                    : getPrice(widget.getPackagesDetail),
                                packagePlaceMappingDetails: widget
                                    .getPackagesDetail
                                    .packagePlaceMappingDetails,
                              ));
                        },
                        child: Container(
                          height: 50,
                          width: 150,
                          decoration: BoxDecoration(
                            //color: Colors.black,
                            gradient: LinearGradient(
                                colors: [
                                  const Color(0xff0C6EC4),
                                  const Color(0xFF0C5BA1),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(0.0, 1.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                            boxShadow: [
                              BoxShadow(offset: Offset(0, 3), spreadRadius: 0)
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Book Now",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
