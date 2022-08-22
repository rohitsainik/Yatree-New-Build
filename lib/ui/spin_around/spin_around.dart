
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/model/service/spinaround_data.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/ui/booking/bookingForm.dart';
import 'package:yatree/utils/widgets/gradient.dart';

class SpinAroundPage extends StatefulWidget {
  const SpinAroundPage({Key? key}) : super(key: key);

  @override
  State<SpinAroundPage> createState() => _SpinAroundPageState();
}

class _SpinAroundPageState extends State<SpinAroundPage> {

  SpinAround spinData = SpinAround();


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
            child: Center(child: SvgPicture.asset('assets/svg/spin around.svg')),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: buildRadialGradient()
            ),
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text("Spin Around",style: GoogleFonts.raleway(fontWeight: FontWeight.w500),),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),

          ),
        ),
      ),
      body: buildBody(),
    );
  }

  buildBody(){
    return ListView.builder(itemCount: spinData.getServicePlaceMapping?.placeCategoriesData?.length,
        itemBuilder: (_,index){
      var data = spinData.getServicePlaceMapping?.placeCategoriesData?[index];
      return Container(
        child: Column(
          children: [
            ListTile(
              leading: SizedBox(height: 50,width: 50,child: Image.network("https://d19y8r79r2sdoe.cloudfront.net/public/${data?.placeCategoryImage}"),),
              title: Text(data?.placeCategoryName.toString() ?? "",style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.w500),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
              child: Container(
                width: Get.width,
                child: Card(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: data?.placeData?.map((e) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () async{
                              var data = await createCustomPackage(
                                  name: e.name,
                              description: e.description,
                              serviceId: spinData.getServicePlaceMapping?.serviceId,
                              price: e.price,
                                categoryId: e.placeCategoryId,
                                placeId: e.id

                              );
                              Get.to(()=>BookingPage(price: e.price,));
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                      borderRadius: BorderRadius.circular(40),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              "https://d19y8r79r2sdoe.cloudfront.net/public/${e.placeImage}"),
                                          fit: BoxFit.fill)),
                                ),
                                SizedBox(height: 10,),
                                Text(e.name.toString() ,style: GoogleFonts.raleway(fontWeight: FontWeight.w500),),
                              ],
                            ),
                          ),
                        );
                      }).toList() ?? [],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    getData();
  }

  getData() async{
    var data =  await getServicePlaceMapping();
    setState(() {
      spinData = data;
    });
  }
}
