import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/model/offers/offers.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/services/getImage.dart';
import 'package:yatree/utils/widgets/gradient.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
            width: 50,
            child: Center(child:  SvgPicture.asset("assets/icons/offerIcon.svg"),),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: buildRadialGradient()
            ),
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text("OFFERS",style: GoogleFonts.raleway(fontWeight: FontWeight.w500),),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
          ),
        ),
      ),


      body: ListView.builder(
        itemCount: offerData != null ? offerData!.listOfferMasters!.length : 0,
        itemBuilder: (_,index){
          return  Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 180,
              width: Get.width -100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CachedNetworkImage(
                            imageUrl:
                            "${AppStrings.imageUrl}${offerData?.listOfferMasters![index].image}",
                            imageBuilder: (context, imageProvider) => Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                                // color: Colors.white,
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              height: 140,
                              width: MediaQuery.of(context).size.width - 20,
                              color: Colors.blue,
                            ),
                            errorWidget: (context, url, error) => Container(
                                height: 140,
                                width: MediaQuery.of(context).size.width - 20,
                                color: Colors.blue,
                                child: Center(
                                  child: Icon(Icons.error),
                                )),
                          ),
                        ),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  "${offerData?.listOfferMasters![index].name}",
                                  style: GoogleFonts.raleway(fontSize: 10),
                                ),
                                Text(
                                  "${offerData?.listOfferMasters![index].description}",
                                  style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                               SizedBox(height: 25,),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month),
                                    SizedBox(width: 10,),
                                    Text(
                                      "${offerData?.listOfferMasters![index].validUpto}",
                                      style: GoogleFonts.raleway(
                                        fontSize: 10,),
                                    ),
                                  ],
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),
                  DottedLine(
                    lineThickness: 1.0,
                    dashLength: 10.0,
                    dashGapLength: 10.0,
                  ),
                  Expanded(
                    flex: 2,
                    child: TextButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: offerData?.listOfferMasters![index].name)).then((_){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("copied to clipboard")));
                          });
                        },
                        child: Text(
                            "Copy & Book: ${offerData?.listOfferMasters![index].couponCode}")),
                  )
                ],
              ),
            ),
          );
            
            
        },

      ),
    );
  }
}
