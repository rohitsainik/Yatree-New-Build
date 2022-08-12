// import 'dart:convert';
//
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
//
// class PaymentPage extends StatefulWidget {
//   const PaymentPage({Key? key}) : super(key: key);
//
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//
//   var _razorpay = Razorpay();
//
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     print("success" + response.toString());
//     // Do something when payment succeeds
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("error" + response.toString());
//     // Do something when payment fails
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("wallet" + response.toString());
//     // Do something when an external wallet is selected
//   }
//
//   void _createOrder({var amount}) async{
//     var url = "https://api.razorpay.com/v1/orders";
//     var body = {
//       "key":"rzp_live_sE1eqpml5ynchL",
//       "amount": amount,
//       "currency": "INR",
//       "prefill": {"contact":"",
//       "email" : ""},
//
//     };
//     _razorpay.open(body);
//
//   }
//
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
//
//
