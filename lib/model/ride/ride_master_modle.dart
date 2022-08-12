// To parse this JSON data, do
//
//     final rideMasterModel = rideMasterModelFromJson(jsonString);

import 'dart:convert';

RideMasterModel rideMasterModelFromJson(String str) => RideMasterModel.fromJson(json.decode(str));

String rideMasterModelToJson(RideMasterModel data) => json.encode(data.toJson());

class RideMasterModel {
  RideMasterModel({
    this.getRideMaster,
  });

  GetRideMaster? getRideMaster;

  factory RideMasterModel.fromJson(Map<String, dynamic> json) => RideMasterModel(
    getRideMaster: GetRideMaster.fromJson(json["getRideMaster"]),
  );

  Map<String, dynamic> toJson() => {
    "getRideMaster": getRideMaster!.toJson(),
  };
}

class GetRideMaster {
  GetRideMaster({
    this.typename,
    this.id,
    this.bookingId,
    this.userId,
    this.rideDuration,
    this.rideStartDateTime,
    this.rideEndDateTime,
    this.driverId,
    this.status,
    this.entryBy,
    this.entryDateTime,
    this.updatedDateTime,
    this.otp,
    this.rideType,
  });

  String? typename;
  int? id;
  int? bookingId;
  String? userId;
  var rideDuration;
  var rideStartDateTime;
  var rideEndDateTime;
  String? driverId;
  int? status;
  String? entryBy;
  var entryDateTime;
  var updatedDateTime;
  int? otp;
  int? rideType;

  factory GetRideMaster.fromJson(Map<String, dynamic> json) => GetRideMaster(
    typename: json["__typename"],
    id: json["id"],
    bookingId: json["bookingId"],
    userId: json["userId"],
    rideDuration: json["rideDuration"],
    rideStartDateTime: json["rideStartDateTime"],
    rideEndDateTime: json["rideEndDateTime"],
    driverId: json["driverId"],
    status: json["status"],
    entryBy: json["entryBy"],
    entryDateTime: DateTime.parse(json["entryDateTime"]),
    updatedDateTime: DateTime.parse(json["updatedDateTime"]),
    otp: json["otp"],
    rideType: json["rideType"],
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "bookingId": bookingId,
    "userId": userId,
    "rideDuration": rideDuration,
    "rideStartDateTime": rideStartDateTime,
    "rideEndDateTime": rideEndDateTime,
    "driverId": driverId,
    "status": status,
    "entryBy": entryBy,
    "entryDateTime": entryDateTime.toIso8601String(),
    "updatedDateTime": updatedDateTime.toIso8601String(),
    "otp": otp,
    "rideType": rideType,
  };
}
