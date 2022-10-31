import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Screens/Support/Support.dart';
import 'package:yatree/controller/tab_controller.dart';
import 'package:yatree/services/registrationFunction.dart';
import 'package:yatree/ui/account/autoInfoPage.dart';
import 'package:yatree/ui/account/newProfile.dart';
import 'package:yatree/ui/review/addReview.dart';
import 'package:yatree/ui/support/policies_page.dart';

Widget AppDrawer(
    {var username,
    index,
    required LandingPageController landingPageController}) {
  return SafeArea(
    child: Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 25),
              ListTile(
                onTap: () async {
                  // Get.to(() => ProfilePage(
                  //       appbar: true,
                  //     ));
                  Get.to(() => NewProfile(fromBottom:true));

                  // SharedPref pref = SharedPref();
                  // var userId = await pref.getUserId();
                  // var userName = await pref.getUsername();
                  // print(userId);
                  // var rides = await getTryData(id: "${userId}");
                },
                leading: Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/147/147142.png"),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(70),
                  ),
                ),
                // CircleAvatar(
                //   radius: 30,
                //   child: SvgPicture.asset("assets/icons/profielFull.svg",color: Colors.white,fit: BoxFit.contain,height: 25,width: 25,),
                // ),
                title: Text(
                  "$username",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "Yatree",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //visualDensity: VisualDensity(vertical: -4),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 0.0),
                child: Divider(color: Colors.grey.shade500, thickness: 1),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => NewProfile(fromBottom:true));
                },
                leading: SvgPicture.asset(
                  "assets/icons/support.svg",
                  height: 20,
                  width: 20,
                ),
                title: Text(
                  "My Profile",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              ListTile(
                onTap: () {
                  landingPageController.tabIndex.value = 0;
                  Get.back();
                  // Get.to(()=>MyRides());
                },
                leading: SvgPicture.asset(
                  "assets/icons/rideIcon.svg",
                  height: 20,
                  width: 20,
                ),
                title: Text(
                  "My Rides",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => AutoInfoPage());
                  //Get.to(() => Support());
                },
                leading: Image.asset(
                  "assets/png/auto-rickshaw.png",
                  height: 24,
                  width: 24,
                ),
                title: Text(
                  "Our Auto",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              /*ListTile(
                onTap: () {
                  //Get.to(() => SupportPage());
                  Get.to(() => Support());
                },
                leading: SvgPicture.asset(
                  "assets/icons/support.svg",
                  height: 20,
                  width: 20,
                ),
                title: Text(
                  "Support",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),*/
              ListTile(
                onTap: () {
                  Get.to(() => SubmitReview());
                },
                leading: SvgPicture.asset(
                  "assets/icons/starIcon.svg",
                  height: 20,
                  width: 20,
                ),
                title: Text(
                  "Review",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(() => PolicyPage());
                },
                leading: SvgPicture.asset(
                  "assets/svg/policy.svg",
                  height: 20,
                  width: 20,
                ),
                title: Text(
                  "Policies",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              Divider()
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
                onPressed: () {
                  Get.back();

                  // setState(() {
                  //   test = !test;
                  // });
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                )),
          )
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: GestureDetector(
        onTap: () {
          signOut();
        },
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login_outlined,
                color: Colors.black,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Logout",
                style: TextStyle(
                  color: Colors.blue,
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

// showMoreOptions(context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) => Wrap(
//       children: [
//         Container(
//           padding: EdgeInsets.only(left: 10.0, right: 10.0),
//           decoration: new BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(top: 25.0),
//               ),
//               Text(
//                 "Contact Us",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 10.0),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: FlatButton.icon(
//                       color: Colors.green,
//                       onPressed: () {
//                         Navigator.pop(context);
//                         launchWhatsApp();
//                       },
//                       icon: Image.asset(
//                         'assets/images/pngicons/ic_whatsapp.png',
//                         color: AppColors.white,
//                         height: 24.0,
//                         width: 24.0,
//                       ),
//                       label: Text(
//                         AppStrings.whatsapp,
//                         style: TextStyle(
//                             color: AppColors.white, fontSize: AppSizes.font_15),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: 5.0, right: 5.0),
//                   ),
//                   Expanded(
//                     flex: 1,
//                     child: FlatButton.icon(
//                       color: AppColors.colorPrimary,
//                       onPressed: () {
//                         // printMessage(screenName, "Call now clicked");
//                         Navigator.pop(context);
//                         openDialer();
//                       },
//                       icon: Image.asset(
//                         'assets/images/pngicons/ic_outgoing.png',
//                         color: AppColors.white,
//                         height: 24.0,
//                         width: 24.0,
//                       ),
//                       label: Text(
//                         AppStrings.call_now,
//                         style: TextStyle(
//                             color: AppColors.white, fontSize: AppSizes.font_15),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 0.0),
//               ),
//               Container(
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: FlatButton.icon(
//                     color: AppColors.black,
//                     onPressed: () {
//                       Navigator.pop(context);
//                       openRequestCallBack(context);
//                     },
//                     icon: Image.asset(
//                       'assets/images/pngicons/ic_incoming_call.png',
//                       color: AppColors.white,
//                       height: 24.0,
//                       width: 24.0,
//                     ),
//                     label: Text(
//                       AppStrings.req_call_back,
//                       style: TextStyle(
//                           color: AppColors.white, fontSize: AppSizes.font_15),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 10.0),
//               ),
//             ],
//           ),
//         )
//       ],
//     ),
//   );
// }
