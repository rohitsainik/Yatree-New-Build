import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yatree/Screens/Login/login.dart';
import 'package:yatree/Screens/perspective.dart';
import 'package:yatree/utils/sharedPreference.dart';
import 'package:yatree/utils/widgets/customSlider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final _splashDelay = 2000;
  double _height = 10.0;
  late AnimationController _animationController;
  SharedPref pref = SharedPref();
  var token;
  bool isLoading = false;

  @override
  void initState() {
    _getToken();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.forward();
    super.initState();
    _loadWidget();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  _loadWidget() async {
    var _duration = Duration(milliseconds: _splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(
        context,
        SlideLeftRoute(
          page: token != null ? PerspectivePage() : LoginScreen(),
        ));
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => token != null ? PerspectivePage() : LoginScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.red[900]);
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 30,
              ),
              child: Center(
                child: ScaleTransition(
                    scale: _animationController,
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/logo/yatree_logo.png'))),
                    )),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        height: 50,
        child: Center(
            child: Text(
          "Developed by \n BlitzBud",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        )),
      ),
    );
  }

  void _getToken() async {
    setState(() {
      isLoading = true;
    });

    var fetchToken = await pref.getUserLogedIn();
    setState(() {
      isLoading = false;
      token = fetchToken;
    });
  }
}
