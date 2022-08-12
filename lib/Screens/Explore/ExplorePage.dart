import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Cards/PackageCard.dart';
import 'package:yatree/controller/tab_controller.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/utils/widgets/drawer.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key, required this.username}) : super(key: key);

  var username;
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  AllPackageDataModel? packageListdata;

  getData() async {
    AllPackageDataModel packagedata = await getPackageDetailsData(
        subServiceId: 0,
        serviceId: 0,
        packageId: 0,
        categoryId: 0,
        currentTime: "00:00:00");
    setState(() {
      packageListdata = packagedata;
    });
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final LandingPageController landingPageController =
        Get.put(LandingPageController(), permanent: false);
    return Scaffold(
      key: _scaffoldkey,
      drawer: Drawer(
        child: AppDrawer(
            username: widget.username.toString(),
            landingPageController: landingPageController),
      ),
      body: Stack(
        children: [
          BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/png/explorebg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: new Container(
                  decoration:
                      new BoxDecoration(color: Colors.white.withOpacity(0.2)),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: packageListdata != null
                ? ListView(
                    addAutomaticKeepAlives: true,
                    padding: EdgeInsets.zero,
                    children: [
                      _buildCategorySection(
                          catId: 2,
                          title: "Popular this week",
                          show: false,
                          all: false),
                      SizedBox(height: 20),
                      _buildCategorySection(
                          catId: 3,
                          title: "Most Popular",
                          show: true,
                          all: false),
                      SizedBox(height: 20),
                      _buildCategorySection(
                          catId: 4,
                          title: "Most Recommended",
                          show: false,
                          all: false),
                      SizedBox(height: 20),
                      // _buildCategorySection(
                      //     catId: 5, title: "Best for you", show: false,all: false),
                      _buildCategorySection(
                          catId: 4,
                          title: "All Places",
                          show: false,
                          all: true),
                      SizedBox(height: 20),
                      //_buildReviewList(context)
                    ],
                  )
                : Container(
                    child: Center(child: CircularProgressIndicator()),
                  ),
          )
        ],
      ),
    );
  }

  _buildCategorySection({var catId, title, show, all}) {
    var listLength = packageListdata!.getPackagesDetails!
        .where((element) => element.categoryId == catId)
        .toList()
        .length;
    return listLength == 0
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              show
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 5.0, right: 10.0, top: 0),
                      child: SafeArea(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Image.asset(
                            "assets/png/menu.png",
                            height: 25,
                            width: 25,
                          ),
                          onPressed: () {
                            _scaffoldkey.currentState!.openDrawer();
                          },
                        ),
                      ))
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 10.0, top: 0),
                child: Text(
                  title.toString(),
                  style: GoogleFonts.prozaLibre(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xff0D4B81)),
                ),
              ),
              show
                  ? Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 10.0, top: 0),
                      child: Text(
                        "Never miss a thing around you.",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Color(0xff0D4B81)),
                      ),
                    )
                  : Container(),
              SizedBox(height: 10),
              Container(
                height: 240,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: packageListdata!.getPackagesDetails!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: PackageCard(
                          packageListData:
                              packageListdata!.getPackagesDetails![index],
                          showPrice: false,
                          showButton: false,
                        ),
                      );
                    }),
              ),
              all
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width - 24,
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
                              "Explore all places",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
  }
}
