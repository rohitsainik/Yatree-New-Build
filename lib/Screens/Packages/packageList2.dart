import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/model/asStrip.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/model/package/subservice.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/cutomListTable.dart';
import 'package:yatree/utils/widgets/indicatorDots.dart';

class PackageList2 extends StatefulWidget {
  PackageList2({Key? key, this.serviceId, this.categoryId}) : super(key: key);

  var serviceId, categoryId;

  @override
  _PackageList2State createState() => _PackageList2State();
}

class _PackageList2State extends State<PackageList2> {
  PageController _pageController = PageController();
  var current = 0;
  var suvServiceId;
  SubserviceDataModel? subservicedata;
  AdStrip? adstripDataModel;

  AllPackageDataModel? packageListdata;

  List<bool> checkedValue = [];

  @override
  void initState() {
    getData();
  }

  getData() async {
    print(
      " getCustomTableData servie id" + widget.serviceId.toString(),
    );
    var subservice = await getCustomTableData(
        tableName: "SubServiceMaster",
        condition: "serviceId=${widget.serviceId} and isActive=1");
    setState(() {
      subservicedata = SubserviceDataModel.fromJson(subservice);
      suvServiceId = subservicedata!.customListTable!.length == 0
          ? 0
          : subservicedata!.customListTable![0].id!;
    });

    print("subservice" + subservice.toString());
    print("sub servie id" + suvServiceId.toString());
    print(
      "servie id" + widget.serviceId.toString(),
    );

    AdStrip adstripdata = await AdStripList();
    AllPackageDataModel packagedata = await getPackageDetailsData(
        subServiceId: suvServiceId == null ? 0 : suvServiceId,
        serviceId: widget.serviceId,
        packageId: 0,
        categoryId: 0,
        currentTime: "00:00:00");
    // currentTime: DateFormat('HH:mm:ss').format(DateTime.now()));
    setState(() {
      adstripDataModel = adstripdata;
      packageListdata = packagedata;
      for (int i = 0; i < packageListdata!.getPackagesDetails!.length; i++) {
        checkedValue.add(false);
      }
    });
  }

