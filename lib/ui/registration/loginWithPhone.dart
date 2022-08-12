// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:otp_text_field/otp_field.dart';
// import 'package:otp_text_field/otp_field_style.dart';
// import 'package:otp_text_field/style.dart';
// import 'package:yatree/base/appStrings.dart';
// import 'package:yatree/services/registrationFunction.dart';
// import 'package:yatree/ui/registration/signUp.dart';
// import 'package:yatree/utils/commonFunctions.dart';
//
// class loginWithPhone extends StatefulWidget {
//   const loginWithPhone({Key? key}) : super(key: key);
//
//   @override
//   _loginWithPhoneState createState() => _loginWithPhoneState();
// }
//
// class _loginWithPhoneState extends State<loginWithPhone> {
//   TextEditingController phoneController = TextEditingController();
//   var Otp;
//   var isLoading = false;
//
//   bool canResend = false;
//   bool timerStarted = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildBody(context),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   late Timer _timer;
//   int _start = 30;
//
//   void startTimer() {
//     const oneSec = const Duration(seconds: 1);
//     _timer = new Timer.periodic(
//       oneSec,
//       (Timer timer) {
//         if (_start == 0) {
//           setState(() {
//             timer.cancel();
//             canResend = true;
//             timerStarted = false;
//             _start = 60;
//           });
//         } else {
//           setState(() {
//             timerStarted = true;
//             _start--;
//           });
//         }
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//   }
//
//   _buildBody(context) {
//     return Center(
//         child: Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage("assets/png/otp.png"), fit: BoxFit.cover)),
//       child: SingleChildScrollView(
//         physics: MediaQuery.of(context).viewInsets.bottom == 0
//             ? NeverScrollableScrollPhysics()
//             : AlwaysScrollableScrollPhysics(),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 50,
//             ),
//             // Align(alignment: Alignment.centerRight,child: Padding(
//             //   padding: const EdgeInsets.only(right: 10.0),
//             //   child: Text("SKIP", style: GoogleFonts.poppins(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15)),
//             // ))
//
//             Text(
//               AppStrings.loginTitle,
//               style: GoogleFonts.poppins(
//                   shadows: <Shadow>[
//                     Shadow(
//                       offset: Offset(0.0, 0.0),
//                       blurRadius: 3.0,
//                       color: Color.fromARGB(255, 0, 0, 0),
//                     ),
//                     Shadow(
//                       offset: Offset(0.0, 0.0),
//                       blurRadius: 8.0,
//                       color: Colors.grey,
//                     ),
//                   ],
//                   color: Colors.white,
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: Container(
//                 height: 50,
//                 width: 290,
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Center(
//                     child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(
//                         Icons.email,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       AppStrings.conEmail,
//                       style: GoogleFonts.poppins(
//                           color: Colors.black, fontSize: 15),
//                     ),
//                   ],
//                 )),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             // Container(
//             //   height: 50,
//             //   width: 290,
//             //   decoration: BoxDecoration(
//             //       color: Colors.white, borderRadius: BorderRadius.circular(10)),
//             //   child: Center(
//             //       child: Row(
//             //         mainAxisAlignment: MainAxisAlignment.center,
//             //         children: [
//             //           Image.asset("assets/png/googlelogo.png"),
//             //           SizedBox(width: 20,),
//             //           Text(
//             //             AppStrings.conGmail,
//             //             style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
//             //           ),
//             //         ],
//             //       )),
//             // ),
//             // SizedBox(
//             //   height: 20,
//             // ),
//             Text(
//               "OR",
//               style: GoogleFonts.poppins(
//                   shadows: <Shadow>[
//                     Shadow(
//                       offset: Offset(0.0, 0.0),
//                       blurRadius: 3.0,
//                       color: Color.fromARGB(255, 0, 0, 0),
//                     ),
//                     Shadow(
//                       offset: Offset(0.0, 0.0),
//                       blurRadius: 8.0,
//                       color: Colors.grey,
//                     ),
//                   ],
//                   color: Colors.white,
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Container(
//               height: 300,
//               width: 290,
//               decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(.5),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Form(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8),
//                       child: TextFormField(
//                         keyboardType: TextInputType.phone,
//                         style: TextStyle(fontSize: 15.0, color: Colors.white),
//                         controller: phoneController,
//                         decoration: new InputDecoration(
//                             border: UnderlineInputBorder(
//                               borderSide: new BorderSide(color: Colors.white),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                             ),
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(color: Colors.white),
//                             ),
//                             hintStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                             labelText: 'Phone Number',
//                             labelStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                             counterText: ""),
//                         maxLength: 50,
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary: !timerStarted ? Colors.amber : Colors.grey,
//                       ),
//                       onPressed: () {
//                         if (phoneController.text.length == 10) {
//                           startTimer();
//                           signUpPhone(phoneNo: phoneController.text);
//                         } else {
//                           showToast(message: "Enter valid phone number");
//                         }
//                       },
//                       child: Container(
//                         height: 35,
//                         width: 100,
//                         decoration: BoxDecoration(
//                           color: !timerStarted ? Colors.amber : Colors.grey,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Center(
//                             child: Text(
//                           timerStarted
//                               ? "00:${_start.toString().padLeft(2, "0")}"
//                               : canResend
//                                   ? "Resend OTP"
//                                   : AppStrings.sOtpButton,
//                           style: GoogleFonts.poppins(color: Colors.white),
//                         )),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     otp(context),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         setState(() {
//                           isLoading = true;
//                         });
//                         var isloading =
//                             await confirmPhoneSignIn(confirmationCode: Otp);
//                         setState(() {
//                           isLoading = isloading;
//                         });
//                         // confirmSignUp(email: "+91"+phoneController.text,confirmationCode:Otp );
//                       },
//                       child: Container(
//                         height: 35,
//                         width: 230,
//                         decoration: BoxDecoration(
//                           color: Colors.blue,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                             child: isLoading
//                                 ? SizedBox(
//                                     height: 20.0,
//                                     width: 20.0,
//                                     child: CircularProgressIndicator(
//                                         valueColor: AlwaysStoppedAnimation(
//                                             Colors.white),
//                                         strokeWidth: 2.0))
//                                 : Text(
//                                     AppStrings.otpButton,
//                                     style: GoogleFonts.poppins(
//                                         color: Colors.white),
//                                   )),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           // Text(AppStrings.rOtpButton,style: GoogleFonts.poppins(color: Colors.white),),
//                           Text(
//                             "",
//                             style: GoogleFonts.poppins(color: Colors.white),
//                           ),
//                           GestureDetector(
//                               onTap: () {
//                                 Get.off(() => SigUp());
//                               },
//                               child: Text(
//                                 AppStrings.signup,
//                                 style: GoogleFonts.poppins(color: Colors.white),
//                               )),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
//
//   otp(BuildContext context) {
//     return Container(
//       child: Center(
//         child: OTPTextField(
//           length: 6,
//           width: MediaQuery.of(context).size.width,
//           fieldWidth: 40,
//           otpFieldStyle: OtpFieldStyle(
//               enabledBorderColor: Colors.white,
//               disabledBorderColor: Colors.white,
//               borderColor: Colors.white),
//           style: TextStyle(color: Colors.white, fontSize: 13),
//           outlineBorderRadius: 0,
//           textFieldAlignment: MainAxisAlignment.spaceAround,
//           fieldStyle: FieldStyle.box,
//           onCompleted: (pin) {
//             setState(() {
//               Otp = pin;
//             });
//             print("Completed: " + pin);
//           },
//         ),
//       ),
//     );
//   }
// }
