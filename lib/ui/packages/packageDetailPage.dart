import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/ui/booking/bookingForm.dart';
import 'package:yatree/utils/commonFunctions.dart';
import 'package:yatree/utils/widgets/indicatorDots.dart';
// import 'package:yatree/ui/packages/mapScreen.dart';

class PackageDetailPageOld extends StatefulWidget {
  PackageDetailPageOld({Key? key, required this.getPackagesDetail})
      : super(key: key);

  GetPackagesDetail getPackagesDetail;

  @override
  _PackageDetailPageOldState createState() => _PackageDetailPageOldState();
}

class _PackageDetailPageOldState extends State<PackageDetailPageOld>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController = PageController();
  var current = 0;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildTopSection(context),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemCount:
                    widget.getPackagesDetail.packagePlaceMappingDetails!.length,
                onPageChanged: (index) {
                  setState(() {
                    current = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          "https://d19y8r79r2sdoe.cloudfront.net/public/${widget.getPackagesDetail.packagePlaceMappingDetails![index].imageLocation}",
                      imageBuilder: (context, imageProvider) => Container(
                        padding: const EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: _buildCustomerIndicator(
                              list: widget.getPackagesDetail
                                  .packagePlaceMappingDetails!),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
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
                  );
                  // current = index;
                  // return FutureBuilder<String>(
                  //     future: getDownloadUrl(
                  //         key: widget
                  //             .getPackagesDetail
                  //             .packagePlaceMappingDetails![index]
                  //             .imageLocation),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         return InkWell(
                  //           onTap: () {},
                  //           child: ClipRRect(
                  //             borderRadius: BorderRadius.circular(20.0),
                  //             child: CachedNetworkImage(
                  //               fit: BoxFit.fitWidth,
                  //               imageUrl:
                  //                   "${AppStrings.imageUrl}${widget.getPackagesDetail.packagePlaceMappingDetails![index].imageLocation}",
                  //               errorWidget: (context, url, error) {
                  //                 return Container(
                  //                   color: Colors.grey,
                  //                 );
                  //               },
                  //               placeholder: (context, url) {
                  //                 return Container(
                  //                   color: Colors.grey,
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //       return Container(
                  //         height: 140,
                  //         width: 215,
                  //         color: Colors.blue,
                  //       );
                  //     });
                },
              ),
            ),
          ),
          _buildDescriptionSection(context),
          _buildInternarySection(context)
        ],
      ),
    );
  }

  _buildTopSection(context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
          ),
          Positioned(
              left: 20,
              top: 20,
              child: Text("${widget.getPackagesDetail.packageName} Description",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14))),
        ],
      ),
    );
  }

  _buildCustomerIndicator({required List list}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(list.length, (index) {
            return Indicator(
              currentIndex: current,
              positionIndex: index,
              color: Colors.white,
            );
          })),
    );
  }

  _buildDescriptionSection(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              widget.getPackagesDetail.packageDiscountDetails!.length == 0
                  ? RichText(
                      text: TextSpan(
                          text: "Price : ",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                          TextSpan(
                            text: "Rs ${widget.getPackagesDetail.packagePrice}",
                            style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          )
                        ]))
                  : RichText(
                      text: TextSpan(
                          text: "Price : ",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                          TextSpan(
                            text: "Rs ${getPrice(widget.getPackagesDetail)}  ",
                            style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: "Rs ${widget.getPackagesDetail.packagePrice}",
                            style: GoogleFonts.poppins(
                                color: Colors.red,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.bold),
                          )
                        ])),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.to(() => BookingPage(
                        rideType: "1",
                        packagename: widget.getPackagesDetail.packageName,
                        packageid: widget.getPackagesDetail.packageId,
                        price: widget.getPackagesDetail.packageDiscountDetails!
                                    .length ==
                                0
                            ? widget.getPackagesDetail.packagePrice
                            : getPrice(widget.getPackagesDetail),
                        packagePlaceMappingDetails:
                            widget.getPackagesDetail.packagePlaceMappingDetails,
                      ));
                },
                child: Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/png/buttonColor.png"),
                          fit: BoxFit.cover),
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                      child: Text("Ride Now",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${widget.getPackagesDetail.packageDescription}",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Know before you go",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                RichText(
                    text: TextSpan(
                        text: "Duration : ",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                        text:
                            "${widget.getPackagesDetail.packageTotalDuration}",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      )
                    ])),
                RichText(
                    text: TextSpan(
                        text: "Price : ",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                        text: "${widget.getPackagesDetail.packagePrice}",
                        style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      )
                    ]))
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Itinerary",
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        )
      ],
    );
  }

  _buildInternarySection(context) {
    return Column(
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
                    child: SvgPicture.asset("assets/svg/Pick Up.svg"),
                  )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You'll Will Picked Up",
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Pick up Location will be ask at the time of booking",
                      style: GoogleFonts.poppins(fontSize: 12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Column(
          children: List.generate(
              widget.getPackagesDetail.packagePlaceMappingDetails!.length,
              (index) {
            return Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32.0),
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
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.getPackagesDetail.packagePlaceMappingDetails![index].placeName}",
                            style: GoogleFonts.poppins(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "stop : ${widget.getPackagesDetail.packagePlaceMappingDetails![index].duration} min",
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          GestureDetector(
                            onTap: () {
                              _buildBottomSheet(
                                  name: widget
                                      .getPackagesDetail
                                      .packagePlaceMappingDetails![index]
                                      .placeName,
                                  description: widget
                                      .getPackagesDetail
                                      .packagePlaceMappingDetails![index]
                                      .description,
                                  context: context);
                            },
                            child: Text(
                              "Details and View Points",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
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
          child: GestureDetector(
            onTap: () {
              // Get.to(()=>MapScreen());
            },
            child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                child: GoogleMap(
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                  onMapCreated: (controller) => _googleMapController,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                          widget.getPackagesDetail
                              .packagePlaceMappingDetails![0].latitude!
                              .toDouble(),
                          widget.getPackagesDetail
                              .packagePlaceMappingDetails![0].longitude!
                              .toDouble()),
                      zoom: 11.5),
                  markers: markers,
                )),
          ),
        )
      ],
    );
  }

  _buildBottomSheet({description, name, context}) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${name}",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${description}",
                  style: GoogleFonts.poppins(fontSize: 13),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
