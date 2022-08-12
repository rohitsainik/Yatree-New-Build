import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Screens/Packages/PackageDetailPage.dart';
import 'package:yatree/model/asStrip.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/model/package/subservice.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/cutomListTable.dart';
import 'package:yatree/utils/widgets/indicatorDots.dart';

class PackageList extends StatefulWidget {
  PackageList({Key? key, this.serviceId, this.categoryId}) : super(key: key);

  var serviceId, categoryId;

  @override
  _PackageListState createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  PageController _pageController = PageController();
  var current = 0;
  var suvServiceId;
  SubserviceDataModel? subservicedata;
  AdStrip? adstripDataModel;

  AllPackageDataModel? packageListdata;

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
    print("00:00:00");

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
        : ListView.builder(
            itemCount: packageListdata!.getPackagesDetails!.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      Container(
                          height: 340,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                ),
                              ]),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      packageListdata!
                                          .getPackagesDetails![index]
                                          .packageName
                                          .toString(),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.white,
                                height: 200,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    PageView.builder(
                                      controller: _pageController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: packageListdata!
                                          .getPackagesDetails![index]
                                          .packagePlaceMappingDetails!
                                          .length,
                                      onPageChanged: (index) {
                                        setState(() {
                                          current = index;
                                        });
                                      },
                                      itemBuilder: (context, indexnew) {
                                        // current = index;
                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => PackageDetailPage(
                                                  getPackagesDetail:
                                                      packageListdata!
                                                              .getPackagesDetails![
                                                          index],
                                                ));
                                          },
                                          child: Container(
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  "https://d19y8r79r2sdoe.cloudfront.net/public/${packageListdata!.getPackagesDetails![index].packagePlaceMappingDetails![indexnew].imageLocation}",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${packageListdata!.getPackagesDetails![index].packagePlaceMappingDetails![indexnew].placeName}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              shadows: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(
                                                                  0.0, 0.0),
                                                              blurRadius: 3.0,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                            ),
                                                            Shadow(
                                                              offset: Offset(
                                                                  0.0, 0.0),
                                                              blurRadius: 8.0,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ],
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    _buildCustomerIndicator(
                                                        list: packageListdata!
                                                            .getPackagesDetails![
                                                                index]
                                                            .packagePlaceMappingDetails!),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) {
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
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                            "Total Location : ${packageListdata!.getPackagesDetails![index].packagePlaceMappingDetails!.length}",
                                            style: GoogleFonts.poppins()),
                                        Spacer(),
                                        Text(
                                            "${packageListdata!.getPackagesDetails![index].packageTotalDuration} Minutes",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Colors.blue)),
                                      ],
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Rs " +
                                              packageListdata!
                                                  .getPackagesDetails![index]
                                                  .packagePrice
                                                  .toString(),
                                          style: GoogleFonts.poppins(
                                              color: Colors.blue,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => PackageDetailPage(
                                                  getPackagesDetail:
                                                      packageListdata!
                                                              .getPackagesDetails![
                                                          index],
                                                ));
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/png/buttonColor.png"),
                                                    fit: BoxFit.cover),
                                                border: Border.all(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(25)),
                                            child: Center(
                                                child: Text("Know More",
                                                    style: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          )),
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ),
                              ))
                          : Container(),
                    ],
                  ),
                ),
              );
            },
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
