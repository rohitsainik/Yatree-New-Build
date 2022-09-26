import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/place_picker.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yatree/Screens/booking/checkout.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/controller/tab_controller.dart';
import 'package:yatree/model/package/new_package_list.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/model/ride/ride_modle.dart';
import 'package:yatree/model/service/sightseeing.dart';
import 'package:yatree/model/service/spinaround_model.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/createBooking.dart';
import 'package:yatree/ui/packages/mapScreen.dart';
import 'package:yatree/utils/commonFunctions.dart';
import 'package:yatree/utils/sharedPreference.dart';
import 'package:yatree/utils/validation.dart';
import 'package:yatree/utils/widgets/gradient.dart';

import '../../Screens/perspective.dart';
import 'discount_page.dart';

class BookingPage extends StatefulWidget {
  BookingPage(
      {Key? key,
        this.price,
        this.packageid,
        this.packagePlaceMappingDetails,
        this.packagename,
        this.rideType,
        this.startLocation,
        this.subServiceId,
        this.serviceId,
        this.endLocation,
        this.endposition,
        this.startposition,
        this.packageData,
        this.placeData})
      : super(key: key);

  var price,
      packageid,
      packagename,
      rideType,
      startLocation,
      endLocation,
      startposition,
      subServiceId,
      serviceId,
      endposition;
  NewPackageList? packageData;
  List<ListPlaceMaster>? placeData;

  List<PackagePlaceMappingDetail>? packagePlaceMappingDetails = [];

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? _setTime = "", _setDate = "";
  int _totalChild = 0, _totalAdults = 1;

  String? _hour, _minute, _time;
  final GlobalKey<FormState> _keyForm = GlobalKey();
  bool _validate = false;
  bool isloading = false;
  late LandingPageController landingPageController;
  var coupon = "Apply Coupon";

  var totalAmount;

  var Time, Date, orderid, rideDetailIndex;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();
  Position? currentposition;
  bool isChecked = false;
  var startPosition, endPosition;

  var username, userid;
  Position? currentLocation;
  var discountId = 0;
  TextEditingController personName = TextEditingController();
  TextEditingController personMobileNumber = TextEditingController();
  TextEditingController personEmail = TextEditingController();
  TextEditingController noOfTravellers = TextEditingController();
  TextEditingController _Pickcontroller = TextEditingController();

  var _todaysDate = DateTime.now();
  int test = 1;

  bool driverAvailable = false;
  int driverCount = 0;

