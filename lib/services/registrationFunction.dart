import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart'
    as amplifyError;

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:yatree/Screens/Login/confirmEmail.dart';
import 'package:yatree/Screens/Login/login.dart';
import 'package:yatree/Screens/perspective.dart';
import 'package:yatree/utils/commonFunctions.dart';
import 'package:yatree/utils/sharedPreference.dart';

import 'apiServices.dart';

void showLoadingIndicator(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Center(
              child: SpinKitFadingCircle(
                color: Colors.blue,
                size: 50,
              ),
            ),
          );
        });
      });
}

signIn({var email, password}) async {
  try {
    SharedPref pref = SharedPref();
    // Amplify.configure("authenticationFlowType: {'CUSTOM_AUTH'}");
    SignInResult res = await Amplify.Auth.signIn(
        username: email,
        password: password,
        options: CognitoSignInOptions(clientMetadata: {'alias': email}));
    // Amplify.Auth.getCurrentUser();
    print("signed value ${res.isSignedIn}");
    if (res.isSignedIn) {
      var user = await Amplify.Auth.getCurrentUser().then((value) async {
        AnalyticsUserProfile userProfile = new AnalyticsUserProfile();
        userProfile.name = value.username.toString();
        userProfile.email = '${email}';
        Amplify.Analytics.identifyUser(
            userId: value.userId.toString(), userProfile: userProfile);

        await pref.setUserId(value.userId.toString());
        await pref.setUsername(value.username.toString());
        var token = await pref.getToken();
        await UpdateEndpoint(userId: value.userId.toString(), token: token);
        print("value is ${value.username}  ${value.userId}");
      });
      showToast(message: "User Signed In");
      await pref.setUserLogedIn(true);
      Get.off(() => PerspectivePage());
    } else {
      showToast(message: "Something Went Wrongg");
      return false;
    }
  } on Exception catch (e) {
    print(e);
    showToast(message: "Something Went Wronggg");
    return false;
  }
}

signUp({var email, password}) async {
  try {
    SharedPref pref = SharedPref();
    SignUpResult req = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: email,
          CognitoUserAttributeKey.custom('authentication_type') : "email"
        }));
    if (req.isSignUpComplete) {
      Get.to(() => ConfirmEmail(
            email: email,
            password: password,
          ));
      //showToast(message: "SIgn Up Complete");
    } else {
      showToast(message: "Something Went Wrong");
      return false;
    }
  } on Exception catch (e) {
    String errorMsg = e.toString().split("message: ")[1].split(".")[0];
    showToast(
        message: errorMsg.length > 0 ? "${errorMsg}." : "Something Went Wrong");
    print("req");
    return false;
  }
}

confirmSignUp({var email, password, confirmationCode}) async {
  SharedPref pref = SharedPref();

  var confirmEmail = await Amplify.Auth.confirmSignUp(
      username: email, confirmationCode: confirmationCode);
  if (confirmEmail.isSignUpComplete) {
    SignInResult res = await Amplify.Auth.signIn(
        username: email,
        password: password,
        options: CognitoSignInOptions(clientMetadata: {'alias': email}));
    // Amplify.Auth.getCurrentUser();

    if (res.isSignedIn) {
      // var user = await Amplify.Auth.getCurrentUser().then((value) async {
      //   AnalyticsUserProfile userProfile = new AnalyticsUserProfile();
      //   userProfile.name = value.username.toString();
      //   userProfile.email = 'name@example.com';
      //   Amplify.Analytics.identifyUser(
      //       userId: value.userId.toString(), userProfile: userProfile);
      //
      //   await pref.setUserId(value.userId.toString());
      //   await pref.setUsername(value.username.toString());
      //   var token = await pref.getToken();
      //   await UpdateEndpoint(userId: value.userId.toString(), token: token);
      //   print("value is ${value.username}  ${value.userId}");
      // });
      // showToast(message: "User Signed In");
      await pref.setUserLogedIn(true);
      Get.off(() => PerspectivePage());
      return false;
    }
    showToast(message: "SIgn Up Success");
    showToast(message: "Login to Continue");
    // Get.off(()=> LoginScreen());

    // print(confirmEmail.nextStep.signUpStep);
    //
    // var user =  await  Amplify.Auth.getCurrentUser().then((value) async{
    //   await pref.setUserId(value.userId.toString());
    //   await pref.setUserMobile(value.username.toString());
    //   print("value is ${value.username}  ${value.userId}");
    // } );
    // await pref.setUserLogedIn(true);
    // //showToast(message: "Email Confirmed");
    // Get.off(()=> PerspectivePage());
  }
}

void signUpPhone({var phoneNo}) async {
  try {
    SharedPref pref = SharedPref();
    SignUpResult req = await Amplify.Auth.signUp(
        username: "+91$phoneNo",
        password: "12345678",
        options: CognitoSignUpOptions(userAttributes: {
          CognitoUserAttributeKey.phoneNumber: "+91$phoneNo",
          CognitoUserAttributeKey.custom('authentication_type'): "phone_number",
          CognitoUserAttributeKey.custom('auto_confirm'): "true"
        }));
    print(req.toString());
    if (req.isSignUpComplete) {
      signINPhone(phoneNo: phoneNo);
      // Amplify.Auth.confirmSignIn(confirmationValue: confirmationValue)
      // showToast(message: "SIgn Up Complete");
    } else {
      showToast(message: "Something Went Wrong");
    }
  } on Exception catch (e) {
    signINPhone(phoneNo: phoneNo);
  }
}

