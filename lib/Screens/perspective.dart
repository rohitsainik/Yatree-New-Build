import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Screens/Explore/ExplorePage.dart';
import 'package:yatree/controller/tab_controller.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/ui/offers/offersPage.dart';
import 'package:yatree/ui/rental/rent_auto.dart';
import 'package:yatree/ui/rides/myRides.dart';
import 'package:yatree/utils/sharedPreference.dart';
import 'package:yatree/utils/webview.dart';

import '../ui/account/newProfile.dart';
import 'Home/home.dart';

var currentIndex = 1;
var place = "";
final GlobalKey<MyRidesState> ridePageKey = GlobalKey();

class PerspectivePage extends StatefulWidget {
  const PerspectivePage({Key? key}) : super(key: key);

  @override
  _PerspectivePageState createState() => _PerspectivePageState();
}

class _PerspectivePageState extends State<PerspectivePage> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  var username, userid, currentPosition;

  _getData() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    SharedPref pref = SharedPref();
    var userId = await pref.getUserId();
    var userName = await pref.getUsername();
    var token = await pref.getToken();
    await UpdateEndpoint(userId: userId.toString(), token: token);
    setState(() {
      username = userName;
    });
    print("user id is $userId");
    print("user name is $username");
    await _getstartPlace(position.latitude, position.longitude);
  }

  _getstartPlace(lat, long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    // this is all you need
    Placemark placeMark = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? address = "$locality ${subLocality}";

    print(address);

    setState(() {
      place = address.toString();
      // update _address
    });
    print("place" + place);
  }

  @override
  void initState() {
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    final LandingPageController landingPageController =
        Get.put(LandingPageController(), permanent: false);
    return Scaffold(
      body: Obx(() => SizedBox.expand(
            child: IndexedStack(
              index: landingPageController.tabIndex.value,
              children: <Widget>[
                MyHomePage(username: username),
                MyRides(
                  appBar: false,
                  key: ridePageKey,
                ),
                WebViewPage(url: "https://www.yatreedestination.com/blogs",),

                // ExplorePageOld(),
                OffersPage(),
                NewProfile(),
                // ProfilePage()
              ],
            ),
          )),
      bottomNavigationBar: buildBottomNavyBar(landingPageController),
    );
  }

  buildBottomNavyBar(landingPageController) {
    return Obx(() => BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.white,
      selectedItemColor: Colors.white,
      currentIndex: landingPageController.tabIndex.value,
          backgroundColor: Colors.black,

          onTap: landingPageController.changeTabIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
              icon: SvgPicture.asset(
                "assets/svg/bottom_home.svg",
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
                icon: SvgPicture.asset(
                  "assets/svg/bottom_ride.svg",
                  color: Colors.white,
                ),
                label:  'Rides',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
                icon: SvgPicture.asset(
                  "assets/icons/blog.svg",
                  color: Colors.white,
                ),
                label: 'Blog',
                ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
                icon: SvgPicture.asset(
                  "assets/svg/bottom_offer.svg",
                  color: Colors.white,
                  height: 32,
                ),
                label:  'Offer',
                ),
            BottomNavigationBarItem(
              backgroundColor: Colors.black,
                icon: Image.asset(
                  "assets/png/profile.png",
                  color: Colors.white,
                  height: 32,
                ),
                label: 'Profile',
                ),
          ],
        ));
  }
}
