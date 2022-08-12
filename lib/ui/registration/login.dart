// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:yatree/base/appStrings.dart';
// import 'package:yatree/services/registrationFunction.dart';
// import 'package:yatree/ui/registration/loginWithPhone.dart';
// import 'package:yatree/ui/registration/signUp.dart';
// import 'package:yatree/utils/validation.dart';
//
// class LoginScreenOld extends StatefulWidget {
//   const LoginScreenOld({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreenOld> {
//   bool _obscureText = true;
//   bool? _checkbox = false;
//   //
//   bool isLoading = false;
//   //
//   //
//   // void _toggle(value) {
//   //   setState(() {
//   //     _obscureText = value;
//   //     _checkbox = _obscureText;
//   //   });
//   // }
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildBody(context),
//       // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
//
//   _buildBody(context) {
//     return SingleChildScrollView(
//       physics: MediaQuery.of(context).viewInsets.bottom == 0
//           ? NeverScrollableScrollPhysics()
//           : AlwaysScrollableScrollPhysics(),
//       child: Center(
//           child: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/png/loginBackground.png"),
//                 fit: BoxFit.cover)),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 30,
//             ),
//             // Align(alignment: Alignment.centerRight,child: Padding(
//             //   padding: const EdgeInsets.only(right: 10.0),
//             //   child: TextButton(onPressed: (){
//             //     Get.to(()=>PerspectivePage());
//             //   },child: Text("SKIP", style: GoogleFonts.poppins(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15))),
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
//                 Get.to(() => loginWithPhone());
//                 // signUpPhone();
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
//                     Image.asset("assets/png/phone.png"),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       AppStrings.conPhone,
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
//             //Google Login
//             GestureDetector(
//               onTap: () {
//                 signInWithGoogle();
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
//                     Image.asset("assets/png/googlelogo.png"),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       AppStrings.conGmail,
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
//             //Google Login
//             GestureDetector(
//               onTap: () {
//                 signInWitApple();
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
//                     Image.asset(
//                       "assets/png/apple.png",
//                       width: 25,
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       "Continue with apple",
//                       style: GoogleFonts.poppins(
//                           color: Colors.black, fontSize: 15),
//                     ),
//                   ],
//                 )),
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
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
//                         validator: validateEmail,
//                         style: TextStyle(fontSize: 15.0, color: Colors.white),
//                         controller: _emailController,
//                         keyboardType: TextInputType.emailAddress,
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
//                             labelText: 'Email Address ',
//                             labelStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                             counterText: ""),
//                         maxLength: 50,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 8),
//                       child: TextFormField(
//                         validator: validatePassword,
//                         style: TextStyle(fontSize: 15.0, color: Colors.white),
//                         controller: _passwordController,
//                         keyboardType: TextInputType.emailAddress,
//                         obscureText: _obscureText,
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
//                             labelText: 'Password',
//                             labelStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                             counterText: ""),
//                         maxLength: 50,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Checkbox(
//                           value: _checkbox,
//                           onChanged: (value) {
//                             _checkbox = value;
//                             setState(() {
//                               if (value == true) {
//                                 _obscureText = false;
//                               } else {
//                                 _obscureText = true;
//                               }
//                             });
//                             // print(value);
//                             // _toggle(value);
//                           },
//                           side: BorderSide(color: Colors.white),
//                         ),
//                         Text(
//                           AppStrings.shPassword,
//                           style: GoogleFonts.poppins(color: Colors.white),
//                         )
//                       ],
//                     ),
//                     GestureDetector(
//                       onTap: () async {
//                         if (isLoading) {
//                           return null;
//                         } else {
//                           setState(() {
//                             isLoading = true;
//                           });
//                           var Loading = await signIn(
//                               email: _emailController.text,
//                               password: _passwordController.text);
//
//                           setState(() {
//                             isLoading = Loading;
//                           });
//                         }
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
//                                     AppStrings.loginButton,
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
//                           // Text(AppStrings.forgetpass,style: GoogleFonts.poppins(color: Colors.white),),
//                           Text(
//                             "",
//                             style: GoogleFonts.poppins(color: Colors.white),
//                           ),
//                           GestureDetector(
//                               onTap: () {
//                                 Get.to(() => SigUp());
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
//           ],
//         ),
//       )),
//     );
//   }
// }
