import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/services/supportService.dart';
import 'package:yatree/utils/sharedPreference.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  var username, userid;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController EmailController = TextEditingController();

  _getData() async {
    SharedPref pref = SharedPref();
    var userId = await pref.getUserId();
    var userName = await pref.getUsername();
    setState(() {
      username = userName;
      userid = userId;
    });
  }

  @override
  void initState() {
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
      ),
    );
  }

  _buildBody() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Support",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Your Email Address *",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextFormField(
            controller: EmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: new InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                labelText: 'Email Address ',
                counterText: ""),
            maxLength: 50,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Care to share the problem you faced *",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: TextFormField(
            controller: descriptionController,
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
                border: OutlineInputBorder(),
                hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                alignLabelWithHint: true,
                labelText: 'Write Here.. ',
                counterText: ""),
            maxLength: 200,
            maxLines: 5,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () async {
                await sendSupportRequest(
                    description: descriptionController.text,
                    updateDateTime: DateTime.now().toIso8601String(),
                    rideId: 0,
                    bookingId: 0,
                    userId: EmailController.text.toString(),
                    enterBy: userid.toString(),
                    entryDateTime: DateTime.now().toIso8601String());
                Get.back();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text(
                  "Submit",
                  style: GoogleFonts.roboto(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // Padding(
        //   padding: const EdgeInsets.all(16.0),
        //   child: Text(
        //     "FAQs",
        //     style: TextStyle(
        //         color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        //   child: Text(
        //     "Packages Rides are consist of various tourist place within the location. These are categorised in 4 segments. All packages are well defined to maximize the travelling experience and explore the city at max level.",
        //     style: TextStyle(color: Colors.black, fontSize: 11),
        //   ),
        // ),
      ],
    );
  }
}
