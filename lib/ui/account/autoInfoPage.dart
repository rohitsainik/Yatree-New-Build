import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutoInfoPage extends StatefulWidget {
  const AutoInfoPage({Key? key}) : super(key: key);

  @override
  _AutoInfoPageState createState() => _AutoInfoPageState();
}

class _AutoInfoPageState extends State<AutoInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        bottom: PreferredSize(preferredSize: Size.fromHeight(50),child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Our Auto",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27
            ),),
          ),
        ),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 310,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:AssetImage("assets/png/autoImage.png"),
                  fit: BoxFit.contain,
                )

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Our Auto",style:GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Yatree Destination Private limited is a travel based company which provides an ideal platform for Travel and Rental services via a sustainable mode of transport i.e. E rickshaw. Our E-rickshaws are a step towards modernisation and growth and well equipped with all the amenities to meet the needs of every traveller and local residents of the city. Our E-rickshaws are exclusively designed with Graffiti to give tourist a glimpse of the art and culture of the city",style:GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Our Vision",style:GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Our vision is to create a sustainable business model with a whole new concept of hassle free commute. Our mission is to boost the city’s tourism with an eco friendly solution. The city and its magnificence has stayed since forever and we wish to add up to it. We are here to create a difference.",style:GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              )),
            ),
          )
        ],
      ),
    );
  }
}
