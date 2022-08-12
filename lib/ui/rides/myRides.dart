import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/model/ride/rental_data.dart';
import 'package:yatree/model/ride/ride_modle.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/cutomListTable.dart';
import 'package:yatree/ui/booking/BookingConfirmPage.dart';
import 'package:yatree/ui/rides/rideDetailPage.dart';
import 'package:yatree/utils/sharedPreference.dart';

class MyRides extends StatefulWidget {
  MyRides({Key? key, this.appBar}) : super(key: key);
  bool? appBar;

  @override
  MyRidesState createState() => MyRidesState();
}

class MyRidesState extends State<MyRides> {
  List<RentalListTable>? rentalData = [];
  RideModel? ridedata;
  bool isLoading = false;

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
    setState(() {
      ridedata = rides;
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
        appBar: widget.appBar != null
            ? null
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
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(30),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/icons/rideIcon.svg"),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "MY RIDES",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        body: buildRideBody(),
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
        child: ListView.builder(
            itemCount: ridedata!.getUserRides!.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        RideDetail(ridesdata: ridedata!.getUserRides![index]));
                  },
                  child: Card(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Text(
                                  ridedata!.getUserRides![index].rideType
                                              .toString() ==
                                          "2"
                                      ? "Pick and Drop"
                                      : "${ridedata!.getUserRides![index].packageName.toString()}",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "Booking id : ",
                                      style: GoogleFonts.poppins(fontSize: 13),
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
                                trailing: Text(
                                  "Rs ${ridedata!.getUserRides![index].totalAmount}.00",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.blue),
                                ),
                                leading: CachedNetworkImage(
                                  imageUrl:
                                      "${AppStrings.imageUrl}${ridedata!.getUserRides![index].imageLocation}",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.blue,
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20),
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
                                      borderRadius: BorderRadius.circular(20),
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
                          createStatusContainer(
                              ridedata!.getUserRides![index].status.toString()),
                          ridedata!.getUserRides![index].rideType.toString() !=
                                  "2"
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total Duration of Ride",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        Text(
                                          "${ridedata!.getUserRides![index].rideDuration} min",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.blue),
                                        ),
                                      ]),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                          "assets/icons/timeIcon.svg"),
                                    ),
                                    Text(
                                        ridedata!.getUserRides![index]
                                                    .rideStartDateTime ==
                                                null
                                            ? ""
                                            : DateFormat.yMMMMd().format(
                                                DateTime.parse(ridedata!
                                                    .getUserRides![index]
                                                    .rideStartDateTime)),
                                        style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white)),
                                    Container(
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF36A4FE),
                                                Color(0xFF3BFF84),
                                              ],
                                              begin: FractionalOffset(0.0, 0.0),
                                              end: FractionalOffset(1.0, 0.0),
                                              stops: [0.0, 1.0],
                                              tileMode: TileMode.clamp),
                                        ),
                                        child: Center(
                                          child: Text(
                                              ridedata!.getUserRides![index]
                                                          .rideStartDateTime ==
                                                      null
                                                  ? ""
                                                  : "${DateFormat.jm().format(DateTime.parse(ridedata!.getUserRides![index].rideStartDateTime))}",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                        ))
                                  ],
                                )),
                          ),
                        ]),
                  ),
                ),
              );
            }),
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

  //ride
//3 upcomming
//2 ongoing
//1 completed
//0 canceled

  createStatusContainer(var status) {
    if (status == "0") {
      return Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 16,
          bottom: 10,
        ),
        child: Container(
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
        ),
      );
    } else if (status == "1") {
      return Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 16,
          bottom: 10,
        ),
        child: Container(
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
        ),
      );
    } else if (status == "2") {
      return Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 16,
          bottom: 10,
        ),
        child: Container(
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
        ),
      );
    } else if (status == "3") {
      return Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 16,
          bottom: 10,
        ),
        child: Container(
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
        ),
      );
    }
  }
}
