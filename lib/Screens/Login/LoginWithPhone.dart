// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:yatree/Screens/Login/signUp.dart';
// import 'package:yatree/base/appStrings.dart';
// import 'package:yatree/services/registrationFunction.dart';
// import 'package:yatree/ui/registration/loginWithPhone.dart';
// import 'package:yatree/utils/validation.dart';
//
// class LoginWithPhone extends StatefulWidget {
//   const LoginWithPhone({Key? key}) : super(key: key);
//
//   @override
//   State<LoginWithPhone> createState() => _LoginWithPhoneState();
// }
//
// class _LoginWithPhoneState extends State<LoginWithPhone> {
//   bool _obscureText = true;
//   bool? _checkbox = false;
//   bool isLoading = false;
//
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             BackdropFilter(
//               filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(
//                       "assets/png/loginbg.webp",
//                       //"https://www.trawell.in/admin/images/upload/307070312Udaipur_Fateh_Sagar_Main.jpg",
//                       //"https://i.pinimg.com/564x/40/29/17/4029171e2e1962eccb26d8c21adeb2b4.jpg",
//                       // "https://i.pinimg.com/564x/ad/54/1a/ad541a9e18bc08e51f906face3d9437b.jpg",
//                       //"https://reverievacations.com/wp-content/uploads/sites/73/2021/02/Mountains-791x473.jpg",
//                       //"https://i.pinimg.com/564x/04/8e/7d/048e7de238b54daaef7c130299eb8414.jpg",
//                     ),
//                     // colorFilter: new ColorFilter.mode(
//                     //     Colors.black.withOpacity(0.8), BlendMode.dstATop),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: new BackdropFilter(
//                   filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
//                   child: new Container(
//                     decoration:
//                         new BoxDecoration(color: Colors.white.withOpacity(0.1)),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.25,
//                     padding: EdgeInsets.only(
//                         top: MediaQuery.of(context).padding.top),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Hero(
//                           tag: "_logoImage",
//                           child: Container(
//                             height: 100,
//                             width: 100,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image:
//                                     AssetImage("assets/logo/yatree_logo.png"),
//                                 fit: BoxFit.cover,
//                               ),
//                               borderRadius: BorderRadius.circular(60),
//                               // boxShadow: [
//                               //   BoxShadow(
//                               //       color: Colors.grey.shade500,
//                               //       blurRadius: 5)
//                               // ]
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 10),
//                         Hero(
//                           tag: "_logoText",
//                           child: Text(
//                             "Yatree\nDestination",
//                             style: GoogleFonts.roboto(
//                               color: Colors.white,
//                               fontSize: 22,
//                               fontWeight: FontWeight.bold,
//                               shadows: <Shadow>[
//                                 Shadow(
//                                     offset: Offset(1.0, 1.0),
//                                     blurRadius: 8.0,
//                                     color: Colors.black87),
//                               ],
//                             ),
//                             textAlign: TextAlign.left,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.4,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Container(
//                           height: 250,
//                           width: 290,
//                           // decoration: BoxDecoration(
//                           //     color: Colors.black.withOpacity(.6),
//                           //     borderRadius: BorderRadius.circular(10)),
//                           child: Form(
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0, vertical: 8),
//                                   child: TextFormField(
//                                     validator: validateEmail,
//                                     style: TextStyle(
//                                         fontSize: 15.0, color: Colors.white),
//                                     controller: _emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     decoration: new InputDecoration(
//                                         fillColor:
//                                             Colors.black.withOpacity(0.6),
//                                         focusColor:
//                                             Colors.black.withOpacity(0.6),
//                                         border: OutlineInputBorder(
//                                           borderSide: new BorderSide(
//                                               color: Colors.white),
//                                           borderRadius:
//                                               BorderRadius.circular(25),
//                                         ),
//                                         // enabledBorder: OutlineInputBorder(
//                                         //   borderSide:
//                                         //       BorderSide(color: Colors.white),
//                                         // ),
//                                         isDense: true,
//                                         prefixIcon: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               height: 30,
//                                               width: 30,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           30)),
//                                               child: Icon(
//                                                 Icons.email,
//                                                 color: Colors.black,
//                                                 size: 18,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                             borderSide:
//                                                 BorderSide(color: Colors.white),
//                                             borderRadius:
//                                                 BorderRadius.circular(25)),
//                                         filled: true,
//                                         hintStyle: TextStyle(
//                                             fontSize: 15.0,
//                                             color: Colors.white),
//                                         labelText: 'Email Address ',
//                                         labelStyle: TextStyle(
//                                             fontSize: 15.0,
//                                             color: Colors.white),
//                                         counterText: ""),
//                                     maxLength: 50,
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 8.0, vertical: 8),
//                                   child: TextFormField(
//                                     validator: validatePassword,
//                                     style: TextStyle(
//                                         fontSize: 15.0, color: Colors.white),
//                                     controller: _passwordController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     obscureText: _obscureText,
//                                     decoration: new InputDecoration(
//                                         fillColor:
//                                             Colors.black.withOpacity(0.6),
//                                         focusColor:
//                                             Colors.black.withOpacity(0.6),
//                                         border: OutlineInputBorder(
//                                             borderSide: new BorderSide(
//                                                 color: Colors.white),
//                                             borderRadius:
//                                                 BorderRadius.circular(25)),
//                                         // enabledBorder: OutlineInputBorder(
//                                         //   borderSide:
//                                         //       BorderSide(color: Colors.white),
//                                         // ),
//                                         prefixIcon: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               height: 30,
//                                               width: 30,
//                                               decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           30)),
//                                               child: Icon(
//                                                 Icons.lock,
//                                                 color: Colors.black,
//                                                 size: 18,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         isDense: true,
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide:
//                                               BorderSide(color: Colors.white),
//                                           borderRadius:
//                                               BorderRadius.circular(25),
//                                         ),
//                                         filled: true,
//                                         hintStyle: TextStyle(
//                                             fontSize: 15.0,
//                                             color: Colors.white),
//                                         labelText: 'Password ',
//                                         labelStyle: TextStyle(
//                                             fontSize: 15.0,
//                                             color: Colors.white),
//                                         counterText: ""),
//                                     maxLength: 50,
//                                   ),
//                                 ),
//                                 // Row(
//                                 //   children: [
//                                 //     Checkbox(
//                                 //       value: _checkbox,
//                                 //       onChanged: (value) {
//                                 //         _checkbox = value;
//                                 //         setState(() {
//                                 //           if (value == true) {
//                                 //             _obscureText = false;
//                                 //           } else {
//                                 //             _obscureText = true;
//                                 //           }
//                                 //         });
//                                 //         // print(value);
//                                 //         // _toggle(value);
//                                 //       },
//                                 //       side: BorderSide(color: Colors.white),
//                                 //     ),
//                                 //     Text(
//                                 //       AppStrings.shPassword,
//                                 //       style: GoogleFonts.poppins(
//                                 //           color: Colors.white),
//                                 //     )
//                                 //   ],
//                                 // ),
//                                 SizedBox(height: 20),
//                                 GestureDetector(
//                                   onTap: () async {
//                                     if (isLoading) {
//                                       return null;
//                                     } else {
//                                       setState(() {
//                                         isLoading = true;
//                                       });
//                                       var Loading = await signIn(
//                                           email: _emailController.text,
//                                           password: _passwordController.text);
//
//                                       setState(() {
//                                         isLoading = Loading;
//                                       });
//                                     }
//                                   },
//                                   child: Container(
//                                     height: 45,
//                                     width: 270,
//                                     decoration: BoxDecoration(
//                                       color: Colors.green,
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Center(
//                                         child: isLoading
//                                             ? SizedBox(
//                                                 height: 20.0,
//                                                 width: 20.0,
//                                                 child: CircularProgressIndicator(
//                                                     valueColor:
//                                                         AlwaysStoppedAnimation(
//                                                             Colors.white),
//                                                     strokeWidth: 2.0))
//                                             : Text(
//                                                 AppStrings.loginButton,
//                                                 style: GoogleFonts.poppins(
//                                                     color: Colors.white),
//                                               )),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.height * 0.25,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Hero(
//                           tag: "_othersignin",
//                           child: Container(
//                             width: MediaQuery.of(context).size.width * 0.7,
//                             child: Column(
//                               children: [
//                                 Text(
//                                   " -   other signin options   - ",
//                                   style: GoogleFonts.roboto(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     shadows: <Shadow>[
//                                       Shadow(
//                                           offset: Offset(0.5, 0.5),
//                                           blurRadius: 3.0,
//                                           color: Colors.grey.shade500),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(height: 25),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     GestureDetector(
//                                       onTap: () {
//                                         Get.to(() => loginWithPhone());
//                                         // signUpPhone();
//                                       },
//                                       child: Container(
//                                         height: 50,
//                                         width: 50,
//                                         decoration: BoxDecoration(
//                                           color: Colors.blue,
//                                           borderRadius:
//                                               BorderRadius.circular(30),
//                                         ),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               height: 35,
//                                               width: 35,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(30),
//                                               ),
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/png/phone.png",
//                                                     height: 20,
//                                                     width: 20,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         signInWithGoogle();
//                                       },
//                                       child: Container(
//                                         height: 50,
//                                         width: 50,
//                                         decoration: BoxDecoration(
//                                           // color: Colors.red,
//                                           gradient: LinearGradient(
//                                               colors: [
//                                                 const Color(0xFFea4335),
//                                                 const Color(0xFFfbbc05),
//                                                 const Color(0xFF34a853),
//                                                 const Color(0xFF4285f4),
//                                               ],
//                                               begin: const FractionalOffset(
//                                                   0.0, 0.0),
//                                               end: const FractionalOffset(
//                                                   1.0, 0.0),
//                                               stops: [0.0, 0.3, 0.9, 1.0],
//                                               tileMode: TileMode.clamp),
//                                           borderRadius:
//                                               BorderRadius.circular(30),
//                                         ),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               height: 35,
//                                               width: 35,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(30),
//                                               ),
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/png/googlelogo.png",
//                                                     height: 20,
//                                                     width: 20,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         signInWitApple();
//                                       },
//                                       child: Container(
//                                         height: 50,
//                                         width: 50,
//                                         decoration: BoxDecoration(
//                                           color: Colors.black,
//                                           borderRadius:
//                                               BorderRadius.circular(30),
//                                         ),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               height: 35,
//                                               width: 35,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(30),
//                                               ),
//                                               child: Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Image.asset(
//                                                     "assets/png/apple.png",
//                                                     height: 20,
//                                                     width: 20,
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(() => SignUpScreen());
//                           },
//                           child: Container(
//                             height: 45,
//                             width: 260,
//                             decoration: BoxDecoration(
//                               color: Colors.deepOrangeAccent,
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Center(
//                                 child: isLoading
//                                     ? SizedBox(
//                                         height: 20.0,
//                                         width: 20.0,
//                                         child: CircularProgressIndicator(
//                                             valueColor: AlwaysStoppedAnimation(
//                                                 Colors.white),
//                                             strokeWidth: 2.0))
//                                     : Text(
//                                         AppStrings.signup,
//                                         style: GoogleFonts.poppins(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w500),
//                                       )),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
