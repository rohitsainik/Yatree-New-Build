import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Screens/Packages/packageList.dart';
import 'package:yatree/Screens/Packages/packageList2.dart';
import 'package:yatree/Screens/perspective.dart';
import 'package:yatree/Screens/pick_and_drop/pick_and_drop.dart';
import 'package:yatree/Screens/sightseeing/signseeing.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/controller/tab_controller.dart';
import 'package:yatree/model/offers/offers.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/model/serive.dart';
import 'package:yatree/model/trending.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/ui/offers/offersPage.dart';
import 'package:yatree/ui/rental/rent_auto.dart';
import 'package:yatree/ui/spin_around/spin_around.dart';
import 'package:yatree/utils/sharedPreference.dart';
import 'package:yatree/utils/webview.dart';
import 'package:yatree/utils/widgets/drawer.dart';
import 'package:yatree/utils/widgets/indicatorDots.dart';

import '../Packages/PackageDetailPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.username,
  }) : super(key: key);
  var username;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  var offertestImage =
      "https://images.pexels.com/photos/56832/road-asphalt-space-sky-56832.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260";
  SharedPref pref = SharedPref();
  ServiceDataModel? servicedata;
  TrendingData? trendingData;
  OfferDataModel? offerData;
  AllPackageDataModel? packageListdata;
  PageController _pageController = PageController();
  var current = 0;

  getData() async {
    getUserMasterData();
    ServiceDataModel service = await getServiceData();
    OfferDataModel offer = await getOfferMasterData();
    AllPackageDataModel packagedata = await getPackageDetailsData(
        subServiceId: 0,
        serviceId: 0,
        packageId: 0,
        categoryId: 0,
        currentTime: "00:00:00");
    TrendingData treding = await getTrendingNowData();
    setState(() {
      packageListdata = packagedata;
      servicedata = service;
      offerData = offer;
      trendingData = treding;
    });
  }

  List placeName = [
    "Udaipur",
    "Jaipur",
    "Delhi",
    "Goa",
    "Mumbai",
    "Chennai",
    "Gurgoan",
  ];
  List placeImage = [
    "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0c/77/15/9a/photo0jpg.jpg?w=600&h=400&s=1",
    "https://www.traveloaces.com/wp-content/uploads/2020/04/Hawa-Mahal.jpg",
    "https://media.istockphoto.com/photos/india-gate-in-new-dehli-at-dusk-picture-id481501921?k=20&m=481501921&s=612x612&w=0&h=OVwwQzdyHZA38I2MmutNcF9H_Dcl6_oa89Ez9rYmcfE=",
    "https://www.tripsavvy.com/thmb/cZaqHU49n4ORXE7irAXYzEb-h6c=/395x0/filters:no_upscale():max_bytes(150000):strip_icc():gifv()/india--goa--palolem-beach-535168027-d54c88a5e0044088aeae5175145e45cd.jpg",
    "https://www.telegraph.co.uk/content/dam/Travel/Destinations/Asia/India/Mumbai/gateway-of-india-mumbai-xlarge.jpg?imwidth=640",
    "https://img.traveltriangle.com/blog/wp-content/uploads/2018/01/Kalikambal-Temple-kb6592.jpg",
    "https://www.nobroker.in/blog/wp-content/uploads/2021/10/Cost-of-living-in-Gurgaon.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    final LandingPageController landingPageController =
        Get.put(LandingPageController(), permanent: false);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        key: _scaffoldkey,
        drawer: Drawer(
          child: AppDrawer(
              username: widget.username.toString(),
              landingPageController: landingPageController),
        ),
        /*appBar: AppBar(
          // backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0.0,
          actions: [
            Center(
              child: SvgPicture.asset('assets/svg/Pick Up.svg'),
            ),
            SizedBox(
              width: 10,
            ),
            Center(
                child: Text(
              place,
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            )),
            SizedBox(
              width: 10,
            )
          ],
          leading: InkWell(
            onTap: () {
              _scaffoldkey.currentState!.openDrawer();
            },
            child: Container(
              height: 10.00,
              child: Image.asset(
                "assets/logo/yatreelogoappbar.png",
              ),
            ),
          ),
          // title: Image.asset("assets/png/logoyatree.png"),
        ),*/
        body: servicedata != null
            ? ListView(
                addAutomaticKeepAlives: true,
                children: [
                  _buildTopContainer(context),
                  // SizedBox(height: 20),
                  ListTile(
                    leading: SvgPicture.asset("assets/svg/offer.svg"),
                    title: Text(
                      "Offer For You",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: InkWell(
                      onTap: (){
                        Get.to(() => OffersPage());
                      },
                      child: Text(
                        "View All >",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  _buildOfferList(context),
                  SizedBox(height: 10),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 3,
                  ),
                  SizedBox(height: 8),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 20.0, vertical: 0),
                  //   child: Text(
                  //     "Select your trip type",
                  //     style: GoogleFonts.poppins(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 20,
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //   child: Divider(
                  //     color: Colors.black,
                  //     thickness: 1,
                  //   ),
                  // ),
                  /*Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Top Places",
                            style: GoogleFonts.prozaLibre(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xff0D4B81),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: placeName.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    left: index == 0 ? 15.0 : 0,
                                    right: index == placeName.length - 1
                                        ? 15.0
                                        : 0,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            print("clicked");
                                            getUserMasterData();
                                          },
                                          child: Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        placeImage[index]),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                      ),
                                      Text(placeName[index])
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),*/
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Trending Udaipur",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  _buildTrendingList(context),
                  SizedBox(height: 20),
                  /*SizedBox(height: 10),
                  _buildBodyList(context),
                  SizedBox(height: 20),*/
                  // _buildBottom(context),
                  //_buildReviewList(context)
                ],
              )
            : Container(
                child: Center(child: CircularProgressIndicator()),
              ));
  }

  _buildTopContainer(BuildContext context) {
    return Container(
      height: 270,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: Theme.of(context).appBarTheme.backgroundColor
                  // color: Colors.white,
                  ),
            ),
          ),
          Positioned(
            top: 50,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              height: 200,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: AlignedGridView.count(
                crossAxisCount: 3,
                itemCount: servicedata!.listServiceMasters!.length,
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            if (servicedata!.listServiceMasters![index].name ==
                                'Rent us') {
                              Get.to(() => RentPage());
                            } else if (servicedata!
                                    .listServiceMasters![index].name ==
                                'Pick N Drop') {
                              Get.to(() => PickAndDrop());
                            } else if (servicedata!
                                    .listServiceMasters![index].name ==
                                "SpinAround") {
                              Get.to(() => SpinAroundPage());
                            } else if (servicedata!
                                    .listServiceMasters![index].name ==
                                "Sightseeing") {
                              Get.to(() => SightSeeing(
                                    serviceData:
                                        servicedata!.listServiceMasters![index],
                                  ));
                            } else if (servicedata!
                                    .listServiceMasters![index].name ==
                                "Outstation Ride") {
                              Get.to(() => WebViewPage(
                                    url:
                                        "https://www.yatreedestination.com/services/Outstation-Rides",
                                  ));
                            }else if (servicedata!
                                    .listServiceMasters![index].name ==
                                "City Guide") {
                              Get.to(() => WebViewPage(
                                    url:
                                        "https://www.yatreedestination.com/services/Outstation-Rides",
                                  ));
                            }

                            /* Get.to(() => PackageList(
                                  serviceId: servicedata!
                                      .listServiceMasters![index].id,
                                  categoryId:
                                      servicedata!.listServiceMasters![index],
                                ));*/
                          },
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(40),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://d19y8r79r2sdoe.cloudfront.net/public/${servicedata!.listServiceMasters![index].image}"),
                                    fit: BoxFit.fill)),
                          ),
                        ),
                      ),
                      Text(
                        servicedata!.listServiceMasters![index].name.toString(),
                        style: GoogleFonts.raleway(color: Color(0xff147BC1)),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          Positioned(
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://d2az3zd39o5d63.cloudfront.net/linkedin-profile-picture-squinch.jpg"),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(70),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FutureBuilder(
                            future: pref.getUsername(),
                            builder: (context, snap) {
                              return Text(
                                "${snap.data}",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              );
                            }),
                      ],
                    ),

                    // Spacer(),
                    // IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(
                    //       Icons.notifications,
                    //       color: Colors.amber,
                    //     ))
                  ],
                ),
              )),
        ],
      ),
    );
  }

  _buildOfferList(BuildContext context) {
    return Container(
        height: 140,

        // width: MediaQuery.of(context).size.width /2,
        child: CarouselSlider.builder(
          itemCount: offerData?.listOfferMasters!.length,
          itemBuilder: (context, index, pageViewIndex) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl:
                                "${AppStrings.imageUrl}${offerData?.listOfferMasters![index].image}",
                            imageBuilder: (context, imageProvider) => Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                                // color: Colors.white,
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width - 20,
                              color: Colors.blue,
                            ),
                            errorWidget: (context, url, error) => Container(
                                height: 140,
                                width: MediaQuery.of(context).size.width - 20,
                                color: Colors.blue,
                                child: Center(
                                  child: Icon(Icons.error),
                                )),
                          ),
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              'E-Rickshaw Rides',
                              style: GoogleFonts.raleway(fontSize: 10),
                            ),
                            Text(
                              'Flat 10% OFF on Rides!',
                              style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ))
                      ],
                    ),
                    DottedLine(
                      lineThickness: 1.0,
                      dashLength: 10.0,
                      dashGapLength: 10.0,
                    ),
                    TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: offerData?.listOfferMasters![index].name)).then((_){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("copied to clipboard")));
                          });
                        },
                        child: Text(
                            "Copy & Book: ${offerData?.listOfferMasters![index].name}"))
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            viewportFraction: 0.7,
            // aspectRatio: 2.0,
            // initialPage: 2,
          ),
        ));
  }

  _buildTrendingList(BuildContext context) {
    return Container(
        height: 180,
        // width: MediaQuery.of(context).size.width /2,
        child: CarouselSlider.builder(
          itemCount: trendingData?.listTrendingNow!.length,
          itemBuilder: (context, index, pageViewIndex) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: CachedNetworkImage(
                imageUrl:
                    "${AppStrings.imageUrl}${trendingData!.listTrendingNow![index].image}",
                imageBuilder: (context, imageProvider) => Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width * 0.65,
                  decoration: BoxDecoration(
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1,
                        color: Colors.grey.shade400,
                      ),
                    ],
                    // color: Colors.white,
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width - 20,
                  color: Colors.blue,
                ),
                errorWidget: (context, url, error) => Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width - 20,
                    color: Colors.blue,
                    child: Center(
                      child: Icon(Icons.error),
                    )),
              ),
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            viewportFraction: 0.7,
            // aspectRatio: 2.0,
            // initialPage: 2,
          ),
        ));
  }

