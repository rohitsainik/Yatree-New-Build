import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yatree/ui/support/faqPage.dart';

class PolicyPage extends StatefulWidget {
  const PolicyPage({Key? key}) : super(key: key);

  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: _buildBody(),
      backgroundColor: Colors.white,

    );
  }

  _buildBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Policies",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
        ),
        InkWell(
          onTap: ()async {
            var _url = "https://www.yatreedestination.com/Terms-of-Use";
            if (!await launch(_url)) throw 'Could not launch $_url';
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "1. Terms of Use",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: ()async {
            var _url = "https://www.yatreedestination.com/Privacy-Policy";
            if (!await launch(_url)) throw 'Could not launch $_url';
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "2. Privacy Policy",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: ()async {
            var _url = "https://www.yatreedestination.com/Refund-And-Cancellation-Policy";
            if (!await launch(_url)) throw 'Could not launch $_url';
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "3. Refund & Cancellation Policy",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(()=>FaqPage());
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "3. Frequently asked Questions?",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
          ),
        ),

      ],
    );
  }
}
