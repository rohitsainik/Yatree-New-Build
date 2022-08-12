import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yatree/utils/sharedPreference.dart';

class ProfilePage extends StatefulWidget {
   ProfilePage({Key? key,this.appbar}) : super(key: key);
  var appbar;


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var username,userid,mobileNo;

  _getData() async{
    SharedPref pref =  SharedPref();
    var userId = await pref.getUserId();
    var userName = await pref.getUsername();
    var MobileNumber = await pref.getUserMobile();
    setState(() {
      username = userName;
      userid = userId;
      mobileNo = MobileNumber;
    });
  }


  @override
  void initState() {
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  widget.appbar != null ? AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0.0,
        backgroundColor: Colors.blue,
      ) : null,
      body: ListView(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: Colors.blue,
              ),
              Positioned(
                  bottom: -50,
                  child: CircleAvatar(
                    radius: 50,
                    child: SvgPicture.asset(
                      "assets/icons/profielFull.svg",
                      color: Colors.white,
                      fit: BoxFit.contain,
                      height: 50,
                      width: 50,
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 100,
          ),
          // Align(
          //     alignment: Alignment.center,
          //     child: Text(
          //       "${username}",
          //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          //     )),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 8),
          //   child: Divider(),
          // ),
          // Align(
          //     alignment: Alignment.center,
          //     child: Text(
          //       "Yatree",
          //       style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          //     )),
          // ListTile(
          //   title: Text(
          //     "Phone Number",
          //     style: TextStyle(fontSize: 11, color: Colors.grey),
          //   ),
          //   subtitle: Text(mobileNo == null ? "----------" : mobileNo,
          //       style: TextStyle(
          //           fontSize: 18,
          //           color: Colors.black,
          //           fontWeight: FontWeight.w400)),
          //   // trailing: Icon(
          //   //   Icons.edit,
          //   //   color: Colors.blue,
          //   // ),
          // ),
          ListTile(
            title: Text(
              "Email",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            subtitle: Text("$username",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
            // trailing: Icon(
            //   Icons.edit,
            //   color: Colors.blue,
            // ),
          ),
          ListTile(
            title: Text(
              "Password",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            subtitle: Text("********",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
            // trailing: Icon(
            //   Icons.edit,
            //   color: Colors.blue,
            // ),
          )
        ],
      ),
    );
  }
}
