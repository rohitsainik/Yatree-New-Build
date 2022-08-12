import 'dart:developer';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yatree/amplifyconfiguration.dart';
import 'package:yatree/splashScreen.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:yatree/utils/notification.dart';
import 'package:yatree/utils/sharedPreference.dart';
import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';

Future<void> main() async {
  SharedPref pref = SharedPref();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configAmplify();

  NotificationHandler? _notificationHandler = NotificationHandler();

  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getToken().then((value) async {
      print("token is $value");
      await pref.setToken(value);
    });
  } catch (e) {
    print(e);
  }

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log("${message.data}");
    if (message.data != null) {
      log("hey");
      _notificationHandler.firebaseMessagingForegroundHandler(message);
    }
  });

  var token = await pref.getUserLogedIn();
  // var user =  await  Amplify.Auth.getCurrentUser();
  // print ("user is $user");

  runApp(GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yatree',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff147BC1)
        ),
        scaffoldBackgroundColor: Color(0xffEEFDFF),
        primarySwatch: Colors.blue,
        backgroundColor: Color(0xffEEFDFF)
      ),
      home: SplashScreen()));
}

Future<void> configAmplify() async {
  try {
    Amplify.addPlugins([
      await AmplifyAuthCognito(),
      await AmplifyAPI(),
      await AmplifyStorageS3(),
      await AmplifyAnalyticsPinpoint()
    ]);
    Amplify.configure(amplifyconfig);
  } catch (e) {
    print(" Amplify config error $e");
    print(" Amplify already configured");
  }
}
