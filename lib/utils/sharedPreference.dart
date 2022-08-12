import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  getUserLogedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getBool("islogin"));
  }

  removeUserLogedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.remove("islogin"));
  }

  setUserLogedIn(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("islogin", (value));
  }

  getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString("usedId"));
  }

  removeUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.remove("usedId"));
  }

  setUserId(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("usedId", (value));
  }

  getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString("Username"));
  }

  removeUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.remove("Username"));
  }

  setUsername(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("Username", (value));
  }

  getUserMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString("mobile"));
  }

  removeUserMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.remove("mobile"));
  }

  setUserMobile(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("mobile", (value));
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString("token"));
  }

  removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.remove("token"));
  }

  setToken(value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", (value));
  }

}