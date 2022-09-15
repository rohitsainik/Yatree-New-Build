import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/Screens/booking/checkout.dart';
import 'package:yatree/model/serive.dart';
import 'package:yatree/model/service/sightseeing.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/ui/booking/bookingForm.dart';
import 'package:yatree/utils/widgets/gradient.dart';

class SightSeeing extends StatefulWidget {
  SightSeeing({Key? key, this.serviceData}) : super(key: key);
  ListServiceMaster? serviceData;

  @override
  State<SightSeeing> createState() => _SightSeeingState();
}

class _SightSeeingState extends State<SightSeeing> {
  bool checkedValue = false;
  int count = 0;
  Placelist? placeData;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var data = await getListPlaceMaster();
    setState(() {
      placeData = data;
    });
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
            child: Center(
                child: Image.asset(
              'assets/png/sighseeing.png',
              fit: BoxFit.fill,
            )),
            decoration: BoxDecoration(
                shape: BoxShape.circle, gradient: buildRadialGradient()),
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text(
          "Spin Around",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Badge(
              badgeColor: Colors.red,
              badgeContent: Text(
                '$count',
                style: TextStyle(color: Colors.white),
              ),
              child: InkWell(
                onTap: () async {
                  var listPlaceMasters = placeData?.listPlaceMasters
                          ?.where((element) => element.isSelected == true)
                          .toList() ??
                      [];
                  List placeId = [];
                  var total = 0;
                  listPlaceMasters.forEach((element) {
                    placeId.add(element.id);
                    total = total + int.parse(element.price.toString());
                  });
                  var data = await createCustomPackage(
                      name: "Custom Package",
                      description:
                          "You Package Contain ${listPlaceMasters.length} destinations",
                      serviceId: widget.serviceData?.id,
                      price: total,
                      categoryId: 0,
                      placeId: placeId.join(","));
                  Get.to(() => BookingPage(
                        price: total,
                        packageData: data,
                        placeData: listPlaceMasters,
                      ));
                  // Get.to(()=>Checkout(listPlaceMasters: listPlaceMasters,));
                },
                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                      child: SvgPicture.asset(
                    'assetsvg/checkout.svg',
                    fit: BoxFit.fill,
                  )),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, gradient: buildRadialGradient()),
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
          ),
        ),
      ),
      body: buildBody(),
    );
  }

  buildBody() {
    return ListView.builder(
        itemCount: placeData?.listPlaceMasters?.length,
        itemBuilder: (_, index) {
          var data = placeData?.listPlaceMasters?[index];
          return Container(
            child: Column(
              children: [
                CheckboxListTile(
                  contentPadding: const EdgeInsets.only(left: 16, top: 10),
                  title: Container(
                    height: 150,
                    width: Get.width,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                  ),
                  value: data?.isSelected ?? false,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue == true) {
                        count++;
                      } else {
                        count--;
                      }
                      data?.isSelected = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                if (data?.isSelected == true)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                data?.name.toString() ?? "",
                                style: GoogleFonts.raleway(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent),
                              ),
                              Text(
                                " - \u20b9",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent),
                              ),
                              Text(
                                data?.price.toString() ?? "",
                                style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueAccent),
                              ),
                            ],
                          ),
                          Text(
                            data?.description.toString() ?? "",
                            style: GoogleFonts.raleway(
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          );
        });
  }
}
