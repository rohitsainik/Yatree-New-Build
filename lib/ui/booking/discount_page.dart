import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/model/discountList.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/utils/validation.dart';

class DiscountPage extends StatefulWidget {
  DiscountPage(
      {Key? key,
      this.bookingDate,
      this.locationLatitude,
      this.packageId,
      this.locationLongitude,
      this.serviceId,
      this.subServiceId})
      : super(key: key);
  var serviceId,
      subServiceId,
      packageId,
      locationLatitude,
      locationLongitude,
      bookingDate;

  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  TextEditingController discount = TextEditingController();
  var couponIndex = -1;

  Discount? discountList;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    Discount data = await getDiscountData(
        serviceId: widget.serviceId,
        subServiceId: widget.subServiceId,
        packageId: widget.packageId,
        locationLatitude: widget.locationLatitude,
        locationLongitude: widget.locationLatitude,
        bookingDate: widget.bookingDate);
    setState(() {
      discountList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.clear,
              color: Colors.blue,
            )),
      ),
      body: discountList == null
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: TextFormField(
                            validator: validateName,
                            controller: discount,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: 'Enter Coupon',
                              hintStyle: GoogleFonts.poppins(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(16),
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          if (couponIndex > -1) {
                            Get.back(
                                result: discountList!
                                    .getDiscountData![couponIndex]);
                          }
                        },
                        child: Text(
                          "Apply",
                          style: GoogleFonts.poppins(
                              color:
                                  couponIndex <= -1 ? Colors.grey : Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: discountList!.getDiscountData!.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          return discountList!
                                      .getDiscountData![index].couponCode !=
                                  ""
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      discount.text = discountList!
                                          .getDiscountData![index].couponCode
                                          .toString();
                                      couponIndex = index;
                                    });
                                    if (couponIndex > -1) {
                                      Get.back(
                                          result: discountList!
                                              .getDiscountData![couponIndex]);
                                    }
                                  },
                                  child: Card(
                                      child: ListTile(
                                    title: Text(
                                      discountList!
                                          .getDiscountData![index].couponCode
                                          .toString(),
                                      style: GoogleFonts.roboto(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: discountList!
                                                .getDiscountData![index]
                                                .amountType
                                                .toString() ==
                                            "1"
                                        ? Text(
                                            "Flat Rs ${discountList!.getDiscountData![index].amount.toString()} OFF",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : Text(
                                            "${discountList!.getDiscountData![index].amount.toString()} % OFF",
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                    trailing: Text(
                                      "T&C Apply*",
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )),
                                )
                              : Container();
                        }))
              ],
            ),
    );
  }
}
