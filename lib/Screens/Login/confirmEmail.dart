import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/services/registrationFunction.dart';
import 'package:yatree/utils/commonFunctions.dart';

class ConfirmEmail extends StatefulWidget {
  final String email;
  final String password;
  const ConfirmEmail({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  var isLoading = false;
  TextEditingController otpController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Stack(
            children: [
              BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/png/phone.webp"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.22,
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
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 35),
                            child: Form(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "Please Enter Confirmation Code",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        shadows: <Shadow>[
                                          Shadow(
                                              offset: Offset(1.0, 1.0),
                                              blurRadius: 8.0,
                                              color: Colors.black87),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 25),
                                  otp(context),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (isLoading) {
                                        return null;
                                      } else {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        var Loading;
                                        if (currentText != "") {
                                          Loading = await confirmSignUp(
                                              email: widget.email,
                                              password: widget.password,
                                              confirmationCode: currentText);
                                          setState(() {
                                            isLoading = Loading;
                                          });
                                        } else {
                                          showToast(message: "OTP required");
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: 45,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                          child: isLoading
                                              ? SizedBox(
                                                  height: 20.0,
                                                  width: 20.0,
                                                  child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              Colors.white),
                                                      strokeWidth: 2.0))
                                              : Text(
                                                  AppStrings.emailConfirmButton,
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white),
                                                )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  otp(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: PinCodeTextField(
          appContext: context,
          pastedTextStyle: TextStyle(
            color: Colors.green.shade600,
            fontWeight: FontWeight.bold,
          ),
          length: 6,
          blinkWhenObscuring: true,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              selectedFillColor: Colors.transparent,
              inactiveFillColor: Colors.transparent,
              activeColor: Colors.green,
              inactiveColor: Colors.white38),
          cursorColor: Colors.black,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          errorAnimationController: errorController,
          controller: otpController,
          keyboardType: TextInputType.number,
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
            debugPrint("Allowing to paste $text");
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
    );
  }
}
