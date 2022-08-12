import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/ui/packages/packageDetailPage.dart';
import 'package:yatree/utils/widgets/indicatorDots.dart';

class ExplorePageOld extends StatefulWidget {
  const ExplorePageOld({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePageOld> {
  AllPackageDataModel? packageListdata;

  PageController _pageController = PageController();
  var current = 0;
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
    return Scaffold(
      // appBar:  AppBar(
      //   elevation: 0.0,
      //   title: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Row(
      //       children: [
      //         SvgPicture.asset("assets/icons/offerIcon.svg"),
      //         SizedBox(width: 10,),
      //         Text("Explore",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.black),),
      //       ],
      //     ),
      //   ),
      //   //  leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,), onPressed: () { Get.back(); },),
      //   backgroundColor: Colors.white,
      //   // bottom: PreferredSize(preferredSize: Size.fromHeight(30),
      //   //   child: Padding(
      //   //     padding: const EdgeInsets.all(8.0),
      //   //     child: Row(
      //   //       children: [
      //   //         SvgPicture.asset("assets/icons/offerIcon.svg"),
      //   //         SizedBox(width: 10,),
      //   //         Text("Offers",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 23),),
      //   //       ],
      //   //     ),
      //   //   ),),
      // ),
      body: packageListdata != null
          ? ListView(
              addAutomaticKeepAlives: true,
              children: [
                _buildCategorySection(catId: 2, title: "Popular this week"),
                _buildCategorySection(catId: 3, title: "Most Popular"),
                _buildCategorySection(catId: 4, title: "Most Recommended"),
                _buildCategorySection(catId: 5, title: "Best for you"),
                //_buildReviewList(context)
              ],
            )
          : Container(
              child: Center(child: CircularProgressIndicator()),
            ),
    );
  }

  _buildCategorySection({var catId, title}) {
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
              Padding(
                padding:
                    const EdgeInsets.only(left: 12.0, right: 10.0, top: 10),
                child: Text(
                  title.toString(),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                height: 320,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: packageListdata!.getPackagesDetails!.length,
                    itemBuilder: (context, index) {
                      return packageListdata!
                                  .getPackagesDetails![index].categoryId ==
                              catId
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 8),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade400,
                                              blurRadius: 4.0,
                                              spreadRadius: 1),
                                        ]),
                                    child: Column(
                                      children: [
                                        // Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: Row(
                                        //     children: [
                                        //       Text(
                                        //         packageListdata!
                                        //             .getPackagesDetails![index].packageName
                                        //             .toString(),
                                        //         style: GoogleFonts.poppins(
                                        //             fontWeight: FontWeight.bold,
                                        //             fontSize: 20),
                                        //       ),
                                        //       Spacer(),
                                        //     ],
                                        //   ),
                                        // ),
                                        Container(
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)),
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
                                                  return InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          PackageDetailPageOld(
                                                            getPackagesDetail:
                                                                packageListdata!
                                                                        .getPackagesDetails![
                                                                    index],
                                                          ));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
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
                                                                        color: Color.fromARGB(
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
                                                                    fontSize:
                                                                        17,
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
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
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
                                            child: Text(
                                              packageListdata!
                                                  .getPackagesDetails![index]
                                                  .packageName
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "Total Location : ${packageListdata!.getPackagesDetails![index].packagePlaceMappingDetails!.length}",
                                                      style: GoogleFonts
                                                          .poppins()),
                                                  Spacer(),
                                                  Text(
                                                      "${packageListdata!.getPackagesDetails![index].packageTotalDuration} Minutes",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.blue)),
                                                ],
                                              ),
                                            )),
                                      ],
                                    )),
                              ),
                            )
                          : Container();
                    }),
              ),
            ],
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
