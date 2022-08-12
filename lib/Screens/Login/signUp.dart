import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/services/registrationFunction.dart';
import 'package:yatree/utils/commonFunctions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _NameController = TextEditingController();
  TextEditingController _conPasswordController = TextEditingController();
  bool isLoading = false;

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
                      // colorFilter: new ColorFilter.mode(
                      //     Colors.black.withOpacity(0.8), BlendMode.dstATop),
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
              SingleChildScrollView(
                child: Container(
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
                        height: MediaQuery.of(context).size.height * 0.57,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0),
                                child: Form(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 8),
                                        child: TextFormField(
                                          controller: _NameController,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white),
                                          keyboardType: TextInputType.text,
                                          decoration: new InputDecoration(
                                              fillColor:
                                                  Colors.black.withOpacity(0.6),
                                              focusColor:
                                                  Colors.black.withOpacity(0.6),
                                              border: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: _NameController
                                                                .text.length >
                                                            0
                                                        ? Colors.white
                                                        : Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              isDense: true,
                                              prefixIcon: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                              labelText: AppStrings.fname,
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
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white),
                                          controller: _emailController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: new InputDecoration(
                                              fillColor:
                                                  Colors.black.withOpacity(0.6),
                                              focusColor:
                                                  Colors.black.withOpacity(0.6),
                                              border: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: _emailController
                                                                .text.length >
                                                            0
                                                        ? Colors.white
                                                        : Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              isDense: true,
                                              prefixIcon: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Icon(
                                                      Icons.email,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                              labelText:
                                                  AppStrings.emailAddress,
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
                                          controller: _passwordController,
                                          obscureText: true,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white),
                                          keyboardType: TextInputType.text,
                                          decoration: new InputDecoration(
                                              fillColor:
                                                  Colors.black.withOpacity(0.6),
                                              focusColor:
                                                  Colors.black.withOpacity(0.6),
                                              border: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: _passwordController
                                                                .text.length >
                                                            0
                                                        ? Colors.white
                                                        : Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              isDense: true,
                                              prefixIcon: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Icon(
                                                      Icons.lock,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                              labelText: AppStrings.pass,
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
                                          obscureText: true,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white),
                                          controller: _conPasswordController,
                                          keyboardType:
                                              TextInputType.visiblePassword,
                                          decoration: new InputDecoration(
                                              fillColor:
                                                  Colors.black.withOpacity(0.6),
                                              focusColor:
                                                  Colors.black.withOpacity(0.6),
                                              border: OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        _conPasswordController
                                                                    .text
                                                                    .length >
                                                                0
                                                            ? Colors.white
                                                            : Colors
                                                                .transparent),
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              isDense: true,
                                              prefixIcon: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    width: 30,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Icon(
                                                      Icons.lock,
                                                      color: Colors.black,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              filled: true,
                                              hintStyle: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                              labelText: AppStrings.cPassword,
                                              labelStyle: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                              counterText: ""),
                                          maxLength: 50,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
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
                                            if (_passwordController.text ==
                                                _conPasswordController.text) {
                                              Loading = await signUp(
                                                  password:
                                                      _passwordController.text,
                                                  email: _emailController.text);
                                              setState(() {
                                                isLoading = Loading;
                                              });
                                            } else {
                                              showToast(
                                                  message:
                                                      "Password did'nt match");
                                            }
                                          }
                                        },
                                        child: Container(
                                          height: 45,
                                          width: 260,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                      AppStrings.signup,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white),
                                                    )),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.black54,
                                          ),
                                          child: Text(
                                            "Already have Account",
                                            style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 14,
                                              shadows: <Shadow>[
                                                Shadow(
                                                    offset: Offset(0.5, 0.5),
                                                    blurRadius: 3.0,
                                                    color:
                                                        Colors.grey.shade500),
                                              ],
                                            ),
                                          ),
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
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white38,
                                      ),
                                      child: Text(
                                        "Other signup options",
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
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
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                        BorderRadius.circular(
                                                            30),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