  _getData() async {
    setState(() {
      totalAmount = widget.packageData?.createCustomerPackages?.price;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _getPlace(position.latitude, position.longitude);

    SharedPref pref = SharedPref();
    var userId = await pref.getUserId();
    var userName = await pref.getUsername();
    setState(() {
      currentposition = position;

      username = userName;
      userid = userId;
    });
    checkDriverAvailability();
    print(userid);
  }

  _getPlace(lat, long) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(lat, long);

    // this is all you need
    Placemark placeMark = newPlace[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String? postalCode = placeMark.postalCode;
    String? country = placeMark.country;
    String? address =
        "${name}, ${subLocality}, ${locality}, ${administrativeArea}";

    print(address);

    setState(() {
      _Pickcontroller.text = address;
      startPosition = LatLng(lat, long);
      // update _address
    });
  }

  @override
  void initState() {
    print("Price Is ${widget.packageData?.createCustomerPackages?.price}");
    _getData();
    setState(() {
      Time = DateFormat("HH:mm:ss").format(
          DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute));

      Date = DateFormat("yyyy-MM-dd").format(selectedDate);
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  var _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("success : " + response.toString());
    print("order id : " + response.orderId.toString());
    print("payment id : " + response.paymentId.toString());
    await makeBooking(paymentType: 2);
    createTransaction(
      orderId: orderid,
      transactionid: response.paymentId,
      amount: widget.packageData?.createCustomerPackages?.price,
      paymentType: "online",
      transactionDateTime:
      DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      entryBy: "$userid",
      entryDateTime: DateTime.now().toUtc().toIso8601String(),
      updatedDateTime: DateTime.now().toUtc().toIso8601String(),
    );
    showToast(message: "Payment Successfull");
    Get.back();
    // Get.off(() => PerspectivePage());
    Get.offAll(() => PerspectivePage());
    ridePageKey.currentState?.onRefresh();
    landingPageController.tabIndex.value = 0;
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("error : " + response.toString());
    setState(() {
      isloading = false;
    });
  }

  createOrder({var amount, email}) async {
    var orderOptions = {
      'amount': amount,
      'currency': "INR",
      'receipt': "order_rcptid_$amount"
    };
    final client = HttpClient();
    final request =
    await client.postUrl(Uri.parse('https://api.razorpay.com/v1/orders'));
    request.headers
        .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
    String basicAuth = 'Basic ' +
        base64Encode(
            utf8.encode('${AppStrings.test_key}:${AppStrings.test_secret}'));
    request.headers.set(HttpHeaders.authorizationHeader, basicAuth);
    request.add(utf8.encode(json.encode(orderOptions)));
    final response = await request.close();
    await response.transform(utf8.decoder).listen((contents) {
      print('ORDERID' + contents);
      String orderId = contents.split(',')[0].split(":")[1];
      orderId = orderId.substring(1, orderId.length - 1);
      var options = {
        "key": AppStrings.test_key,
        "amount": double.parse(amount.toString()),
        "currency": "INR",
        'order_id': orderId,
        "auto_captured": "1",
        "prefill": {
          "contact": personMobileNumber.text,
          "email": personEmail.text
        },
      };
      try {
        _razorpay.open(options);
      } catch (e) {
        print(e.toString());
      }
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("wallet : " + response.toString());
    setState(() {
      isloading = false;
    });
  }

  // void _createOrder({var amount, email}) async {
  //   var body = {
  //     "key": AppStrings.live_key,
  //     "amount": double.parse(amount.toString()),
  //     "currency": "INR",
  //     "auto_captured":"1",
  //     "order_id":"order_123dr",
  //     "prefill": {"contact": personMobileNumber.text, "email": email},
  //   };
  //   _razorpay.open(body);
  // }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        // selectableDayPredicate: (day) {
        //   var isAvailable = true;
        //   print(test++);
        //   if(test % 4 == 0){
        //     _checkAvailibility(day).then((value) {
        //       setState(() {
        //         isAvailable = value;
        //         if (!value) {
        //           showToast(message: "Driver not available");
        //         }
        //       });
        //     });
        //   }
        //   return isAvailable;
        // },
        firstDate: _todaysDate,
        lastDate: DateTime.now().add(Duration(days: 2)));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        checkDriverAvailability();
        Date = DateFormat("yyyy-MM-dd").format(picked);
        _setDate = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        checkDriverAvailability();
        selectedTime = picked;
        Time = DateFormat("HH:mm:ss").format(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute));
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _setTime = _time;
        _setTime = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    print(_setTime);
    print(Time);
  }

  increment({var type}) {
    if (type == "A") {
      if (_totalAdults < 2) {
        setState(() {
          _totalAdults += 1;
        });
      }
    } else {
      if (_totalChild < 1) {
        setState(() {
          _totalChild += 1;
        });
      }
    }
  }

  decrement({var type}) {
    if (type == "A") {
      if (_totalAdults > 1) {
        setState(() {
          _totalAdults -= 1;
        });
      }
    } else {
      if (_totalChild > 0) {
        setState(() {
          _totalChild -= 1;
        });
      }
    }
  }

  makeBooking({var paymentType}) async {
    print("coverted" + DateTime.now().toUtc().toIso8601String());
    var data = await setBookingData(
      packageId: widget.packageData?.createCustomerPackages?.id,
      time: Time,
      /*widget.rideType == "1"
          ? Time
          : DateFormat("HH:mm:ss").format(DateTime.now()),*/
      date: Date,
      /*widget.rideType == "1"
          ? Date
          : DateFormat("yyyy-MM-dd").format(DateTime.now()),*/
      totalAdult: int.parse(noOfTravellers.text),
      totalChild: int.parse(_totalChild.toString()),
      basePrice: double.parse(
          widget.packageData?.createCustomerPackages?.price?.toString() ?? ""),
      tax:
          "${double.parse(widget.packageData?.createCustomerPackages?.price.toString() ?? '') * .18} ",

      // double.parse((widget.packageData?.createCustomerPackages?.price.toString() ?? "" * .18).toString()),
      discountId: discountId,
      totalAmount: double.parse(
          widget.packageData?.createCustomerPackages?.price?.toString() ?? ""),
      status: 1,
      userId: userid.toString(),
      entryBy: userid.toString(),
      updatedDateTime: DateTime.now().toIso8601String(),
      entryDateTime: DateTime.now().toIso8601String(),
      // personName: "rohits",
      // personEmail: "rssf@gma.com",
      // personmobileNumber: "9880283188",
    );

    var value = await setCustomDetailData(
        passengerEmail: personEmail.text,
        passengerName: personName.text,
        passengerPhone: personMobileNumber.text,
        updatedDateTime: DateTime.now().toIso8601String(),
        bookingId: data["createBookingMaster"]["id"],
        entryBy: data["createBookingMaster"]["entryBy"],
        entryDateTime: data["createBookingMaster"]["entryDateTime"],
        tax: data["createBookingMaster"]["tax"],
        discountId: data["createBookingMaster"]["discountId"],
        status: data["createBookingMaster"]["status"],
        userId: data["createBookingMaster"]["userId"],
        totalAmount: data["createBookingMaster"]["totalAmount"]);

    var orderdata = await createOrderMaster(
      bookingId: data["createBookingMaster"]["id"],
      status: data["createBookingMaster"]["status"],
      enterBy: data["createBookingMaster"]["entryBy"],
      entryDateTime: data["createBookingMaster"]["entryDateTime"],
      updateTime: DateTime.now().toIso8601String(),
    );

    // var isDriver = await isDriverAvailable(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()));
    //
    // print(isDriver);

    var ridedata = await generateRide(
      bookingId: data["createBookingMaster"]["id"],
      userId: data["createBookingMaster"]["userId"],
      rideType: widget.rideType,
      rideStartDateTime:
          widget.rideType == "2" ? DateTime.now().toIso8601String() : null,
      status: 3,
      startLocationlat: widget.rideType == "2"
          ? widget.startposition.latitude
          : startPosition.latitude,
      startLocationlong: widget.rideType == "2"
          ? widget.startposition.longitude
          : startPosition.longitude,
      endLocationlat: widget.rideType == "2"
          ? widget.endposition.latitude
          : startPosition.latitude,
      enLocdationlong: widget.rideType == "2"
          ? widget.endposition.longitude
          : startPosition.longitude,
      startLocationName: widget.rideType == "2" ? widget.startLocation : "",
      endLocationName: widget.rideType == "2" ? widget.endLocation : "",
    );
    var ridestatus;
    setState(() {
      ridestatus = ridedata;
      print(
          "'------------------------------order id $orderid ----------------------");
      orderid = orderdata["createOrderMaster"]["id"];
    });

    RideModel rides = await getUserRide(customerId: "${userid}");
    setState(() {
      rideDetailIndex = rides.getUserRides!.indexWhere((element) =>
          element.bookingId ==
          orderdata["createOrderMaster"]["bookingId"].toString());
    });

    print("index is " +
        "${rides.getUserRides!.indexWhere((element) => element.bookingId == orderdata["createOrderMaster"]["bookingId"].toString())}");
    /*if (widget.rideType == "2" || paymentType == 1) {
      if (ridedata) {
        createTransaction(
          orderId: orderid,
          transactionid: "",
          amount: widget.price,
          paymentType: "offline",
          transactionDateTime:
          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
          entryBy: "$userid",
          entryDateTime: DateTime.now().toUtc().toIso8601String(),
          updatedDateTime: DateTime.now().toUtc().toIso8601String(),
        );
        Get.back();
        Get.to(()=>BookingConfirm(ridesdata: rides.getUserRides![rideDetailIndex],));

        showToast(message: "Booking Confirmed");
      } else {
        showToast(message: "Auto not available for selected Date ");
      }
    } else {
      if (ridedata) {
        _createOrder(amount: widget.price * 100, email: username);
      } else {
        showToast(message: "Auto not available for selected Date ");
      }
    }*/

    setState(() {
      isloading = false;
    });

// Get.to(()=>BookingConfirm());
  }

  void onError(PlacesAutocompleteResponse? response) {
    showToast(message: response!.errorMessage.toString());
    // homeScaffoldKey.currentState!.(
    //   SnackBar(content: Text(response!.errorMessage.toString())),
    // );
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              kGoogleApiKey,
              displayLocation: startPosition,
            )));

