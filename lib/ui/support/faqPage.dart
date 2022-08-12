import 'package:flutter/material.dart';
import 'package:yatree/services/apiServices.dart';
import 'package:yatree/utils/widgets/expandableTile.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {

  var data;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async{

    var faq = await getFaqMasterData();

    setState(() {
      data = faq;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body:data["listFaqMasters"].length == 0 ? Center(child: CircularProgressIndicator()) : ListView.builder(itemCount: data["listFaqMasters"].length,itemBuilder: (_,index){
        return expandableContainer(data["listFaqMasters"][index]["question"].toString(),data["listFaqMasters"][index]["answer"].toString());
      }),
    );
  }
}
