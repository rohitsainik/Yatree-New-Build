import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/model/offers/offers.dart';
import 'package:yatree/model/ride/rental_data.dart';
import 'package:yatree/model/ride/ride_modle.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/cutomListTable.dart';
import 'package:yatree/ui/booking/BookingConfirmPage.dart';
import 'package:yatree/ui/offers/offersPage.dart';
import 'package:yatree/ui/rides/rideDetailPage.dart';
import 'package:yatree/utils/sharedPreference.dart';

import '../../utils/widgets/gradient.dart';

class MyRides extends StatefulWidget {
  MyRides({Key? key, this.appBar}) : super(key: key);
  bool? appBar;

  @override
  MyRidesState createState() => MyRidesState();
}

enum RideStatus { UPCOMING, LIVE, COMPLETED }

class MyRidesState extends State<MyRides> {
  List<RentalListTable>? rentalData = [];
  RideModel? ridedata = RideModel();
  List<GetUserRide>? upcoming, live, completed;
  bool isLoading = false;
  RideStatus rideStatus = RideStatus.UPCOMING;
  OfferDataModel? offerData;

  getData() async {
    setState(() {
      isLoading = true;
    });
    SharedPref pref = SharedPref();
    var userId = await pref.getUserId();
    var userName = await pref.getUsername();
    print(userId);
    RideModel rides = await getUserRide(customerId: "${userId}");
    var rideDetail = await getCustomTableData(
        tableName: "EvRentalQueryMaster",
        condition: "entryBy='$userId' ORDER BY entryDateTime DESC");

    if (rideDetail["customListTable"] != null) {
      for (var json in json.decode(rideDetail["customListTable"])) {
        setState(() {
          rentalData?.add(RentalListTable(
            id: json["id"],
            name: json["name"],
            phoneNo: json["phoneNo"],
            email: json["email"],
            noOfAutos: json["noOfAutos"],
            locationName: json["locationName"],
            pickupDate: json["pickupDate"],
            pickupTime: json["pickupTime"],
            entryBy: json["entryBy"],
            entryDateTime: json["entryDateTime"],
            status: json["status"],
            updatedDateTime: DateTime.parse(json["updatedDateTime"]),
          ));
        });
      }
    }
    OfferDataModel offer = await getOfferMasterData();
    setState(() {
      ridedata = rides;
      offerData = offer;
      upcoming =
          rides.getUserRides!.where((value) => (value.status == 3)).toList();
      live = rides.getUserRides!.where((value) => (value.status == 2)).toList();
      completed =
          rides.getUserRides!.where((value) => (value.status == 1)).toList();
      ridedata?.getUserRides = upcoming;
      isLoading = false;
    });
  }

