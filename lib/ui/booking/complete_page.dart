import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Screens/perspective.dart';
import 'package:yatree/model/ride/ride_master_modle.dart';
import 'package:yatree/services/cutomListTable.dart';

class CompletePage extends StatefulWidget {
  CompletePage({Key? key, this.rideDetail, this.rideDuration, this.price})
      : super(key: key);

  RideMasterModel? rideDetail;
  var rideDuration, price;

  @override
  _CompletePageState createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  var data, amount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/svg/finalLogo.svg"),
            SizedBox(height: 10),
            widget.rideDetail!.getRideMaster!.rideType.toString() != "2"
                ? Text(
                    "Total Fare ₹${widget.price}",
                    style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                : Text(
                    "Total Fare ₹${int.parse(widget.rideDuration.toString()) * 4}",
                    style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Get.offAll(() => PerspectivePage());
                ridePageKey.currentState?.onRefresh();
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
                    child: Text("CONTINUE",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getData();
  }

  getData() async {
    var rideDetail = await getCustomTableData(
        tableName: "OrderMaster",
        condition: "bookingId=${widget.rideDetail!.getRideMaster!.bookingId}");
    var data = json.decode(rideDetail["customListTable"]);
    print(data[0]["id"]);

    var Detail = await getCustomTableData(
        tableName: "TransactionMaster", condition: "orderId=${data[0]["id"]}");
    var transactionData = json.decode(Detail["customListTable"]);
    setState(() {
      amount = transactionData[0]["amount"];
    });
  }
}
