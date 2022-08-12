// To parse this JSON data, do
//
//     final rideModel = rideModelFromJson(jsonString);

import 'dart:convert';

RideModel rideModelFromJson(String str) => RideModel.fromJson(json.decode(str));

String rideModelToJson(RideModel data) => json.encode(data.toJson());

class RideModel {
  RideModel({
    this.getUserRides,
  });

  List<GetUserRide>? getUserRides;

  factory RideModel.fromJson(Map<String, dynamic> json) => RideModel(
        getUserRides: List<GetUserRide>.from(
            json["getUserRides"].map((x) => GetUserRide.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "getUserRides":
            List<dynamic>.from(getUserRides!.map((x) => x.toJson())),
      };
}

class GetUserRide {
  GetUserRide(
      {this.typename,
      this.id,
      this.bookingId,
      this.rideDuration,
      this.rideType,
      this.rideStartDateTime,
      this.packageName,
      this.status,
      this.rideEndDateTime,
      this.entryDateTime,
      this.userId,
      this.driverId,
      this.customerName,
      this.driverName,
      this.imageLocation,
      this.packageId,
      this.driverImage,
      this.regNo,
      this.basePrice,
        this.placeId,
        this.driverPhoneNumber,
        this.autoId,
      this.tax,this.totalAmount,});

  String? typename;
  int? id;
  String? bookingId;
  var rideDuration;
  int? rideType;
  var rideStartDateTime;
  var packageName;
  int? status;
  var rideEndDateTime;
  var entryDateTime;
  var userId;
  String? driverId;
  String? customerName;
  String? driverName;
  var imageLocation;
  var regNo;
  var driverImage;
  var packageId;
  var basePrice;
  var totalAmount;
  var tax;
  var autoId;
  var driverPhoneNumber;
  int? placeId;

  factory GetUserRide.fromJson(Map<String, dynamic> json) => GetUserRide(
      typename: json["__typename"],
      id: json["id"],
      bookingId: json["bookingId"],
      rideDuration: json["rideDuration"],
      rideType: json["rideType"],
      rideStartDateTime: json["rideStartDateTime"],
      packageName: json["packageName"],
      status: json["status"],
      rideEndDateTime: json["rideEndDateTime"],
      entryDateTime: json["entryDateTime"],
      userId: json["userId"],
      driverId: json["driverId"],
      customerName: json["customerName"],
      driverName: json["driverName"],
      imageLocation: json["imageLocation"],
      regNo: json["regNo"],
      driverImage: json["driverImage"],
      packageId: json["packageId"],
      basePrice: json["basePrice"],
      totalAmount: json["totalAmount"],
      driverPhoneNumber:json["driverPhoneNumber"],
      placeId: json["placeId"],
      autoId:json["autoId"],
      tax: json["tax"]);

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "id": id,
        "bookingId": bookingId,
        "rideDuration": rideDuration,
        "rideType": rideType,
        "rideStartDateTime": rideStartDateTime,
        "packageName": packageName,
        "status": status,
        "rideEndDateTime": rideEndDateTime,
        "entryDateTime": entryDateTime,
        "userId": userId,
        "driverId": driverId,
        "customerName": customerName,
        "driverName": driverName,
        "imageLocation": imageLocation,
        "regNo": regNo,
        "driverImage": driverImage,
        "packageId": packageId,
        "basePrice":basePrice,
        "totalAmount":totalAmount,
        "tax":tax,
    "placeId": placeId,
    "driverPhoneNumber":driverPhoneNumber,
    "autoId":autoId
      };
}
