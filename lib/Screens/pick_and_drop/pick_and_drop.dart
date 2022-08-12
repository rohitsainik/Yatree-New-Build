

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yatree/utils/widgets/gradient.dart';

class PickAndDrop extends StatefulWidget {
  const PickAndDrop({Key? key}) : super(key: key);

  @override
  State<PickAndDrop> createState() => _PickAndDropState();
}

class _PickAndDropState extends State<PickAndDrop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEFDFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 50,
            child: Center(child: SvgPicture.asset('assets/svg/pick_and_drop.svg')),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: buildRadialGradient()
            ),
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text("PICK & DROP",style: GoogleFonts.raleway(fontWeight: FontWeight.w500),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              // gradient: LinearGradient(
              //     colors: [Colors.red,Colors.pink],
              //     begin: Alignment.bottomCenter,
              //     end: Alignment.topCenter
              // )
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/png/pick and drop background.png")
              )
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HorizontalSlidableButton(
                width: MediaQuery.of(context).size.width / 2,
                buttonWidth: 50.0,
                color: Color(0xff147BC1),
                buttonColor: Color(0xff147BC1),
                dismissible: false,
                height: 50,
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Image.asset('assets/png/call.png'),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    ],
                  ),
                ),
                onChanged: (position) async {
                  if (position == SlidableButtonPosition.end) {

                    var url =Uri(scheme: "tel",path: "+918000505810");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("We Regret for inconvenience Contact Customer Care"),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 20,),
              HorizontalSlidableButton(
                initialPosition: SlidableButtonPosition.end,
                width: MediaQuery.of(context).size.width / 2,
                buttonWidth: 50.0,
                height: 50,
                color: Color(0xff29A71A),
                buttonColor: Color(0xff29A71A),
                dismissible: false,
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(

                    child: Image.asset('assets/png/whatsapp.png'),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    ],
                  ),
                ),
                onChanged: (position) async{
                  if (position == SlidableButtonPosition.start) {
                    var whatsapp = "+918000505810";
                    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
                    if (await canLaunchUrl(whatsappAndroid)) {
                      await launchUrl(whatsappAndroid);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("WhatsApp is not installed on the device"),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

}
