import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/model/service/sightseeing.dart';
import 'package:yatree/model/trending.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/utils/widgets/gradient.dart';
import 'package:yatree/utils/widgets/seperator.dart';

import '../../ui/booking/discount_page.dart';

class Checkout extends StatefulWidget {
  final List<ListPlaceMaster>? listPlaceMasters;
  final Function? onBookNow;
  final price, username;
  final packageid;
  const Checkout({Key? key,this.listPlaceMasters, this.onBookNow, this.price, this.username,  this.packageid}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {



  var coupon = "Apply Coupon";

  var totalAmount;
  var discountId = 0;

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
            child: Center(
                child: SvgPicture.asset(
                  'assets/svg/checkout.svg',
                  fit: BoxFit.fill,
                )),
            decoration: BoxDecoration(
                shape: BoxShape.circle, gradient: buildRadialGradient()),
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text(
          "CheckOut",
          style: GoogleFonts.raleway(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
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
      bottomNavigationBar: Container(
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (){
                widget.onBookNow!(
                    amount: (widget.price +
                        (widget.price * .18)) *
                        100,
                    email: widget.username);
              },
              child: Container(height: 50,padding: const EdgeInsets.all(8),child: Center(
                child: Text("Proceed to pay",style: GoogleFonts.raleway(color: Colors.white),),
              ),decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff29A71A),
              ),),
            ),
          )
      ),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "Trending Udaipur",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          _buildTrendingList(context),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Booking Summary"),
                      ),
                      SizedBox(height: 10,),
                      Column(children: widget.listPlaceMasters?.map((e) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(e.name ?? "",style: GoogleFonts.raleway(fontWeight: FontWeight.w600),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("\u20b9${e.price}",style: GoogleFonts.raleway(fontWeight: FontWeight.w600),)
                                  ,IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline_outlined,color: Colors.redAccent,))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: MySeparator(),
                            )
                          ],
                        );
                      }).toList() ?? [],),
                      SizedBox(height: 20,),
                      ListTile(
                        // leading: TextButton(
                        //   onPressed: (){},
                        //   child: Text("+Add more locations",style: GoogleFonts.raleway(fontWeight: FontWeight.w600),),
                        // ),
                        trailing: Text("Total : \u20b9 ${totalAmount}",style: GoogleFonts.raleway(fontWeight: FontWeight.w600),),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("No. of travellers:  ",style: GoogleFonts.raleway(),),
                                Text("",style: GoogleFonts.raleway(fontWeight: FontWeight.w600),),
                              ],
                            ),Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Booking Time:  ",style: GoogleFonts.raleway(),),
                                Text("",style: GoogleFonts.raleway(fontWeight: FontWeight.w600),),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Date:  ",style: GoogleFonts.raleway(),),
                                Text("",style: GoogleFonts.raleway(fontWeight: FontWeight.w600),),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: (){
                          var result = Get.to(DiscountPage(
                            packageId: widget.packageid,
                            serviceId: 4,
                            subServiceId: 7,
                            locationLatitude: 0.0,
                            locationLongitude: 0.0,
                            bookingDate: '2021-11-01',
                          ));
                          result!.then((value) {
                            print(value.couponCode.toString());
                            setState(() {
                              if (value != null) {
                                coupon = "COUPON APPLIED";
                                discountId = value.id;
                                if (value.amountType == 1) {
                                  totalAmount = widget.price - value.amount;
                                } else if (value.amountType == 2) {
                                  totalAmount = widget.price -
                                      ((widget.price * value.amount) / 100);
                                }
                              } else {
                                discountId = 0;
                                coupon = "APPLY COUPON";
                                totalAmount = widget.price;
                              }
                            });
                          });
                        },
                        child: Container(padding: const EdgeInsets.all(8),child: Center(
                          child: Text("APPLY COUPON",style: GoogleFonts.raleway(color: Color(0xffFFA200)),),
                        ),decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xffead46b),
                            border: Border.all(color: Color(0xffFFDB00))
                        ),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildTrendingList(BuildContext context) {
    return Container(
        height: 180,
        width: MediaQuery.of(context).size.width ,
        child: CarouselSlider.builder(
          itemCount: trendingData?.listTrendingNow!.length,
          itemBuilder: (context, index, pageViewIndex) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: CachedNetworkImage(
                imageUrl:
                "${AppStrings.imageUrl}${trendingData!.listTrendingNow![index].image}",
                imageBuilder: (context, imageProvider) => Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width * 0.65,
                  decoration: BoxDecoration(
                    image:
                    DecorationImage(image: imageProvider, fit: BoxFit.fill),
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
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            viewportFraction: 0.7,
            // aspectRatio: 2.0,
            // initialPage: 2,
          ),
        ));
  }

  TrendingData? trendingData;

  getData() async {

    TrendingData treding = await getTrendingNowData();
    setState(() {
      trendingData = treding;
      totalAmount = widget.price;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
}