  Future<Null> onRefresh() async {
    setState(() {
      ridedata = RideModel();
      rentalData?.clear();
    });
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (rentalData?.isEmpty == true) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              width: 50,
              child: Center(child: SvgPicture.asset('assets/svg/rides.svg')),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, gradient: buildRadialGradient()),
            ),
          ),
          elevation: 0.0,
          toolbarHeight: 70,
          title: Text(
            "MY RIDES",
            style: GoogleFonts.raleway(fontWeight: FontWeight.w500),
          ),
          centerTitle: false,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
          ),
        ),
        body: (ridedata?.getUserRides?.isEmpty == true &&
                rentalData?.isEmpty == true)
            ? buildEmptyBody()
            : buildRideBody(),
      );
    } else {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: widget.appBar != null
              ? AppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(5),
                    child: TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      tabs: [Tab(text: "MY RIDES"), Tab(text: "MY RENTALS")],
                    ),
                  ),
                )
              : AppBar(
                  elevation: 0.0,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  backgroundColor: Colors.white,
                  // bottom: PreferredSize(preferredSize: Size.fromHeight(30),
                  // child: Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     children: [
                  //       SvgPicture.asset("assets/icons/rideIcon.svg"),
                  //       SizedBox(width: 10,),
                  //       Text("MY RIDES",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 23),),
                  //     ],
                  //   ),
                  // ),),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50),
                    child: TabBar(
                      indicatorColor: Colors.blue,
                      labelColor: Colors.blue,
                      tabs: [Tab(text: "MY RIDES"), Tab(text: "MY RENTALS")],
                    ),
                  ),
                ),
          body: TabBarView(
            children: [
              RefreshIndicator(onRefresh: onRefresh, child: buildRideBody()),
              RefreshIndicator(onRefresh: onRefresh, child: buildRentalBody()),
            ],
          ),
        ),
      );
    }
  }

  Widget buildRideBody() {
    if (ridedata == null || isLoading == true)
      return RefreshIndicator(
          onRefresh: onRefresh,
          child: Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ));
    else
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: Column(
          children: [
            StaggeredGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      getRidesByStatus(RideStatus.UPCOMING);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: rideStatus == RideStatus.UPCOMING
                              ? Colors.blue
                              : Colors.white, //background color of box
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2.0, // soften the shadow
                              spreadRadius: .1, //extend the shadow
                              offset: Offset(
                                0.5, // Move to right 10  horizontally
                                0.5, // Move to bottom 10 Vertically
                              ),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Upcoming",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: rideStatus == RideStatus.UPCOMING
                                  ? Colors.white
                                  : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      getRidesByStatus(RideStatus.LIVE);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: rideStatus == RideStatus.LIVE
                              ? Colors.blue
                              : Colors.white, //background color of box
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2.0, // soften the shadow
                              spreadRadius: .1, //extend the shadow
                              offset: Offset(
                                0.5, // Move to right 10  horizontally
                                0.5, // Move to bottom 10 Vertically
                              ),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Live",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: rideStatus == RideStatus.LIVE
                                  ? Colors.white
                                  : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      getRidesByStatus(RideStatus.COMPLETED);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: rideStatus == RideStatus.COMPLETED
                              ? Colors.blue
                              : Colors.white, //background color of box
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 2.0, // soften the shadow
                              spreadRadius: .1, //extend the shadow
                              offset: Offset(
                                0.5, // Move to right 10  horizontally
                                0.5, // Move to bottom 10 Vertically
                              ),
                            )
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Completed",
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: rideStatus == RideStatus.COMPLETED
                                  ? Colors.white
                                  : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: ridedata!.getUserRides!.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => RideDetail(
                              ridesdata: ridedata!.getUserRides![index]));
                        },
                        child: Card(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      visualDensity: VisualDensity(vertical: 4),
                                      // dense: true,
                                      title: Text(
                                        "${ridedata!.getUserRides![index].packageName.toString()}",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Rs ${ridedata!.getUserRides![index].totalAmount}.00",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.blue),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Booking id : ",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13),
                                              ),
                                              Text(
                                                "${ridedata!.getUserRides![index].bookingId}",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Container(
                                        width: 100,
                                        height: 150,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            createStatusContainer(ridedata!
                                                .getUserRides![index].status
                                                .toString()),
                                            SvgPicture.asset(
                                              'assets/svg/ride_card_cart.svg',
                                              fit: BoxFit.contain,
                                              height: 40,
                                            ),
                                          ],
                                        ),
                                      ),

                                      leading: CachedNetworkImage(
                                        imageUrl:
                                            "${AppStrings.imageUrl}${ridedata!.getUserRides![index].imageLocation}",
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.blue,
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://images.pexels.com/photos/40465/pexels-photo-40465.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260"),
                                                fit: BoxFit.cover),
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    )
                                    // Row(
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
                                    //     Container(
                                    //       height: 60,
                                    //       width: 60,
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.grey,
                                    //         borderRadius: BorderRadius.circular(20),
                                    //       ),
                                    //     ),
                                    //     Column(mainAxisAlignment: MainAxisAlignment.start,
                                    //         children: [
                                    //       Row(
                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Text(
                                    //             "WonderLand",
                                    //             style: GoogleFonts.poppins(
                                    //                 fontWeight: FontWeight.bold, fontSize: 13),
                                    //           ),
                                    //           Text(
                                    //             "Rs 399.0",
                                    //             style: GoogleFonts.poppins(
                                    //                 fontWeight: FontWeight.bold,
                                    //                 fontSize: 14,
                                    //                 color: Colors.red),
                                    //           ),
                                    //         ],
                                    //       )
                                    //     ])
                                    //   ],
                                    // ),3
                                    ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.greenAccent,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                  ridedata!.getUserRides![index]
                                                              .rideStartDateTime ==
                                                          null
                                                      ? ""
                                                      : DateFormat("dd-MM-yyyy")
                                                          .format(DateTime
                                                              .parse(ridedata!
                                                                  .getUserRides![
                                                                      index]
                                                                  .rideStartDateTime)),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ),
                                          )),
                                      Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.greenAccent,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                  ridedata!.getUserRides![index]
                                                              .rideStartDateTime ==
                                                          null
                                                      ? ""
                                                      : "${DateFormat.jm().format(DateTime.parse(ridedata!.getUserRides![index].rideStartDateTime))}",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white)),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      );
  }

  Widget buildRentalBody() {
    if (isLoading == true)
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    else if (rentalData?.isEmpty == true)
      return Container();
    else
      return ListView.builder(
          itemCount: rentalData?.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Booking Id : ",
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                Text(
                                  "${rentalData?[index].id}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ],
                            ),
                            createStatusContainer(
                                rentalData?[index].status.toString()),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rentalData?[index].name ?? "",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              "Email : ${rentalData?[index].email}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 10),
                            ),
                            Text(
                              "Phone no : ${rentalData?[index].phoneNo}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500, fontSize: 10),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location : ",
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                            Flexible(
                                child: Text(
                              "${rentalData?[index].locationName}",
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Auto Required",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                rentalData?[index].noOfAutos.toString() ?? "",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pick Up Date",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                "${DateFormat('yyyy-MM-dd').format(DateTime.parse(rentalData?[index].pickupDate ?? ""))}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pick Time",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text(
                                "${rentalData?[index].pickupTime}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue),
                              ),
                            ]),
                      ),
                    ]),
              ),
            );
          });
  }

  Widget buildEmptyBody() {
    return Container(
      width: Get.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/png/rides.png"),
            Text(
              "You have no upcoming rides!",
              style: GoogleFonts.raleway(
                  fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              "Here are some amazing offers to kickstart your ride",
              style: GoogleFonts.raleway(
                  fontSize: 10, fontWeight: FontWeight.w500),
            ),
            ListTile(
              leading: SvgPicture.asset("assets/svg/offer.svg"),
              title: Text(
                "Offer For You",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: InkWell(
                onTap: () {
                  Get.to(() => OffersPage());
                },
                child: Text(
                  "View All >",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            _buildOfferList(context)
          ],
        ),
      ),
    );
  }

  _buildOfferList(BuildContext context) {
    return Container(
        height: 187,

        width:Get.width,
        child: CarouselSlider.builder(
          itemCount: offerData?.listOfferMasters!.length,
          itemBuilder: (context, index, pageViewIndex) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: Get.width -100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              imageUrl:
                              "${AppStrings.imageUrl}${offerData?.listOfferMasters![index].image}",
                              imageBuilder: (context, imageProvider) => Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.fill),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                      color: Colors.grey.shade400,
                                    ),
                                  ],
                                  // color: Colors.white,
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: 140,
                                width: MediaQuery.of(context).size.width - 20,
                                color: Colors.blue,
                              ),
                              errorWidget: (context, url, error) => Container(
                                  height: 140,
                                  width: MediaQuery.of(context).size.width - 20,
                                  color: Colors.blue,
                                  child: Center(
                                    child: Icon(Icons.error),
                                  )),
                            ),
                          ),
                          Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "${offerData?.listOfferMasters![index].name}",
                                    style: GoogleFonts.raleway(fontSize: 10),
                                  ),
                                  Text(
                                    "${offerData?.listOfferMasters![index].description}",
                                    style: GoogleFonts.raleway(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month),
                                      SizedBox(width: 10,),
                                      Text(
                                        "${offerData?.listOfferMasters![index].validUpto}",
                                        style: GoogleFonts.raleway(
                                          fontSize: 10,),
                                      ),
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                    DottedLine(
                      lineThickness: 1.0,
                      dashLength: 10.0,
                      dashGapLength: 10.0,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: offerData?.listOfferMasters![index].name)).then((_){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("copied to clipboard")));
                            });
                          },
                          child: Text(
                              "Copy & Book: ${offerData?.listOfferMasters![index].couponCode}")),
                    )
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            viewportFraction: 0.7,
            // aspectRatio: 2.0,
            // initialPage: 2,
          ),
        ));
  }

  //ride
