import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yatree/Screens/Login/signUp.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/services/registrationFunction.dart';
import 'package:yatree/utils/commonFunctions.dart';
import 'package:yatree/utils/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool isLoading = false;
  bool isLoadingOTP = false;
  bool isLoadingLogin = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool phoneLogin = false;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  //var Otp;
  bool canResend = false;
  bool timerStarted = false;
  bool sendOPT = false;

  late Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            canResend = true;
            timerStarted = false;
            _start = 60;
          });
        } else {
          setState(() {
            timerStarted = true;
            _start--;
          });
        }
      },
    );
  }

  // TextEditingController textEditingController1 = new TextEditingController();
  // String _comingSms = 'Unknown';
  //
  // Future<void> initSmsListener() async {
  //   String? comingSms;
  //   try {
  //     comingSms = await AltSmsAutofill().listenForSms;
  //   } on PlatformException {
  //     comingSms = 'Failed to get Sms.';
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _comingSms = comingSms!;
  //     print("====>Message: ${_comingSms}");
  //     print("${_comingSms[32]}");
  //     textEditingController1.text = _comingSms[32] +
  //         _comingSms[33] +
  //         _comingSms[34] +
  //         _comingSms[35] +
  //         _comingSms[36] +
  //         _comingSms[
  //             37]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
  //   });
  // }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    //AltSmsAutofill().unregisterListener();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/png/loginbg.webp",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: new Container(
                    decoration:
                        new BoxDecoration(color: Colors.white.withOpacity(0.1)),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/logo/yatree_logo.png"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(60),
                              // boxShadow: [
                              //   BoxShadow(
                              //       color: Colors.grey.shade500,
                              //       blurRadius: 5)
                              // ]
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Yatree\nDestination",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              shadows: <Shadow>[
                                Shadow(
                                    offset: Offset(1.0, 1.0),
                                    blurRadius: 8.0,
                                    color: Colors.black87),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: !sendOPT
                          ? MediaQuery.of(context).size.height * 0.4
                          : MediaQuery.of(context).size.height * 0.43,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
                              child: phoneLogin
                                  ? Form(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 8),
                                            child: TextFormField(
                                              keyboardType: TextInputType.phone,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                              controller: phoneController,
                                              decoration: new InputDecoration(
                                                  fillColor: Colors.black
                                                      .withOpacity(0.6),
                                                  focusColor: Colors
                                                      .black
                                                      .withOpacity(0.6),
                                                  border: OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  isDense: true,
                                                  prefixIcon: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        child: Icon(
                                                          Icons.phone,
                                                          color: Colors.black,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                  filled: true,
                                                  hintStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                  labelText: 'Phone Number',
                                                  labelStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                  counterText: ""),
                                              maxLength: 50,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: !timerStarted
                                                      ? Colors.green
                                                      : Colors.grey,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (phoneController
                                                          .text.length ==
                                                      10) {
                                                    startTimer();
                                                    signUpPhone(
                                                        phoneNo: phoneController
                                                            .text);
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    setState(() {
                                                      sendOPT = true;
                                                    });
                                                    //initSmsListener;
                                                  } else {
                                                    showToast(
                                                        message:
                                                            "Enter valid phone number");
                                                  }
                                                },
                                                child: Container(
                                                  height: 45,
                                                  width: 270,
                                                  child: Center(
                                                      child: isLoadingOTP
                                                          ? SizedBox(
                                                              height: 20.0,
                                                              width: 20.0,
                                                              child: CircularProgressIndicator(
                                                                  valueColor:
                                                                      AlwaysStoppedAnimation(
                                                                          Colors
                                                                              .white),
                                                                  strokeWidth:
                                                                      2.0))
                                                          : Text(
                                                              timerStarted
                                                                  ? "00:${_start.toString().padLeft(2, "0")}"
                                                                  : canResend
                                                                      ? "Resend OTP"
                                                                      : AppStrings
                                                                          .sOtpButton,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                      color: Colors
                                                                          .white),
                                                            )),
                                                )),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          sendOPT
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  child: Center(
                                                    child: PinCodeTextField(
                                                      appContext: context,
                                                      pastedTextStyle:
                                                          TextStyle(
                                                        color: Colors
                                                            .green.shade600,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      length: 6,
                                                      // obscureText: true,
                                                      // obscuringCharacter: '*',
                                                      // obscuringWidget:
                                                      //     const FlutterLogo(
                                                      //   size: 24,
                                                      // ),
                                                      // validator: (v) {
                                                      //   if (v!.length < 3) {
                                                      //     return "Invalid OTP";
                                                      //   } else {
                                                      //     return null;
                                                      //   }
                                                      // },
                                                      blinkWhenObscuring: true,
                                                      animationType:
                                                          AnimationType.fade,
                                                      pinTheme: PinTheme(
                                                          shape: PinCodeFieldShape
                                                              .box,
                                                          selectedColor:
                                                              Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          fieldHeight: 50,
                                                          fieldWidth: 40,
                                                          activeFillColor:
                                                              Colors.white,
                                                          selectedFillColor:
                                                              Colors
                                                                  .transparent,
                                                          inactiveFillColor:
                                                              Colors
                                                                  .transparent,
                                                          activeColor:
                                                              Colors.green,
                                                          inactiveColor:
                                                              Colors.white38),
                                                      cursorColor: Colors.black,
                                                      animationDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  300),
                                                      enableActiveFill: true,
                                                      errorAnimationController:
                                                          errorController,
                                                      controller: otpController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      boxShadows: const [
                                                        BoxShadow(
                                                          offset: Offset(0, 1),
                                                          color: Colors.black12,
                                                          blurRadius: 10,
                                                        )
                                                      ],
                                                      onCompleted: (v) {
                                                        debugPrint("Completed");
                                                      },
                                                      // onTap: () {
                                                      //   print("Pressed");
                                                      // },
                                                      onChanged: (value) {
                                                        debugPrint(value);
                                                        setState(() {
                                                          currentText = value;
                                                        });
                                                      },
                                                      beforeTextPaste: (text) {
                                                        debugPrint(
                                                            "Allowing to paste $text");
                                                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                                        return true;
                                                      },
                                                    ),
                                                    // OTPTextField(
                                                    //   length: 6,
                                                    //   width: MediaQuery.of(context)
                                                    //       .size
                                                    //       .width,
                                                    //   fieldWidth: 40,
                                                    //   otpFieldStyle: OtpFieldStyle(
                                                    //       enabledBorderColor:
                                                    //           Colors.white,
                                                    //       disabledBorderColor:
                                                    //           Colors.white,
                                                    //       borderColor: Colors.white),
                                                    //   style: TextStyle(
                                                    //       color: Colors.white,
                                                    //       fontSize: 13),
                                                    //   outlineBorderRadius: 0,
                                                    //   textFieldAlignment:
                                                    //       MainAxisAlignment
                                                    //           .spaceAround,
                                                    //   fieldStyle: FieldStyle.box,
                                                    //   onCompleted: (pin) {
                                                    //     setState(() {
                                                    //       Otp = pin;
                                                    //     });
                                                    //     print("Completed: " + pin);
                                                    //   },
                                                    // ),
                                                  ),
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: sendOPT ? 10 : 0,
                                          ),
                                          sendOPT
                                              ? GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      isLoadingLogin = true;
                                                    });
                                                    var isloading =
                                                        await confirmPhoneSignIn(
                                                            confirmationCode:
                                                                currentText);
                                                    setState(() {
                                                      isLoadingLogin =
                                                          isloading;
                                                    });
                                                    // confirmSignUp(email: "+91"+phoneController.text,confirmationCode:Otp );
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width: 230,
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Center(
                                                        child: isLoadingLogin
                                                            ? SizedBox(
                                                                height: 20.0,
                                                                width: 20.0,
                                                                child: CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation(Colors
                                                                            .white),
                                                                    strokeWidth:
                                                                        2.0))
                                                            : Text(
                                                                AppStrings
                                                                    .otpButton,
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15),
                                                              )),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    )
                                  : Form(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 8),
                                            child: TextFormField(
                                              validator: validateEmail,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                              controller: _emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: new InputDecoration(
                                                  fillColor: Colors.black
                                                      .withOpacity(0.6),
                                                  focusColor: Colors
                                                      .black
                                                      .withOpacity(0.6),
                                                  border: OutlineInputBorder(
                                                    borderSide: new BorderSide(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  // enabledBorder: OutlineInputBorder(
                                                  //   borderSide:
                                                  //       BorderSide(color: Colors.white),
                                                  // ),
                                                  isDense: true,
                                                  prefixIcon: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        child: Icon(
                                                          Icons.email,
                                                          color: Colors.black,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      25)),
                                                  filled: true,
                                                  hintStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                  labelText: 'Email Address ',
                                                  labelStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                  counterText: ""),
                                              maxLength: 50,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 8),
                                            child: TextFormField(
                                              validator: validatePassword,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                              controller: _passwordController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              obscureText: _obscureText,
                                              decoration: new InputDecoration(
                                                  fillColor: Colors.black
                                                      .withOpacity(0.6),
                                                  focusColor: Colors.black
                                                      .withOpacity(0.6),
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          new BorderSide(
                                                              color:
                                                                  Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                  // enabledBorder: OutlineInputBorder(
                                                  //   borderSide:
                                                  //       BorderSide(color: Colors.white),
                                                  // ),
                                                  prefixIcon: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                        child: Icon(
                                                          Icons.lock,
                                                          color: Colors.black,
                                                          size: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  isDense: true,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  filled: true,
                                                  hintStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                  labelText: 'Password ',
                                                  labelStyle: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.white),
                                                  counterText: ""),
                                              maxLength: 50,
                                            ),
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Checkbox(
                                          //       value: _checkbox,
                                          //       onChanged: (value) {
                                          //         _checkbox = value;
                                          //         setState(() {
                                          //           if (value == true) {
                                          //             _obscureText = false;
                                          //           } else {
                                          //             _obscureText = true;
                                          //           }
                                          //         });
                                          //         // print(value);
                                          //         // _toggle(value);
                                          //       },
                                          //       side: BorderSide(color: Colors.white),
                                          //     ),
                                          //     Text(
                                          //       AppStrings.shPassword,
                                          //       style: GoogleFonts.poppins(
                                          //           color: Colors.white),
                                          //     )
                                          //   ],
                                          // ),
                                          SizedBox(height: 20),
                                          GestureDetector(
                                            onTap: () async {
                                              if (isLoading) {
                                                return null;
                                              } else {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                var Loading = await signIn(
                                                    email:
                                                        _emailController.text,
                                                    password:
                                                        _passwordController
                                                            .text);

                                                setState(() {
                                                  isLoading = Loading;
                                                });
                                              }
                                            },
                                            child: Container(
                                              height: 45,
                                              width: 270,
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                  child: isLoading
                                                      ? SizedBox(
                                                          height: 20.0,
                                                          width: 20.0,
                                                          child: CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      Colors
                                                                          .white),
                                                              strokeWidth: 2.0))
                                                      : Text(
                                                          AppStrings
                                                              .loginButton,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white),
                                                        )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white38,
                                  ),
                                  child: Text(
                                    "Other signin options",
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 14,
                                      shadows: <Shadow>[
                                        Shadow(
                                            offset: Offset(0.5, 0.5),
                                            blurRadius: 2.0,
                                            color: Colors.black38),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          phoneLogin = !phoneLogin;
                                        });
                                        //Get.to(() => loginWithPhone());
                                        // signUpPhone();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    phoneLogin
                                                        ? Icons.email
                                                        : Icons.phone,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        signInWithGoogle(context: context);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          // color: Colors.red,
                                          gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFFea4335),
                                                const Color(0xFFfbbc05),
                                                const Color(0xFF34a853),
                                                const Color(0xFF4285f4),
                                              ],
                                              begin: const FractionalOffset(
                                                  0.0, 0.0),
                                              end: const FractionalOffset(
                                                  1.0, 0.0),
                                              stops: [0.0, 0.3, 0.9, 1.0],
                                              tileMode: TileMode.clamp),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/png/googlelogo.png",
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        signInWitApple(context: context);
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 35,
                                              width: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/png/apple.png",
                                                    height: 20,
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black54,
                                ),
                                child: Text(
                                  "Don't have an Account",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 14,
                                    shadows: <Shadow>[
                                      Shadow(
                                          offset: Offset(0.5, 0.5),
                                          blurRadius: 3.0,
                                          color: Colors.grey.shade500),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => SignUpScreen());
                                },
                                child: Container(
                                  height: 45,
                                  width: 260,
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrangeAccent,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                      child: Text(
                                    AppStrings.signup,
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
