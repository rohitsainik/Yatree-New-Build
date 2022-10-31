
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

buildBottomNavyBar(landingPageController) {
  return Obx(() => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Colors.white,
    selectedItemColor: Colors.white,
    currentIndex: landingPageController.tabIndex.value,
    backgroundColor: Colors.black,

    onTap: landingPageController.changeTabIndex,
    items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: SvgPicture.asset(
          "assets/svg/bottom_home.svg",
          color: Colors.white,
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: SvgPicture.asset(
          "assets/svg/bottom_ride.svg",
          color: Colors.white,
        ),
        label:  'Rides',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: SvgPicture.asset(
          "assets/icons/blog.svg",
          color: Colors.white,
        ),
        label: 'Blog',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: SvgPicture.asset(
          "assets/svg/bottom_offer.svg",
          color: Colors.white,
          height: 32,
        ),
        label:  'Offer',
      ),
      BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: Image.network(
          "https://cdn-icons-png.flaticon.com/512/147/147142.png",
          color: Colors.white,
          height: 32,
        ),
        label: 'Profile',
      ),
    ],
  ));
}