signINPhone({var phoneNo}) async {
  try {
    SharedPref pref = SharedPref();
    // Amplify.configure("authenticationFlowType: {'CUSTOM_AUTH'}");
    SignInResult res =
        await Amplify.Auth.signIn(username: "+91$phoneNo", password: "");
    // Amplify.Auth.getCurrentUser();

    if (res.nextStep!.signInStep == "CONFIRM_SIGN_IN_WITH_CUSTOM_CHALLENGE") {
      //
      // var user =  await  Amplify.Auth.getCurrentUser().then((value) async{
      //   AnalyticsUserProfile userProfile = new AnalyticsUserProfile();
      //   userProfile.name = value.username.toString();
      //   userProfile.email = 'name@example.com';
      //
      //   Amplify.Analytics.identifyUser(userId: value.userId.toString(), userProfile: userProfile);
      //
      //   await pref.setUserId(value.userId.toString());
      //   await pref.setUsername(value.username.toString());
      //   print("value is ${value.username}  ${value.userId}");
      // } );
      // showToast(message: "User Signed In");
      // await pref.setUserLogedIn(true);
      // Get.off(()=> PerspectivePage());
    } else {
      showToast(message: "Something Went Wrong");
      return false;
    }
  } on Exception catch (e) {
    showToast(message: "Something Went Wrong");
    return false;
  }
}

confirmPhoneSignIn({var phone, confirmationCode}) async {
  try {
    SharedPref pref = SharedPref();

    var confirmEmail =
        await Amplify.Auth.confirmSignIn(confirmationValue: confirmationCode);
    if (confirmEmail.isSignedIn) {
      // showToast(message: "SIgn p Success");
      // Get.off(()=> LoginScreen());
      // return false;
      var user = await Amplify.Auth.getCurrentUser().then((value) async {
        await pref.setUserId(value.userId.toString());
        await pref.setUserMobile(value.username.toString());
        await pref.setUsername(value.username.toString());
        var token = await pref.getToken();
        await UpdateEndpoint(userId: value.userId.toString(), token: token);
        print("value is ${value.username}  ${value.userId}");
      });
      await pref.setUserLogedIn(true);
      //showToast(message: "Email Confirmed");
      Get.off(() => PerspectivePage());
    } else {
      showToast(message: "Incorrect Otp");
      return false;
    }
  } on amplifyError.CodeMismatchException catch (e) {
    print(" exception is " + e.toString());
    showToast(message: "Incorrect Otp");
  } catch (e) {
    print("exception is $e");
  } finally {
    return false;
  }
}

void signOut() async {
  SharedPref pref = SharedPref();
  try {
    await pref.removeUserLogedIn();
    await pref.removeUserMobile();
    await pref.removeToken();
    await pref.removeUserId();
    await pref.removeUsername();
    Amplify.Auth.signOut().then((value) {
      Get.off(() => LoginScreen());
    });
  } on AuthException catch (e) {
    print(e.message);
  }
}

void forgotPassword({var username}) async {
  SharedPref pref = SharedPref();

  var resetconfirm = await Amplify.Auth.resetPassword(username: username);
  if (resetconfirm.isPasswordReset) {
    var user = await Amplify.Auth.getCurrentUser().then((value) async {
      await pref.setUserId(value.userId.toString());
      await pref.setUsername(value.username.toString());
      print("value is ${value.username}  ${value.userId}");
    });
    await pref.setUserLogedIn(true);
    showToast(message: "Email Confirmed");
    Get.off(() => PerspectivePage());
  }
}

void signInWithGoogle({email, password, context}) async {
  showLoadingIndicator(context);
  SharedPref pref = SharedPref();
  SignInResult res =
      await Amplify.Auth.signInWithWebUI(provider: AuthProvider.google);
  if (res.isSignedIn) {
    showToast(message: "User Signed In");
    var usernew = await Amplify.Auth.fetchUserAttributes().then((value) async {
      print("value is $value");
      value.forEach((element) async {
        if (element.userAttributeKey == "email") {
          await pref.setUsername(element.value.toString());
        }
      });
    });
    var user = await Amplify.Auth.getCurrentUser().then((value) async {
      await pref.setUserId(value.userId.toString());
      var token = await pref.getToken();
      await UpdateEndpoint(userId: value.userId.toString(), token: token);
      print("value is ${value.username}  ${value.userId}");
    });
    await pref.setUserLogedIn(true);
    Navigator.pop(context);
    Get.off(() => PerspectivePage());
  } else {
    showToast(message: "Something Went Wrong");
  }
}

void signInWitApple({email, password, context}) async {
  showLoadingIndicator(context);
  SharedPref pref = SharedPref();
  SignInResult res =
      await Amplify.Auth.signInWithWebUI(provider: AuthProvider.apple);

  if (res.isSignedIn) {
    showToast(message: "User Signed In");
    var usernew = await Amplify.Auth.fetchUserAttributes().then((value) async {
      print("value is $value");
      value.forEach((element) async {
        if (element.userAttributeKey == "email") {
          await pref.setUsername(element.value.toString());
        }
      });
    });
    var user = await Amplify.Auth.getCurrentUser().then((value) async {
      await pref.setUserId(value.userId.toString());
      var token = await pref.getToken();
      await UpdateEndpoint(userId: value.userId.toString(), token: token);
      print("value is ${value.username}  ${value.userId}");
    });
    await pref.setUserLogedIn(true);
    Navigator.pop(context);
    Get.off(() => PerspectivePage());
  } else {
    showToast(message: "Something Went Wrong");
  }
}
