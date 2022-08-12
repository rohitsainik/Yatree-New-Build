import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:yatree/base/appStrings.dart';
import 'package:yatree/services/registrationFunction.dart';
import 'package:yatree/ui/registration/signUp.dart';
import 'package:yatree/utils/commonFunctions.dart';


class ConfirmEmail extends StatefulWidget {
  final String email;
  final String password;
  const ConfirmEmail({Key? key,required this.email,required this.password}) : super(key: key);

  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {

  var confirmPin = "";
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(context),
        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  _buildBody(context) {
    return Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/png/otp.png"),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [



              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                width: 290,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.5),
                    borderRadius: BorderRadius.circular(10)),
                child: Form(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(alignment: Alignment.centerLeft,child: Text("Please Enter Confirmation Code",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 13),)),
                      ),
                      SizedBox(height: 10),
                      otp(context),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () async{
                          if(isLoading){
                            return null;
                          }else{
                            setState(() {
                              isLoading = true;
                            });
                            var Loading;
                            if(confirmPin != "" ){
                              Loading = await  confirmSignUp(email: widget.email,password : widget.password
                                  ,confirmationCode:confirmPin);
                              setState(() {
                                isLoading = Loading;
                              });
                            }else{
                              showToast(message: "OTP required");
                            }
                          }
                        },
                        child: Container(
                          height: 35,
                          width: 230,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: isLoading ? SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child:
                                  CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                      strokeWidth: 2.0)
                              ) : Text(
                                AppStrings.emailConfirmButton,
                                style: GoogleFonts.poppins(color: Colors.white),
                              )),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  otp(BuildContext context) {
    return Container(

      child: Center(
        child: OTPTextField(
          length: 6,
          width: MediaQuery.of(context).size.width,
          fieldWidth: 40,
          otpFieldStyle: OtpFieldStyle(
              enabledBorderColor: Colors.white,
              disabledBorderColor: Colors.white,
              borderColor: Colors.white
          ),
          style: TextStyle(
              color: Colors.white,
              fontSize: 13
          ),
          outlineBorderRadius: 0,
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.box,
          onCompleted: (pin) {
            setState(() {
              confirmPin = pin;
            });
            print("Completed: " + pin);
          },
        ),
      ),
    );
  }
}
