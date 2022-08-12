import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yatree/controller/tab_controller.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/ui/packages/mapScreen.dart';
import 'package:yatree/utils/commonFunctions.dart';
import 'package:yatree/utils/sharedPreference.dart';
import 'package:yatree/utils/validation.dart';
import 'package:yatree/utils/widgets/drawer.dart';
import 'package:yatree/utils/widgets/gradient.dart';

import '../../Screens/perspective.dart';

class RentPage extends StatefulWidget {
  RentPage({Key? key,  this.username}) : super(key: key);

  var username;
  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  final GlobalKey<FormState> _keyForm = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  String? _setStartTime = "",
      _setEndTime = "",
      _setStartDate = "",
      _setEndDate = "";
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);
  var _todaysDate = DateTime.now();
  var StartDate, StartTime, Start_hour, Start_time, Start_minute;
  var EndDate, EndTime, End_hour, End_time, End_minute;
  bool isChecked = false;
  var startPosition;
  late LandingPageController landingPageController;

  var _validate;
  TextEditingController customerName = TextEditingController();
  TextEditingController customerMobileNumber = TextEditingController();
  TextEditingController customerEmail = TextEditingController();
  TextEditingController event = TextEditingController();
  TextEditingController noOfAutos = TextEditingController();
  TextEditingController _pickcontroller = TextEditingController();

  var _dropDownValue;

  void onError(PlacesAutocompleteResponse? response) {
    homeScaffoldKey.currentState!.showSnackBar(
      SnackBar(content: Text(response!.errorMessage.toString())),
    );
  }

  refreshPage() {
    ridePageKey.currentState?.onRefresh();
  }

  Future<void> _handlePressButton({var location}) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        // mode: Mode.overlay,
        radius: 5000,
        types: [],
        strictbounds: false,
        region: "in",
        decoration: InputDecoration(
          hintText: 'Search',
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   borderSide: BorderSide(
          //     color: Colors.white,
          //   ),
          // ),
        ),
        components: [Component(Component.country, "in")]);
    print("data is " + p!.description.toString());
    displayPrediction(p, homeScaffoldKey.currentState, location);
    FocusScope.of(context).unfocus();
  }

  Future<Null> displayPrediction(
      Prediction? p, ScaffoldState? scaffold, var location) async {
    if (p != null) {
      // get detail (lat/lng)
      GoogleMapsPlaces _places = GoogleMapsPlaces(
        apiKey: kGoogleApiKey,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId.toString());
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      if (location == "start") {
        setState(() {
          _pickcontroller.text = p.description!;
          startPosition = LatLng(lat, lng);
        });
      } else {
        setState(() {
          // _Dropcontroller.text = p.description!;
          // endPosition = LatLng(lat,lng);
        });
      }

      //
      // setState(() {
      //
      // });

      // scaffold!.showSnackBar(
      //   SnackBar(content: Text("${p.description} - $lat/$lng")),
      // );
    }
  }

  Future<Null> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: _todaysDate,
        lastDate: DateTime.now().add(Duration(days: 60)));
    if (picked != null)
      setState(() {
        selectedStartDate = picked;
        StartDate = DateFormat("yyyy-MM-dd").format(picked);
        _setStartDate = DateFormat.yMd().format(selectedStartDate);
      });
  }

  Future<Null> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: _todaysDate,
        lastDate: DateTime.now().add(Duration(days: 60)));
    if (picked != null)
      setState(() {
        selectedEndDate = picked;
        EndDate = DateFormat("yyyy-MM-dd").format(picked);
        _setEndDate = DateFormat.yMd().format(selectedEndDate);
      });
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedStartTime = picked;
        StartTime = DateFormat("HH:mm:ss").format(DateTime(
            2019, 08, 1, selectedStartTime.hour, selectedStartTime.minute));
        Start_hour = selectedStartTime.hour.toString();
        Start_minute = selectedStartTime.minute.toString();
        Start_time = Start_hour! + ' : ' + Start_minute!;
        _setStartTime = Start_time;
        _setStartTime = formatDate(
            DateTime(
                2019, 08, 1, selectedStartTime.hour, selectedStartTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    print(_setStartTime);
    print(StartTime);
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        selectedEndTime = picked;
        EndTime = DateFormat("HH:mm:ss").format(DateTime(
            2019, 08, 1, selectedEndTime.hour, selectedEndTime.minute));
        End_hour = selectedEndTime.hour.toString();
        End_minute = selectedEndTime.minute.toString();
        End_time = End_hour! + ' : ' + End_minute!;
        _setEndTime = End_time;
        _setEndTime = formatDate(
            DateTime(2019, 08, 1, selectedEndTime.hour, selectedEndTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    print(_setEndTime);
    print(EndTime);
  }

  sendData() async {
    SharedPref pref = SharedPref();
    var userId = await pref.getUserId();
    var userName = await pref.getUsername();
    var data = await sendRentalData(
        startTime: StartTime,
        startDate: StartDate,
        userId: userId.toString(),
        entryBy: userId.toString(),
        updatedDateTime: DateTime.now().toIso8601String(),
        entryDateTime: DateTime.now().toIso8601String(),
        passengerName: customerName.text,
        passengerEmail: customerEmail.text,
        passengerPhone: customerMobileNumber.text,
        locationName: _pickcontroller.text,
        noOfAutos: 2);

    setState(() {
      customerMobileNumber.clear();
      customerEmail.clear();
      customerName.clear();
      _dropDownValue = null;
      _pickcontroller.clear();
    });
    refreshPage();
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 50,
            child: Center(child: Image.asset('assets/png/rent.png')),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: buildRadialGradient()
            ),
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text("Rent Us",style: GoogleFonts.raleway(fontWeight: FontWeight.w500),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
          ),
        ),
      ),
      body: buildBody(),
      backgroundColor: Color(0xffEEFDFF),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (isChecked == false) {
              showToast(message: "Please Accept Terms and condition");
            } else {
              FocusScope.of(context).requestFocus(FocusNode());
              if (_keyForm.currentState!.validate()) {
                // No any error in validation
                _keyForm.currentState!.save();
                sendData();
                showToast(message: "We will Contact You Soon on Call");
              } else {
                // validation error
                setState(() {
                  _validate = true;
                });
              }
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
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _keyForm,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StaggeredGrid.count( crossAxisCount: 3,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Color(0xffFAFBDE), //background color of box
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: .1, //extend the shadow
                          offset: Offset(
                            0.5, // Move to right 10  horizontally
                            0.5, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 1,child: Image.asset("assets/png/wedding.png")),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Wedding\nEvent",
                              style: GoogleFonts.poppins(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Color(0xffFAFBDE), //background color of box
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: .1, //extend the shadow
                          offset: Offset(
                            0.5, // Move to right 10  horizontally
                            0.5, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 1,child: Image.asset("assets/png/allday.png")),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "All Day\nEvent",
                              style: GoogleFonts.poppins(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                      color: Color(0xffFAFBDE), //background color of box
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: .1, //extend the shadow
                          offset: Offset(
                            0.5, // Move to right 10  horizontally
                            0.5, // Move to bottom 10 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 1,child: Image.asset("assets/png/socialevent.png")),
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Social\nEvent",
                              style: GoogleFonts.poppins(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],),

            SizedBox(
              height: 10,
            ),
            /*Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _selectStartDate(context);
                    },
                    child: _buildPickerbutton(
                      context,
                      _setStartDate == "" ? "Select Date" : _setStartDate,
                      "assets/svg/calenderForm.svg",
                      "Start Date",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _selectEndDate(context);
                    },
                    child: _buildPickerbutton(
                      context,
                      _setEndDate == "" ? "Select Date" : _setEndDate,
                      "assets/svg/calenderForm.svg",
                      "End Date",
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _selectStartTime(context);
                    },
                    child: _buildPickerbutton(
                      context,
                      _setStartTime == "" ? "Select Time" : _setStartTime,
                      "assets/svg/timeForm.svg",
                      "Start Time",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      _selectEndTime(context);
                    },
                    child: _buildPickerbutton(
                      context,
                      _setEndTime == "" ? "Select Time" : _setEndTime,
                      "assets/svg/timeForm.svg",
                      "End Time",
                    ),
                  ),
                ),
              ],
            ),*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextFormField(
                        validator: validateName,
                        controller: customerName,
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
                        controller: customerMobileNumber,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: 'Customer Mobile No.',
                          hintStyle: GoogleFonts.poppins(),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(20),
                          //   borderSide: const BorderSide(
                          //     width: 0,
                          //     style: BorderStyle.none,
                          //   ),
                          // ),
                          // filled: true,
                          // contentPadding: EdgeInsets.all(16),
                          // fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextFormField(
                        validator: validateEmail,
                        controller: customerEmail,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: TextFormField(
                        controller: event,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: 'Event',
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(20)),
                  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //     child: Center(
                  //       child: DropdownButtonHideUnderline(
                  //         child: DropdownButton(
                  //           hint: _dropDownValue == null
                  //               ? Text('No of Autos')
                  //               : Text(
                  //                   _dropDownValue.toString(),
                  //                 ),
                  //           // underline: Divider(thickness: .5,height: 0,color: Colors.black,),
                  //           isExpanded: true,
                  //           iconSize: 30.0,
                  //           items: List<int>.generate(12, (index) => index + 1)
                  //               .map(
                  //             (val) {
                  //               return DropdownMenuItem(
                  //                 value: val,
                  //                 child: Text(val.toString()),
                  //               );
                  //             },
                  //           ).toList(),
                  //           onChanged: (val) {
                  //             setState(
                  //               () {
                  //                 _dropDownValue = val;
                  //               },
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  /*Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLines: 3,
                        controller: _pickcontroller,
                        onTap: () {
                          _handlePressButton(location: "start");
                          FocusScope.of(context).unfocus();
                        },
                        style: GoogleFonts.poppins(
                            fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          contentPadding:
                              new EdgeInsets.symmetric(vertical: 0.0),
                          border: InputBorder.none,
                          hintText: "Pick Up Address",
                          labelText: "Pick Up Address",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                        // ListTile(
                        //   leading: SvgPicture.asset("assets/svg/Pick Up.svg"),
                        //   title: TextFormField(
                        //     maxLines: 3,
                        //     controller: _Pickcontroller,
                        //     onTap: (){_handlePressButton(location: "start");
                        //     FocusScope.of(context).unfocus();},
                        //     style:GoogleFonts.poppins(
                        //         fontSize: 15, fontWeight: FontWeight.w500),
                        //     decoration: InputDecoration(
                        //       contentPadding: new EdgeInsets.symmetric(vertical: 0.0),
                        //       border: InputBorder.none,
                        //       // labelText: "Pick Up Address",
                        //       hintText: "Pick Up Address",
                        //       hintStyle: GoogleFonts.poppins(
                        //           fontSize: 15, fontWeight: FontWeight.bold),),
                        //   ),
                        // ),
                        ),
                  ),*/
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Card(
                  //     child: Center(
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           children: [
                  //             SvgPicture.asset("assets/svg/Pick Up.svg"),
                  //             SizedBox(width: 20,),
                  //             Expanded(
                  //               child: TextFormField(
                  //                 maxLines: 3,
                  //                 controller: _pickcontroller,
                  //                 onTap: (){_handlePressButton(location: "start");
                  //                 FocusScope.of(context).unfocus();},
                  //                 style:GoogleFonts.poppins(
                  //                     fontSize: 15, fontWeight: FontWeight.w500),
                  //                 decoration: InputDecoration(
                  //                   contentPadding: new EdgeInsets.symmetric(vertical: 0.0),
                  //                   border: InputBorder.none,
                  //                   hintText: "Pick Up Address",
                  //                   labelText: "Pick Up Address",
                  //                   hintStyle: GoogleFonts.poppins(
                  //                       fontSize: 15, fontWeight: FontWeight.bold),),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //
                  //
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Card(
                  //     child: SizedBox(
                  //       height: 50,
                  //       width: MediaQuery.of(context).size.width,
                  //       child: ListTile(
                  //         leading: SvgPicture.asset("assets/svg/Pick Up.svg"),
                  //         title: TextFormField(
                  //           maxLines: 2,
                  //           controller: _Pickcontroller,
                  //           onTap: (){_handlePressButton(location: "start");
                  //           FocusScope.of(context).unfocus();},
                  //           style:GoogleFonts.poppins(
                  //               fontSize: 15, fontWeight: FontWeight.w500),
                  //           decoration: InputDecoration(
                  //             contentPadding: new EdgeInsets.symmetric(vertical: 0.0),
                  //             border: InputBorder.none,
                  //
                  //             hintText: "Pick Up Address",
                  //             hintStyle: GoogleFonts.poppins(
                  //                 fontSize: 15, fontWeight: FontWeight.bold),),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                thickness: 2,
              ),
            ),
            Row(
              children: [
                Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    }),
                Row(
                  children: [
                    Text(
                      'I Agreed to all the ',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.black),
                    ),
                    InkWell(
                      onTap: () async {
                        var _url =
                            "https://yatreedestination.com/Terms-of-Use.html";
                        if (!await launch(_url)) throw 'Could not launch $_url';
                      },
                      child: Text(
                        'T&C',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    Text(
                      ' for this ride',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildPickerbutton(BuildContext context, name, icon, title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 5.0),
          child: Text(
            title,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          height: 45,
          width: MediaQuery.of(context).size.width / 2.2,
          decoration: BoxDecoration(
            color: Colors.white, //background color of box
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2.0, // soften the shadow
                spreadRadius: .1, //extend the shadow
                offset: Offset(
                  0.5, // Move to right 10  horizontally
                  0.5, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(),
                ),
                SvgPicture.asset(icon)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
