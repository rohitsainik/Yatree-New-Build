import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Screens/Packages/PackageDetailPage.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/utils/widgets/indicatorDots.dart';

class PackageCard extends StatefulWidget {
  PackageCard({
    Key? key,
    required this.packageListData,
    required this.showPrice,
    required this.showButton,
  }) : super(key: key);

  GetPackagesDetail packageListData;
  bool showPrice;
  bool showButton;
  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  var current = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: InkWell(
        onTap: () {
          Get.to(() => PackageDetailPage(
                getPackagesDetail: widget.packageListData,
              ));
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                        spreadRadius: 1),
                  ]),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.packageListData
                                .packagePlaceMappingDetails!.length,
                            onPageChanged: (index) {
                              setState(() {
                                current = index;
                              });
                            },
                            itemBuilder: (context, indexnew) {
                              // current = index;
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "https://d19y8r79r2sdoe.cloudfront.net/public/${widget.packageListData.packagePlaceMappingDetails![indexnew].imageLocation}",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${widget.packageListData.packagePlaceMappingDetails![indexnew].placeName}",
                                          style: GoogleFonts.poppins(
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 3.0,
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                                Shadow(
                                                  offset: Offset(0.0, 0.0),
                                                  blurRadius: 8.0,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        _buildCustomerIndicator(
                                            list: widget.packageListData
                                                .packagePlaceMappingDetails!),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.packageListData.packageName
                            .toString()
                            .capitalizeFirst!,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text(
                              "Total Location : ${widget.packageListData.packagePlaceMappingDetails!.length}",
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            Text(
                                "${widget.packageListData.packageTotalDuration} Minutes",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.blue)),
                          ],
                        ),
                      )),
                  widget.showPrice && widget.showButton
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Rs " +
                                    widget.packageListData.packagePrice
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
                                          widget.packageListData));
                                },
                                child: Container(
                                  height: 30,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/png/buttonColor.png"),
                                          fit: BoxFit.cover),
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(25)),
                                  child: Center(
                                      child: Text("Know More",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            widget.packageListData.packageDiscountDetails!.length != 0
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
                      child: widget.packageListData.packageDiscountDetails!
                                  .length ==
                              0
                          ? Container()
                          : Center(
                              child: Text(
                                widget.packageListData
                                            .packageDiscountDetails![0].type ==
                                        1
                                    ? widget.packageListData
                                            .packageDiscountDetails![0].amount
                                            .toString() +
                                        "% OFF"
                                    : widget.packageListData
                                            .packageDiscountDetails![0].amount
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
