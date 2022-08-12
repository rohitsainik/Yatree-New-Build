import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yatree/services/reviewService.dart';
import 'package:yatree/utils/sharedPreference.dart';

class SubmitReview extends StatefulWidget {
  const SubmitReview({Key? key}) : super(key: key);

  @override
  _SubmitReviewState createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> {

  var username, userid;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController title = TextEditingController();

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
            child: Text("Give Review",style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 27
            ),),
          ),
        ),),
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      children: [

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Review Title *",style: TextStyle(
              fontSize: 20
          ),),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
          child: TextFormField(
            controller: title,
            keyboardType: TextInputType.emailAddress,
            decoration: new InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: new BorderSide(
                      color: Colors.grey
                  ),),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey),
                labelText: 'Write Review Title.. ',
                counterText: ""),
            maxLength: 50,

          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Care to share more about it *",style: TextStyle(

              fontSize: 20
          ),),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: descriptionController,
            decoration: new InputDecoration(

                border: OutlineInputBorder(),

                hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey),
                labelText: 'Write Review.. ',
                counterText: ""),
            maxLength: 200,
            maxLines: 10,

          ),
        ),
        SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 50),
          child: GestureDetector(
            onTap: () async{
            await  sendReviewRequest(
              rideId: 0,
              entryDateTime: DateTime.now().toIso8601String(),
              updateDateTime: DateTime.now().toIso8601String(),
              userId: userid,
              enterBy: userid,
              description: descriptionController.text,
              rating: 1,
            );
            Get.back();
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  image:DecorationImage(
                      image: AssetImage("assets/png/buttonColor.png"),
                      fit: BoxFit.cover
                  ),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(25)),
              child: Center(child: Text("Publish Review",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold),)),
            ),
          ),
        )

      ],
    );
  }
}