//3 upcomming
//2 ongoing
//1 completed
//0 canceled

  createStatusContainer(var status) {
    if (status == "0") {
      return Container(
        child: Center(
            child: Text(
          "CANCELLED",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 9, color: Colors.red),
        )),
        height: 23,
        width: 88,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.red),
            color: Colors.white),
      );
    } else if (status == "1") {
      return Container(
        child: Center(
            child: Text(
          "COMPLETED",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 9, color: Colors.green),
        )),
        height: 23,
        width: 88,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green),
            color: Colors.white),
      );
    } else if (status == "2") {
      return Container(
        child: Center(
            child: Text(
          "ONGOING",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 9, color: Colors.amber),
        )),
        height: 23,
        width: 88,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber),
            color: Colors.white),
      );
    } else if (status == "3") {
      return Container(
        child: Center(
            child: Text(
          "UPCOMING",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 9, color: Colors.blue),
        )),
        height: 23,
        width: 88,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
            color: Colors.white),
      );
    }
  }

  void getRidesByStatus(RideStatus status) {
    switch (status) {
      case RideStatus.UPCOMING:
        setState(() {
          rideStatus = status;
          ridedata?.getUserRides = upcoming;
        });
        break;
      case RideStatus.LIVE:
        setState(() {
          rideStatus = status;
          ridedata?.getUserRides = live;
        });
        break;
      case RideStatus.COMPLETED:
        setState(() {
          rideStatus = status;
          ridedata?.getUserRides = completed;
        });
        break;
    }
  }
}