    // Handle the result in your way
    print("result");
    print(result);
  }

  Future<void> _handlePressButton({var location}) async {
    // show input autocomplete with selected mode
    // then get the Prediction selected

    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: Mode.overlay,
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
          _Pickcontroller.text = p.description!;
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

  @override
  Widget build(BuildContext context) {
    landingPageController = Get.put(LandingPageController(), permanent: false);
    return Scaffold(
      backgroundColor: Color(0xffEEFDFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 50,
            child: Center(
                child: SvgPicture.asset(
              'assets/svg/checkout.svg',
              fit: BoxFit.fill,
            )),
            decoration: BoxDecoration(
                shape: BoxShape.circle, gradient: buildRadialGradient()),
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text(
          "Booking Page",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
        ),
      ),
      body: newBuildBody(),
    );
    /*return Scaffold(
      appBar: widget.rideType == "2"
          ? AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            )
          : null,
      backgroundColor: Color(0xffF1F1F1),
      body: buildBody(context),
      bottomNavigationBar: Container(
        height: 60,
        child: Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () {
                if (isChecked == false) {
                  showToast(message: "Please Accept Terms and condition");
                } else {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_keyForm.currentState!.validate()) {
                    // No any error in validation
                    _keyForm.currentState!.save();
                    if (widget.rideType == "2") {
                      setState(() {
                        isloading = true;
                      });
                      makeBooking(paymentType: 1);
                    } else {
                      if (Date == null) {
                        showToast(message: "Please select date");
                      } else if (Time == null) {
                        showToast(message: "Please select Time");
                      } else if (_Pickcontroller.text.isEmpty) {
                        showToast(message: "Please select Pick up Location");
                      } else {
                        setState(() {
                          isloading = true;
                        });
                        // makeBooking(paymentType: 2);
                        // showBottomSheet(context);
                        if (driverAvailable) {
                          _createOrder(
                              amount:
                                  (widget.price + (widget.price * .18)) * 100,
                              email: username);
                        } else {
                          showToast(
                              message: "Auto not available for selected Date ");
                          setState(() {
                            isloading = false;
                          });
                        }
                      }
                    }
                  } else {
                    // validation error
                    setState(() {
                      _validate = true;
                    });
                  }
                }

                // Time Date personName personMobileNumber personEmail
              },
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: isChecked ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.rideType == "2"
                          ? "Book Now"
                          : "Book Now ( Rs. ${totalAmount + (widget.price * .18)} )",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );*/
  }

  newBuildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              width: Get.width,
              height: Get.height,
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
                          controller: personName,
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
                          controller: personMobileNumber,
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
                          controller: personEmail,
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
                          validator: validateTraveller,
                          controller: noOfTravellers,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Number of Travellers',
                            hintStyle: GoogleFonts.poppins(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: _buildPickerbutton(
                                  context,
                                  DateFormat.yMd().format(selectedDate),
                                  "assets/svg/calendar.svg"),
                            )),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                _selectTime(context);
                              },
                              child: _buildPickerbutton(
                                context,
                                formatDate(
                                    DateTime(2019, 08, 1, selectedTime.hour,
                                        selectedTime.minute),
                                    [hh, ':', nn, " ", am]).toString(),
                                "assets/svg/hourglass.svg",
                              ),
                            )),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        /*if (isChecked == false) {
                          showToast(message: "Please Accept Terms and condition");
                        } else {*/
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_keyForm.currentState!.validate()) {
                          // No any error in validation
                          _keyForm.currentState!.save();
                          if (Date == null) {
                            showToast(message: "Please select date");
                          } else if (Time == null) {
                            showToast(message: "Please select Time");
                          }
                          /*else if (_Pickcontroller.text.isEmpty) {
                            showToast(
                                message: "Please select Pick up Location");
                          }*/
                          else {
                            setState(() {
                              isloading = true;
                            });
                            // makeBooking(paymentType: 2);
                            // showBottomSheet(context);
                            if (driverAvailable) {
                              Get.to(() => Checkout(
                                listPlaceMasters: widget.placeData,
                                packageid:widget.packageData?.createCustomerPackages?.id,
                                onBookNow: createOrder,
                                price: widget.price,
                                username: username,));
                            } else {
                              showToast(
                                  message:
                                  "Auto not available for selected Date ");
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        } else {
                          // validation error
                          setState(() {
                            _validate = true;
                          });
                        }
                        // }
                      },
                      child: isloading
                          ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: Center(child: CircularProgressIndicator()))
                          : Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: GoogleFonts.raleway(
                                      color: Colors.white),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.redAccent,
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SingleChildScrollView(
          child: Form(
            key: _keyForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.rideType == "1"
                    ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "${AppStrings.imageUrl}${widget.packagePlaceMappingDetails![0].imageLocation}"),
                              fit: BoxFit.cover)),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          // color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      "${widget.packagename}",
                      style: GoogleFonts.poppins(
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
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
                    Positioned(
                      left: 5,
                      top: 30,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                  ],
                )
                    : Container(),
                SizedBox(
                  height: 20,
                ),
                widget.rideType == "1"
                    ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: _buildPickerbutton(
                          context,
                          DateFormat.yMd().format(selectedDate),
                          "assets/svg/calenderForm.svg"),
                    ))
                    : Container(),
                widget.rideType == "1"
                    ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: _buildPickerbutton(
                        context,
                        formatDate(
                            DateTime(2019, 08, 1, selectedTime.hour,
                                selectedTime.minute),
                            [hh, ':', nn, " ", am]).toString(),
                        "assets/svg/timeForm.svg",
                      ),
                    ))
                    : Container(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      driverAvailable && driverCount > 1
                          ? "$driverCount Auto available"
                          : driverAvailable
                          ? "$driverCount Auto available"
                          : "No Auto available on selected date",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Child",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 45,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white, //background color of box
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0, // soften the shadow
                                    spreadRadius: .1, //extend the shadow
                                    offset: Offset(
                                      1.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        decrement(type: "b");
                                      },
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.blue,
                                      )),
                                  Text(_totalChild.toString()),
                                  IconButton(
                                      onPressed: () {
                                        increment(type: "b");
                                      },
                                      icon: Icon(
                                        Icons.add_circle_outline_outlined,
                                        color: Colors.blue,
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Adult",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 45,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white, //background color of box
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0, // soften the shadow
                                    spreadRadius: .1, //extend the shadow
                                    offset: Offset(
                                      1.0, // Move to right 10  horizontally
                                      1.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        decrement(type: "A");
                                      },
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.blue,
                                      )),
                                  Text(_totalAdults.toString()),
                                  IconButton(
                                      onPressed: () {
                                        increment(type: "A");
                                      },
                                      icon: Icon(
                                        Icons.add_circle_outline_outlined,
                                        color: Colors.blue,
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '*Children below 5 year age',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
                Container(
                  child: Column(
                    children:
                    List.generate(_totalChild + _totalAdults, (index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Passenger 1",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: TextFormField(
                                    validator: validateName,
                                    controller: personName,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      hintText: 'Passenger Name',
                                      hintStyle: GoogleFonts.poppins(),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      filled: true,
                                      contentPadding: EdgeInsets.all(16),
                                      fillColor: Colors.white,
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
                                    controller: personMobileNumber,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: 'Passenger Mobile No.',
                                      hintStyle: GoogleFonts.poppins(),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      filled: true,
                                      contentPadding: EdgeInsets.all(16),
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: TextFormField(
                                    validator: validateEmail,
                                    controller: personEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Passenger Email',
                                      hintStyle: GoogleFonts.poppins(),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: const BorderSide(
                                          width: 0,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                      filled: true,
                                      contentPadding: EdgeInsets.all(16),
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Passenger ${index + 1}",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 45,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    //background color of box
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0, // soften the shadow
                                        spreadRadius: .1, //extend the shadow
                                        offset: Offset(
                                          1.0, // Move to right 10  horizontally
                                          1.0, // Move to bottom 10 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                          border: OutlineInputBorder(
                                            // width: 0.0 produces a thin "hairline" border
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                            borderSide: BorderSide.none,
                                            //borderSide: const BorderSide(),
                                          ),
                                          hintStyle: GoogleFonts.poppins(),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: 'Passenger Name'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    var result = Get.to(DiscountPage(
                      packageId: widget.packageData?.createCustomerPackages?.id,
                      serviceId: 4,
                      subServiceId: 7,
                      locationLatitude: 0.0,
                      locationLongitude: 0.0,
                      bookingDate: '2021-11-01',
                    ));
                    result!.then((value) {
                      print(value.couponCode.toString());
                      setState(() {
                        if (value != null) {
                          coupon = value.couponCode.toString();
                          discountId = value.id;
                          if (value.amountType == 1) {
                            totalAmount = widget.price - value.amount;
                          } else if (value.amountType == 2) {
                            totalAmount = widget.price -
                                ((widget.price * value.amount) / 100);
                          }
                        } else {
                          discountId = 0;
                          coupon = "Apply Coupon";
                          totalAmount = widget.price;
                        }
                      });
                    });
                  },
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ListTile(
                        leading: Icon(Icons.local_offer_rounded),
                        title: Text(
                          coupon,
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    ),
                  ),
                ),
                widget.rideType == "2"
                    ? Container()
                    : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          // maxLines: 3,
                          controller: _Pickcontroller,
                          onTap: () {
                            //_handlePressButton(location: "start");
                            showPlacePicker();
                            FocusScope.of(context).unfocus();
                          },
                          style: GoogleFonts.poppins(
                              fontSize: 15, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            contentPadding:
                            new EdgeInsets.symmetric(vertical: 0.0),
                            border: InputBorder.none,
                            labelText: "Pick Up Address",
                            hintText: "Pick Up Address",
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
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Ride Break-up',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                widget.rideType == "1"
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      widget.packagePlaceMappingDetails!.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'L${index + 1} : ${widget.packagePlaceMappingDetails![index].placeName} : ${widget.packagePlaceMappingDetails![index].duration} Minutes',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    );
                  }),
                )
                    : Column(
                  children: [
                    ListTile(
                      leading: SvgPicture.asset("assets/svg/Pick Up.svg"),
                      title: Text(
                        '${widget.startLocation}',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: SvgPicture.asset("assets/svg/drop.svg"),
                      title: Text(
                        '${widget.endLocation}',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    )
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text('L1 : Fatehsagar : 45 Minutes',style: GoogleFonts.poppins(fontSize: 16),),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text('L1 : Fatehsagar : 45 Minutes',style: GoogleFonts.poppins(fontSize: 16),),
                // ),
                Row(
                  children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        }),
                    InkWell(
                      onTap: () async {
                        var _url =
                            "https://yatreedestination.com/Terms-of-Use.html";
                        if (!await launch(_url)) throw 'Could not launch $_url';
                      },
                      child: Row(
                        children: [
                          Text(
                            'I Agreed to all the ',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            'T&C',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.blueAccent,
                            ),
                          ),
                          Text(
                            ' for this ride',
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        isloading == true
            ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.transparent,
            child: Center(child: CircularProgressIndicator()))
            : Container()
      ],
    );
  }

  _buildPickerbutton(BuildContext context, name, icon) {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
        color: Colors.white, //background color of box
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0, // soften the shadow
            spreadRadius: .1, //extend the shadow
            offset: Offset(
              1.0, // Move to right 10  horizontally
              1.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(icon),
            Text(
              name,
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
      ),
    );
  }

  showBottomSheet(var context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Pay Online'),
            onPressed: () {
              // makeBooking(paymentType: 2);
              if (driverAvailable) {
                createOrder(amount: widget.price * 100, email: username);
              } else {
                showToast(message: "Auto not available for selected Date ");
              }
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Pay via Cash'),
            onPressed: () {
              makeBooking(paymentType: 1);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Future _checkAvailibility(DateTime day) async {
    return await isDriverAvailable(
        DateFormat("yyyy-MM-dd HH:mm:ss").format(day));
  }

  void checkDriverAvailability() async {
    var driverAvailableonSelectedDate = await _checkAvailibility(DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute));
    if (driverAvailableonSelectedDate > 0) {
      setState(() {
        driverAvailable = true;
        driverCount = driverAvailableonSelectedDate;
      });
    } else {
      driverAvailable = false;
      driverCount = 0;
    }
  }
}