/*  _buildBodyList(BuildContext context) {
    return Column(
      children: List.generate(servicedata!.listServiceMasters!.length, (index) {
        return Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => PackageList(
                        serviceId: servicedata!.listServiceMasters![index].id,
                        categoryId: servicedata!.listServiceMasters![index],
                      ));
                },
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://d19y8r79r2sdoe.cloudfront.net/public/${servicedata!.listServiceMasters![index].image}"),
                        fit: BoxFit.fitWidth),
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            index == 2
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => PackageList2(
                              serviceId: servicedata!.listServiceMasters![0].id,
                              categoryId: servicedata!.listServiceMasters![0],
                            ));
                      },
                      child: Container(
                        height: 180,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://d19y8r79r2sdoe.cloudfront.net/public/${servicedata!.listServiceMasters![0].image}"),
                              fit: BoxFit.fitWidth),
                          borderRadius: BorderRadius.circular(10),
                          // color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      }),

      // children: [
      //    Padding(
      //      padding: const EdgeInsets.all(8.0),
      //      child: GestureDetector(
      //        onTap: (){
      //          Get.to(()=>PackageList(serviceId: servicedata!.listServiceMasters![0].id,categoryId: servicedata!.listServiceMasters![0],));
      //        },
      //        child: Container(
      //          height: 200,
      //          width: MediaQuery.of(context).size.width,
      //          decoration: BoxDecoration(
      //            image:DecorationImage(image: AssetImage("assets/png/homeImage.png"),
      //                fit: BoxFit.fitWidth),
      //            borderRadius: BorderRadius.circular(10),
      //            // color: Colors.blueAccent,
      //          ),
      //        ),
      //      ),
      //    ),
      //    Padding(
      //      padding: const EdgeInsets.all(8.0),
      //      child: GestureDetector(
      //        onTap: (){
      //          Get.to(()=>PickAndDrop(appBar: true,));
      //        },
      //        child: Container(
      //          height: 200,
      //          width: MediaQuery.of(context).size.width,
      //          decoration: BoxDecoration(
      //            image:DecorationImage(image: AssetImage("assets/png/pink_and_drop.png"),
      //                fit: BoxFit.fitWidth),
      //            borderRadius: BorderRadius.circular(10),
      //            // color: Colors.blueAccent,
      //          ),
      //        ),
      //      ),
      //    ),
      //    Padding(
      //      padding: const EdgeInsets.all(8.0),
      //      child: GestureDetector(
      //        onTap: (){
      //          Get.to(()=>PackageList(serviceId: servicedata!.listServiceMasters![1].id));
      //        },
      //        child: Container(
      //          height: 200,
      //          width: MediaQuery.of(context).size.width,
      //          decoration: BoxDecoration(
      //            image:DecorationImage(image: AssetImage("assets/png/dawn.png"),
      //                fit: BoxFit.fitWidth),
      //            borderRadius: BorderRadius.circular(10),
      //            // color: Colors.blueAccent,
      //          ),
      //        ),
      //      ),
      //    ),
      //    Padding(
      //      padding: const EdgeInsets.all(8.0),
      //      child: GestureDetector(
      //        onTap: (){
      //          Get.to(()=>PackageList(serviceId: servicedata!.listServiceMasters![2].id));
      //        },
      //        child: Container(
      //          height: 200,
      //          width: MediaQuery.of(context).size.width,
      //          decoration: BoxDecoration(
      //            image:DecorationImage(image: AssetImage("assets/png/spin.png"),
      //                fit: BoxFit.fitWidth),
      //            borderRadius: BorderRadius.circular(10),
      //            // color: Colors.blueAccent,
      //          ),
      //        ),
      //      ),
      //    ),
      //  ]
    );
  }
`
  _buildBottom(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "Why to travel with\nYATREE?",
            style: GoogleFonts.prozaLibre(
              fontWeight: FontWeight.bold,
              fontSize: 26,
              color: Color(0xff0D4B81),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/png/p3.png"))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Text(
                      "Your Environment friendly explorer",
                      style: GoogleFonts.prozaLibre(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff0D4B81),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/png/p1.png"))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Text(
                      "Best travel oriented services.",
                      style: GoogleFonts.prozaLibre(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff0D4B81),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/png/p4.png"))),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Text(
                      "A step towards modernisation",
                      style: GoogleFonts.prozaLibre(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff0D4B81),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/png/p2.png"))),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Text(
                      "Economical mode of daily commute",
                      style: GoogleFonts.prozaLibre(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xff0D4B81),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildReviewList(BuildContext context) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 320,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://googleflutter.com/sample_image.jpg'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      title: Text(
                        "kavish jain",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Yatree",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "amazing",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "best app to book tours in udaipur amazing awesome,jhjghjghjghj jh hghj ghghjghjg h gjhg ",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
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
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title.toString(),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: packageListdata!.getPackagesDetails!.length,
                    itemBuilder: (context, index) {
                      return packageListdata!
                                  .getPackagesDetails![index].categoryId ==
                              catId
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                    height: 320,
                                    width:
                                        MediaQuery.of(context).size.width - 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0,
                                          ),
                                        ]),
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
                                                          PackageDetailPage(
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
                                        Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Rs " +
                                                        packageListdata!
                                                            .getPackagesDetails![
                                                                index]
                                                            .packagePrice
                                                            .toString(),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.blue,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  Spacer(),
                                                  // Text(
                                                  //   "Know More",
                                                  //   style: GoogleFonts.poppins(
                                                  //       fontWeight:
                                                  //       FontWeight.bold,
                                                  //       fontSize: 12,
                                                  //       color: Colors.blue),
                                                  // ),
                                                  // SizedBox(
                                                  //   width: 10,
                                                  // ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          PackageDetailPage(
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
                                                              fit:
                                                                  BoxFit.cover),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.blue),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                      child: Center(
                                                          child: Text(
                                                              "Know More",
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white))),
                                                    ),
                                                  ),
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
  }*/

  bool test = false;

  @override
  void initState() {
    getData();
    // getPackageData();
    //getPackageDetailsData(serviceId: 2,subServiceId: 1,currentTime: "00:00:00");
    //  getServiceData();
    // getAutoMasterData();

    getOfferMasterData();

    // getDownloadUrl();
    // getCustomTableData(tableName: "SubServiceMaster",condition: "serviceId=2");
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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
