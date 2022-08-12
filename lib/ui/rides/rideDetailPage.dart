import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/model/ride/ride_modle.dart';
import 'package:yatree/ui/booking/BookingConfirmPage.dart';

import '../../Screens/perspective.dart';

class RideDetail extends StatefulWidget {
  RideDetail({Key? key, this.ridesdata}) : super(key: key);

  GetUserRide? ridesdata;

  @override
  _RideDetailState createState() => _RideDetailState();
}

class _RideDetailState extends State<RideDetail> {
  @override
  void initState() {
    print(widget.ridesdata?.toJson());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ridePageKey.currentState?.onRefresh();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      "Ride Summary",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 23),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Text(
                      "${widget.ridesdata!.packageName}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "Booking ID: ",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                text: "${widget.ridesdata!.bookingId}",
                                style: GoogleFonts.poppins(
                                    color: Colors.blue,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              )
                            ])),
                        createStatusContainer(
                            widget.ridesdata!.status.toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: buildBody(),
        bottomNavigationBar: buildBottom(widget.ridesdata!.status.toString()),
      ),
    );
  }

  buildBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset("assets/icons/timeIcon.svg"),
                  ),
                  Text(
                      widget.ridesdata!.rideStartDateTime == null
                          ? ""
                          : DateFormat.yMMMMd().format(DateTime.parse(
                              widget.ridesdata!.rideStartDateTime)),
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white)),
                  Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                            widget.ridesdata!.rideStartDateTime == null
                                ? ""
                                : "${DateFormat.jm().format(DateTime.parse(widget.ridesdata!.rideStartDateTime))}",
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ))
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            "Your Ride",
            style:
                GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 23),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(),
        ),
        Column(
          children: [
            ListTile(
                leading: Text(
                  "Total Duration of Ride",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 17),
                ),
                trailing: Text(
                  "${widget.ridesdata!.rideDuration} min",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.blueAccent),
                )),
            ListTile(
                leading: Text(
                  "Ride Charges",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 17),
                ),
                trailing: Text(
                  "Rs ${widget.ridesdata!.totalAmount}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.blueAccent),
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(),
        ),
        Column(
          children: [
            ListTile(
                leading: Text(
                  "GST",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 17),
                ),
                trailing: Text(
                  "RS ${widget.ridesdata!.tax}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.blueAccent),
                )),
            // ListTile(
            //     leading: Text("Discount ",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 17),
            //
            //     ),
            //     trailing: Text("(Rs. ${widget.ridesdata!.})",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.blueAccent),)
            // ), Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Divider(),
            // ),
            ListTile(
                leading: Text(
                  "Grand Total",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                trailing: Text(
                  "RS ${widget.ridesdata!.totalAmount + widget.ridesdata!.tax}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Colors.blueAccent),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            widget.ridesdata!.status.toString() == "2"
                ? Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Driver Detail",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Colors.grey),
                        )),
                  )
                : Container(),
            widget.ridesdata!.status.toString() == "2"
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.ridesdata!.regNo}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.blue),
                            ),
                            Text(
                              "${widget.ridesdata!.driverName}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Spacer(),
                        // Container(height: 200,width:200,child: Image.asset("assets/png/Kinetic.png",fit: BoxFit.fill,))
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(
                              "${AppStrings.imageUrl}${widget.ridesdata!.imageLocation}"),
                        )
                      ],
                    ))
                : Container(),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Divider(),
            // ),
          ],
        )
      ],
    );
  }

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

  buildBottom(status) {
    if (status == "2" || status == "3") {
      return InkWell(
        onTap: () {
          print("Ride Details Data" + widget.ridesdata!.id.toString());
          Navigator.pop(context);
          Get.to(() => BookingConfirm(
                ridesdata: widget.ridesdata,
              ));
        },
        child: Container(
          height: 50,
          color: Colors.blue,
          child: Center(
              child: Text(
            "Track Ride",
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.bold),
          )),
        ),
      );
    } else {
      return null;
    }
  }
}
