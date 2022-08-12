import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Support extends StatefulWidget {
  const Support({Key? key}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0f61ac),
        title: Text("Support"),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text("FAQs"),
          )),
        ],
      ),
      body: Stack(
        children: [
          // SingleChildScrollView(
          //   physics: NeverScrollableScrollPhysics(),
          //   child: BackdropFilter(
          //     filter: new ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.end,
          //       children: [
          //         Container(
          //           height: MediaQuery.of(context).size.height * 0.48,
          //         ),
          //         Container(
          //           height: MediaQuery.of(context).size.height * 0.4,
          //           width: MediaQuery.of(context).size.width * 1.2,
          //           decoration: BoxDecoration(
          //             image: DecorationImage(
          //                 image: AssetImage(
          //                   "assets/png/help3.png",
          //                 ),
          //                 fit: BoxFit.cover,
          //                 alignment: Alignment.bottomCenter),
          //           ),
          //           child: new BackdropFilter(
          //             filter: new ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          //             child: new Container(
          //               decoration: new BoxDecoration(
          //                   color: Colors.white.withOpacity(0.2)),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SingleChildScrollView(
            child: Container(
              // "Hi, I have a problem"
              // "Okay, How can we help you"
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width - 120,
                        decoration: BoxDecoration(
                            color: Color(0xffe8ceae),
                            borderRadius: BorderRadius.only(
                              //topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Hi, I have a ",
                                      style: GoogleFonts.raleway(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "problem",
                                      style: GoogleFonts.raleway(
                                        color: Color(0xffbd1616),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      ".",
                                      style: GoogleFonts.raleway(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Can anyone please help?",
                                  style: GoogleFonts.raleway(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5, color: Colors.grey.shade300)
                            ],
                            image: DecorationImage(
                                image: AssetImage("assets/png/help2.png"))),
                      )
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5, color: Colors.grey.shade300)
                            ],
                            image: DecorationImage(
                                image: AssetImage("assets/png/help1.png"))),
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width - 120,
                        decoration: BoxDecoration(
                            color: Color(0xffdbeaf6),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              //topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Hi, Welcome to ",
                                      style: GoogleFonts.raleway(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      "YATREE",
                                      style: GoogleFonts.raleway(
                                        color: Color(0xff06539a),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      ".",
                                      style: GoogleFonts.raleway(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Tell me, How can I help you?",
                                  style: GoogleFonts.raleway(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width - 120,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        decoration: BoxDecoration(
                            color: Color(0xffe8ceae),
                            borderRadius: BorderRadius.only(
                              //topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            )),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 1,
                            autofocus: true,
                            decoration: InputDecoration(
                              fillColor: Colors.blueAccent,
                              filled: false,
                              hintText: "Type you message here...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5, color: Colors.grey.shade300)
                            ],
                            image: DecorationImage(
                                image: AssetImage("assets/png/help2.png"))),
                      )
                    ],
                  ),
                  SizedBox(height: 320),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                        color: Color(0xff6BCB77),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Send Message",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 35,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
