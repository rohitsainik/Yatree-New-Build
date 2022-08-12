import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/model/offers/offers.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/getImage.dart';

class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {

  OfferDataModel? offerData;

  getData() async{

    OfferDataModel offer = await getOfferMasterData();

    setState(() {

      offerData = offer;
    });

  }

  @override
  void initState() {
    getData();
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        elevation: 0.0,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SvgPicture.asset("assets/icons/offerIcon.svg"),
            SizedBox(width: 10,),
            Text("Offers",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 23,color: Colors.black),),
          ],
        ),
      ),
      //  leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,), onPressed: () { Get.back(); },),
        backgroundColor: Colors.white,
        // bottom: PreferredSize(preferredSize: Size.fromHeight(30),
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Row(
        //       children: [
        //         SvgPicture.asset("assets/icons/offerIcon.svg"),
        //         SizedBox(width: 10,),
        //         Text("Offers",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 23),),
        //       ],
        //     ),
        //   ),),
      ),
      body: ListView.builder(
        itemCount: offerData != null ? offerData!.listOfferMasters!.length : 0,
        itemBuilder: (_,index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              imageUrl: "${AppStrings.imageUrl}${offerData!.listOfferMasters![index].image}",
              imageBuilder: (context, imageProvider) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image:DecorationImage(image: imageProvider,
                          // fit: BoxFit.cover
                      ),
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                height: 140,
                width: 215,
                color: Colors.blue,
              ),
              errorWidget: (context, url, error) => Container(
                  height: 140,
                  width: 215,
                  color: Colors.blue,
                  child:Center(
                    child: Icon(Icons.error),
                  )
              ),
            ),
          );
            
            
        },

      ),
    );
  }
}
