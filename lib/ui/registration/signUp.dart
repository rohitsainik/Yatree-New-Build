// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:yatree/base/appStrings.dart';
// import 'package:yatree/services/registrationFunction.dart';
// import 'package:yatree/ui/registration/confirmEmail.dart';
// import 'package:yatree/utils/commonFunctions.dart';
//
// import 'loginWithPhone.dart';
//
// class SigUp extends StatefulWidget {
//   const SigUp({Key? key}) : super(key: key);
//
//   @override
//   _SigUpState createState() => _SigUpState();
// }
//
// class _SigUpState extends State<SigUp> {
//
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _NameController = TextEditingController();
//   TextEditingController _conPasswordController = TextEditingController();
//   bool isLoading = false;
//
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
//     return Center(
//         child: Container(
//           height: MediaQuery
//               .of(context)
//               .size
//               .height,
//           width: MediaQuery
//               .of(context)
//               .size
//               .width,
//           decoration: BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage("assets/png/signup.png"),
//                   fit: BoxFit.cover)),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.vertical,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 50,
//                 ),
//                 Text(
//                   AppStrings.loginTitle,
//                   style: GoogleFonts.poppins(shadows: <Shadow>[
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
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//
//                 GestureDetector(
//                   onTap: (){
//                     Get.to(()=>loginWithPhone());
//                     // signUpPhone();
//                   },
//                   child: Container(
//                     height: 50,
//                     width: 290,
//                     decoration: BoxDecoration(
//                         color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                     child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset("assets/png/phone.png"),
//                             SizedBox(width: 20,),
//                             Text(
//                               AppStrings.conPhone,
//                               style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
//                             ),
//                           ],
//                         )),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 //Google Login
//                 GestureDetector(
//                   onTap: (){
//                     signInWithGoogle();
//                   },
//                   child: Container(
//                     height: 50,
//                     width: 290,
//                     decoration: BoxDecoration(
//                         color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                     child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset("assets/png/googlelogo.png"),
//                             SizedBox(width: 20,),
//                             Text(
//                               AppStrings.conGmail,
//                               style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
//                             ),
//                           ],
//                         )),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 //Google Login
//                 GestureDetector(
//                   onTap: (){
//                     signInWitApple();
//                   },
//                   child: Container(
//                     height: 50,
//                     width: 290,
//                     decoration: BoxDecoration(
//                         color: Colors.white, borderRadius: BorderRadius.circular(10)),
//                     child: Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset("assets/png/apple.png",width: 25,),
//                             SizedBox(width: 20,),
//                             Text(
//                               "Continue with apple",
//                               style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
//                             ),
//                           ],
//                         )),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//
//                 Text(
//                   "OR",
//                   style: GoogleFonts.poppins(shadows: <Shadow>[
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
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Container(
//                   height: 450,
//                   width: 290,
//                   decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(.5),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Form(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 8),
//                           child: TextFormField(
//                             controller: _NameController,
//                             style:  TextStyle(fontSize: 15.0, color: Colors.white),
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: new InputDecoration(
//                                 border: UnderlineInputBorder(
//                                   borderSide: new BorderSide(
//                                       color: Colors.white),
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 hintStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                                 labelText: AppStrings.fname,
//                                 labelStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                                 counterText: ""),
//                             maxLength: 50,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 8),
//                           child: TextFormField(
//                             style:  TextStyle(fontSize: 15.0, color: Colors.white),
//                             controller: _emailController,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: new InputDecoration(
//                                 border: UnderlineInputBorder(
//                                   borderSide: new BorderSide(
//                                       color: Colors.white),
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 hintStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                                 labelText: AppStrings.emailAddress,
//                                 labelStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                                 counterText: ""),
//                             maxLength: 50,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 8),
//                           child: TextFormField(
//                             controller: _passwordController,
//                             obscureText: true,
//                             style:  TextStyle(fontSize: 15.0, color: Colors.white),
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: new InputDecoration(
//                                 border: UnderlineInputBorder(
//                                   borderSide: new BorderSide(
//                                       color: Colors.white),
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 hintStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                                 labelText: AppStrings.pass,
//                                 labelStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                                 counterText: ""),
//                             maxLength: 50,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 8),
//                           child: TextFormField(
//                             obscureText: true,
//                             style:  TextStyle(fontSize: 15.0, color: Colors.white),
//                             controller: _conPasswordController,
//                             keyboardType: TextInputType.visiblePassword,
//                             decoration: new InputDecoration(
//                                 border: UnderlineInputBorder(
//                                   borderSide: new BorderSide(
//                                       color: Colors.white),
//                                 ),
//                                 enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.white),
//                                 ),
//                                 hintStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                                 labelText: AppStrings.cPassword,
//                                 labelStyle:
//                                 TextStyle(fontSize: 15.0, color: Colors.white),
//                                 counterText: ""),
//                             maxLength: 50,
//                           ),
//                         ),
//                         SizedBox(height: 30,),
//                         GestureDetector(
//
//                           onTap: ()  async{
//
//                             if(isLoading){
//                               return null;
//                             }else{
//                               setState(() {
//                                 isLoading = true;
//                               });
//                               var Loading;
//                               if(_passwordController.text == _conPasswordController.text ){
//                                 Loading = await signUp(password: _passwordController.text,
//                                     email: _emailController.text);
//                                 setState(() {
//                                   isLoading = Loading;
//                                 });
//                               }else{
//                                 showToast(message: "Password did'nt match");
//                               }
//                             }
//                           },
//
//                           child: Container(
//                             height: 35,
//                             width: 230,
//                             decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Center(
//                                 child: isLoading ? SizedBox(
//                                     height: 20.0,
//                                     width: 20.0,
//                                     child:
//                                     CircularProgressIndicator(
//                                         valueColor: AlwaysStoppedAnimation(Colors.white),
//                                         strokeWidth: 2.0)
//                                 ) : Text(
//                                   AppStrings.loginButton,
//                                   style: GoogleFonts.poppins(
//                                       color: Colors.white),
//                                 )),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         TextButton(onPressed:(){
//                           Get.back();
//                         },child: Text("Already have Account",style: GoogleFonts.poppins(color: Colors.white),))
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