  getServiceData() async {
    print("sub servie id" + suvServiceId.toString());
    print(
      "servie id" + widget.serviceId.toString(),
    );
    print("00:00:00");
    AllPackageDataModel packagedata = await getPackageDetailsData(
        subServiceId: suvServiceId,
        serviceId: widget.serviceId,
        packageId: 0,
        categoryId: 0,
        currentTime: "00:00:00");
    setState(() {
      packageListdata = AllPackageDataModel();
      packageListdata = packagedata;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            // title: Image.asset("assets/png/logoyatree.png"),
            centerTitle: true,
            toolbarHeight: 50,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            bottom: PreferredSize(
              preferredSize:
                  suvServiceId == 0 ? Size.fromHeight(0) : Size.fromHeight(60),
              child: suvServiceId == 0
                  ? Container()
                  : Container(
                      height: 50,
                      child: subservicedata == null
                          ? Container()
                          : ListView.builder(
                              itemCount:
                                  subservicedata!.customListTable!.length,
                              itemBuilder: (_, index) {
                                if (suvServiceId ==
                                    subservicedata!
                                        .customListTable![index].id) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: subservicedata!
                                                  .customListTable![index]
                                                  .name!
                                                  .length <
                                              10
                                          ? 100
                                          : subservicedata!
                                                  .customListTable![index]
                                                  .name!
                                                  .length *
                                              15,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/png/buttonColor.png"),
                                              fit: BoxFit.cover),
                                          border:
                                              Border.all(color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Center(
                                            child: Text(
                                                subservicedata!
                                                    .customListTable![index]
                                                    .name
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white))),
                                      ),
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        suvServiceId = subservicedata!
                                            .customListTable![index].id!;
                                      });
                                      getServiceData();

                                      print(suvServiceId);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            // image: DecorationImage(
                                            //     image: AssetImage(
                                            //         "assets/png/buttonColor.png"),
                                            //     fit: BoxFit.cover),
                                            border:
                                                Border.all(color: Colors.blue),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Center(
                                            child: Text(
                                                subservicedata!
                                                    .customListTable![index]
                                                    .name
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black))),
                                      ),
                                    ),
                                  );
                                }
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                    ),
            ),
          ),
          body: _buildBody(context),
          // bottomNavigationBar: buildFooterNavigation()),
          bottomNavigationBar: adstripDataModel == null
              ? null
              : Container(
                  height: 50,
                  child: CarouselSlider.builder(
                    itemCount: adstripDataModel!.listAdStripMasters!.length,
                    itemBuilder: (_, index, pageViewIndex) {
                      return Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xffe6fdff),
                        child: Center(
                            child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${adstripDataModel!.listAdStripMasters![index].title}",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                "${adstripDataModel!.listAdStripMasters![index].description}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue,
                                    fontSize: 13),
                              ),
                            ),
                          ],
                        )),
                      );
                    },
                    options: CarouselOptions(
                      autoPlay: true,
                      // enlargeCenterPage: true,
                      viewportFraction: 1,
                      // aspectRatio: 2.0,
                      // initialPage: 2,
                    ),
                  ),
                )),
    );
  }

  _buildBody(BuildContext context) {
    return packageListdata == null
        ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  itemCount: packageListdata!.getPackagesDetails!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //scrollDirection: Axis.vertical,
                  itemBuilder: (_, index) {
                    return Column(
                      children: [
                        index == 0
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 8.0),
                                child: Text(
                                  "Tap to select your custom package",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 18.0, left: 18.0, top: 10.0, bottom: 10.0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    checkedValue[index] = !checkedValue[index];
                                  });
                                },
                                child: Container(
                                  height: 235,
                                  width: MediaQuery.of(context).size.width - 16,
                                  decoration: BoxDecoration(
                                      color: checkedValue[index] == false
                                          ? Colors.white
                                          : Color(0xFFA3D3FA),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5.0,
                                        ),
                                      ]),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          height: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              PageView.builder(
                                                controller: _pageController,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: packageListdata!
                                                    .getPackagesDetails![index]
                                                    .packagePlaceMappingDetails!
                                                    .length,
                                                onPageChanged: (index) {
                                                  setState(() {
                                                    current = index;
                                                  });
                                                },
                                                itemBuilder:
                                                    (context, indexnew) {
                                                  // current = index;
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "https://d19y8r79r2sdoe.cloudfront.net/public/${packageListdata!.getPackagesDetails![index].packagePlaceMappingDetails![indexnew].imageLocation}",
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "${packageListdata!.getPackagesDetails![index].packagePlaceMappingDetails![indexnew].placeName}",
                                                              style: GoogleFonts.poppins(
                                                                  shadows: <
                                                                      Shadow>[
                                                                    Shadow(
                                                                      offset: Offset(
                                                                          0.0,
                                                                          0.0),
                                                                      blurRadius:
                                                                          3.0,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                    ),
                                                                    Shadow(
                                                                      offset: Offset(
                                                                          0.0,
                                                                          0.0),
                                                                      blurRadius:
                                                                          8.0,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                  ],
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            _buildCustomerIndicator(
                                                                list: packageListdata!
                                                                    .getPackagesDetails![
                                                                        index]
                                                                    .packagePlaceMappingDetails!),
                                                          ],
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      ),
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Container(
                                                          color: Colors.grey,
                                                        );
                                                      },
                                                      placeholder:
                                                          (context, url) {
                                                        return Container(
                                                          color: Colors.grey,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(
                                            packageListdata!
                                                .getPackagesDetails![index]
                                                .packageName
                                                .toString()
                                                .capitalizeFirst!,
                                            style: GoogleFonts.poppins(
                                                // color:
                                                //     checkedValue[index] == false
                                                //         ? Colors.black
                                                //         : Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Total Location : ${packageListdata!.getPackagesDetails![index].packagePlaceMappingDetails!.length}",
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.grey.shade600,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                Spacer(),
                                                Text(
                                                    "${packageListdata!.getPackagesDetails![index].packageTotalDuration} Minutes",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Colors.blue)),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              packageListdata!.getPackagesDetails![index]
                                          .packageDiscountDetails!.length !=
                                      0
                                  ? Positioned(
                                      right: 20,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                        child: packageListdata!
                                                    .getPackagesDetails![index]
                                                    .packageDiscountDetails!
                                                    .length ==
                                                0
                                            ? Container()
                                            : Center(
                                                child: Text(
                                                  packageListdata!
                                                              .getPackagesDetails![
                                                                  index]
                                                              .packageDiscountDetails![
                                                                  0]
                                                              .type ==
                                                          1
                                                      ? packageListdata!
                                                              .getPackagesDetails![
                                                                  index]
                                                              .packageDiscountDetails![
                                                                  0]
                                                              .amount
                                                              .toString() +
                                                          "% OFF"
                                                      : packageListdata!
                                                              .getPackagesDetails![
                                                                  index]
                                                              .packageDiscountDetails![
                                                                  0]
                                                              .amount
                                                              .toString() +
                                                          "OFF",
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                ),
                                              ),
                                      ))
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    // Get.to(() => BookingPage(
                    //   rideType: "1",
                    //   packagename: widget.getPackagesDetail.packageName,
                    //   packageid: widget.getPackagesDetail.packageId,
                    //   price: widget.getPackagesDetail
                    //       .packageDiscountDetails!
                    //       .length ==
                    //       0 ?  widget.getPackagesDetail.packagePrice :getPrice(widget.getPackagesDetail) ,
                    //   packagePlaceMappingDetails:
                    //   widget.getPackagesDetail.packagePlaceMappingDetails,
                    // ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                        "Book Ride",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      )),
                    ),
                  ),
                  // Container(
                  //   height: 50,
                  //   width: MediaQuery.of(context).size.width * 0.85,
                  //   decoration: BoxDecoration(
                  //       boxShadow: [
                  //         BoxShadow(
                  //             color: Colors.grey.shade500,
                  //             blurRadius: 3,
                  //             spreadRadius: 1)
                  //       ],
                  //       image: DecorationImage(
                  //           image: AssetImage("assets/png/buttonColor.png"),
                  //           fit: BoxFit.cover),
                  //       border: Border.all(color: Colors.blue),
                  //       borderRadius: BorderRadius.circular(20)),
                  //   child: Center(
                  //       child: Text("Ride Now",
                  //           style: GoogleFonts.poppins(
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.white))),
                  // ),
                ),
                SizedBox(height: 20),
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
}
