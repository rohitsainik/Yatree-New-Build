import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/controller/tab_controller.dart';
import 'package:yatree/model/profile.dart';
import 'package:yatree/services/registrationFunction.dart';
import 'package:yatree/utils/buildBottomNavigation.dart';
import 'package:yatree/utils/commonFunctions.dart';
import 'package:yatree/utils/validation.dart';

import '../../services/apiServices.dart';
import '../../utils/sharedPreference.dart';

class NewProfile extends StatefulWidget {
  final bool fromBottom;

  const NewProfile({Key? key, required this.fromBottom}) : super(key: key);

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  var username, location, place;
  ProfileData userProfile = ProfileData();
  TextEditingController name = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  final GlobalKey<FormState> _keyForm = GlobalKey();
  var isLoading = true;

  Future getData() async {
    SharedPref pref = SharedPref();
    var profile = await getUserMasterData();
    var temp = await pref.getUsername();
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      username = temp;
      userProfile = profile;
      email.text = userProfile.getUserByCognitoId?.email ?? "";
      mobileNumber.text = userProfile.getUserByCognitoId?.phoneNumber ?? "";
      name.text = userProfile.getUserByCognitoId?.name ?? "";

      isLoading = false;
    });
    await _getstartPlace(position.latitude, position.longitude);
    print("profile: ${userProfile.getUserByCognitoId}");
  }

  sendData() async {
    SharedPref pref = SharedPref();
    var userId = await pref.getUserId();
    var userName = await pref.getUsername();
    var data = await updateUserData(
      cognitoId: userProfile.getUserByCognitoId?.cognitoId.toString(),
      entryBy: userId.toString(),
      updatedDateTime: DateTime.now().toIso8601String(),
      entryDateTime: DateTime.now().toIso8601String(),
      name: name.text,
      email: email.text,
      phoneNumber: mobileNumber.text,
    );
    Get.back();
    setState(() {
      userProfile = ProfileData();
    });

    getData();
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
      location = name.toString();

      // update _address
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final LandingPageController landingPageController =
        Get.put(LandingPageController(), permanent: false);
    if (widget.fromBottom == true) {
      return Scaffold(
        body: buildPageBody(),
        bottomNavigationBar: buildBottomNavyBar(landingPageController),
      );
    } else {
      return Scaffold(
        body: userProfile.getUserByCognitoId == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
                                  fit: BoxFit.cover)),
                          child: new BackdropFilter(
                            filter:
                                new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: new Container(
                              decoration: new BoxDecoration(
                                  color: Colors.black.withOpacity(0.3)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.30,
                          width: MediaQuery.of(context).size.width,
                          child: SafeArea(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (widget.fromBottom != true)
                                      IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          )),
                                    Text(
                                      "Profile",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        editDetails();
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(35),
                                      topRight: Radius.circular(35))),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 170,
                                        height: 20,
                                      ),
                                      Container(
                                        height: 55,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${userProfile.getUserByCognitoId?.name}",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                if (location != null)
                                                  Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                                Text(
                                                  location ?? "",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          "Basic Details",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Name",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "${userProfile.getUserByCognitoId?.name}",
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Mobile Number",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "${userProfile.getUserByCognitoId?.phoneNumber}",
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Email",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "${userProfile.getUserByCognitoId?.email}",
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 25),
                                        Text(
                                          "Address",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Current Location",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              location ?? "",
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Address",
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Container(
                                              width: 150,
                                              child: Text(
                                                place ?? "",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.grey.shade600,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: -55,
                              left: 35,
                              child: Stack(
                                children: [
                                  Container(
                                    height: 110,
                                    width: 110,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                  ),
                                  /*Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.white, width: 4)),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ))*/
                                ],
                                clipBehavior: Clip.none,
                              ),
                            ),
                          ],
                          clipBehavior: Clip.none,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            signOut();
          },
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.login_outlined,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  buildPageBody() {
    return Scaffold(
      body: userProfile.getUserByCognitoId == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
                                fit: BoxFit.cover)),
                        child: new BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: new Container(
                            decoration: new BoxDecoration(
                                color: Colors.black.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.30,
                        width: MediaQuery.of(context).size.width,
                        child: SafeArea(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.arrow_back,
                                        color: Colors.transparent,
                                      )),
                                  Text(
                                    "Profile",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      editDetails();
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.70,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(35),
                                    topRight: Radius.circular(35))),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 170,
                                      height: 20,
                                    ),
                                    Container(
                                      height: 55,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${userProfile.getUserByCognitoId?.name}",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              if (location != null)
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                              Text(
                                                location ?? "",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        "Basic Details",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Name",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "${userProfile.getUserByCognitoId?.name}",
                                            style: GoogleFonts.roboto(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Mobile Number",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "${userProfile.getUserByCognitoId?.phoneNumber}",
                                            style: GoogleFonts.roboto(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Email",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "${userProfile.getUserByCognitoId?.email}",
                                            style: GoogleFonts.roboto(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 25),
                                      Text(
                                        "Address",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Current Location",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            location ?? "",
                                            style: GoogleFonts.roboto(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Address",
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            child: Text(
                                              place ?? "",
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey.shade600,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -55,
                            left: 35,
                            child: Stack(
                              children: [
                                Container(
                                  height: 110,
                                  width: 110,
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                ),
                                /*Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: Colors.white, width: 4)),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ))*/
                              ],
                              clipBehavior: Clip.none,
                            ),
                          ),
                        ],
                        clipBehavior: Clip.none,
                      ),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          signOut();
        },
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login_outlined,
                color: Colors.black,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Logout",
                style: TextStyle(
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  editDetails() {
    Get.bottomSheet(Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Form(
          key: _keyForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextFormField(
                    validator: validateName,
                    controller: name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Customer Name',
                      hintStyle: GoogleFonts.poppins(),
                      /* border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(16),
                            fillColor: Colors.white,*/
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextFormField(
                    maxLength: 10,
                    validator: validateMobile,
                    controller: mobileNumber,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Customer Mobile No.',
                      hintStyle: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextFormField(
                    validator: validateEmail,
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Customer Email',
                      hintStyle: GoogleFonts.poppins(),
                      /*border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(16),
                            fillColor: Colors.white,*/
                    ),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_keyForm.currentState!.validate()) {
                    // No any error in validation
                    _keyForm.currentState!.save();
                    sendData();
                    showToast(message: "Profile Updated");
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                      child: Text(
                    "Submit",
                    style: GoogleFonts.roboto(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  )),
                ),
              ),
            ],
          ),
        )));
  }
}
