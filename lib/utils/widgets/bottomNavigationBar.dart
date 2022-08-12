import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

buildFooterNavigation(landingPageController) {
  return Obx(() => BottomNavyBar(
        selectedIndex: landingPageController.tabIndex.value,
        showElevation: true,
        backgroundColor: Colors.blue,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: landingPageController.changeTabIndex,
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: SvgPicture.asset(
                "assets/icons/myRidesfull.svg",
                color: Colors.white,
              ),
              title: Text(
                'Rides',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 15),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
              inactiveColor: Colors.white),
          BottomNavyBarItem(
              icon: SvgPicture.asset(
                "assets/icons/homeFullIcon.svg",
                color: Colors.white,
              ),
              title: Text(
                'Home',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 15),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
              inactiveColor: Colors.white),
          BottomNavyBarItem(
              icon: Image.asset(
                "assets/png/explore.png",
                color: Colors.white,
                height: 32,
              ),
              title: Text(
                'Explore',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 15),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
              inactiveColor: Colors.white),
          BottomNavyBarItem(
              icon: SvgPicture.asset(
                "assets/icons/offerFull.svg",
                color: Colors.white,
              ),
              title: Text(
                'Rental',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 15),
              ),
              activeColor: Colors.white,
              textAlign: TextAlign.center,
              inactiveColor: Colors.white),
          // BottomNavyBarItem(
          //   icon: SvgPicture.asset("assets/icons/profielFull.svg",color: Colors.white,),
          //   title: Text('Profile',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 15),),
          //     activeColor: Colors.white,
          //     textAlign: TextAlign.center,
          //     inactiveColor: Colors.white
          // ),
        ],
      ));
}
