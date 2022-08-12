import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Cards/PackageCard.dart';
import 'package:yatree/model/asStrip.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/model/package/subservice.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/cutomListTable.dart';

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
          bottomNavigationBar: adstripDataModel == null
              ? null
              : Container(
                  height: 50,
                  child: CarouselSlider.builder(
                    itemCount: adstripDataModel!.listAdStripMasters!.length,
                    options: CarouselOptions(
                      autoPlay: true,
                      // enlargeCenterPage: true,
                      viewportFraction: 1,
                      // aspectRatio: 2.0,
                      // initialPage: 2,
                    ),
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
                                  padding: EdgeInsets.symmetric(horizontal: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: Container(
                  height: 280,
                  width: MediaQuery.of(context).size.width,
                  child: PackageCard(
                    packageListData:
                        packageListdata!.getPackagesDetails![index],
                    showPrice: true,
                    showButton: true,
                  ),
                ),
              );
            },
          );
  }
}
