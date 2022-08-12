// To parse this JSON data, do
//
//     final getRideDetails = getRideDetailsFromJson(jsonString);

import 'dart:convert';

GetRideDetails getRideDetailsFromJson(String str) => GetRideDetails.fromJson(json.decode(str));

String getRideDetailsToJson(GetRideDetails data) => json.encode(data.toJson());

class GetRideDetails {
  GetRideDetails({
    this.customListTable,
  });

  List<CustomListTable>? customListTable;

  factory GetRideDetails.fromJson(Map<dynamic, dynamic> json) => GetRideDetails(
    customListTable: List<CustomListTable>.from(json["customListTable"].map((x) => CustomListTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "customListTable": List<dynamic>.from(customListTable!.map((x) => x.toJson())),
  };
}

class CustomListTable {
  CustomListTable({
    this.id,
    this.rideId,
    this.startLocationLongitude,
    this.startLocationLatitude,
    this.endLocationLongitude,
    this.endLocationLatitude,
    this.startDateTime,
    this.endDateTime,
    this.entryBy,
    this.entryDateTime,
    this.updatedDateTime,
    this.startLocationName,
    this.endLocationName,
    this.placeId,
  });

  int? id;
  int? rideId;
  double? startLocationLongitude;
  double? startLocationLatitude;
  double? endLocationLongitude;
  double? endLocationLatitude;
  DateTime? startDateTime;
  String? endDateTime;
  String? entryBy;
  String? entryDateTime;
  DateTime? updatedDateTime;
  String? startLocationName;
  String? endLocationName;
  int? placeId;

  factory CustomListTable.fromJson(Map<String, dynamic> json) => CustomListTable(
    id: json["id"],
    rideId: json["rideId"],
    startLocationLongitude: json["startLocationLongitude"].toDouble(),
    startLocationLatitude: json["startLocationLatitude"].toDouble(),
    endLocationLongitude: json["endLocationLongitude"].toDouble(),
    endLocationLatitude: json["endLocationLatitude"].toDouble(),
    startDateTime: DateTime.parse(json["startDateTime"]),
    endDateTime: json["endDateTime"],
    entryBy: json["entryBy"],
    entryDateTime: json["entryDateTime"],
    updatedDateTime: DateTime.parse(json["updatedDateTime"]),
    startLocationName: json["startLocationName"],
    endLocationName: json["endLocationName"],
    placeId: json["placeId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rideId": rideId,
    "startLocationLongitude": startLocationLongitude,
    "startLocationLatitude": startLocationLatitude,
    "endLocationLongitude": endLocationLongitude,
    "endLocationLatitude": endLocationLatitude,
    "startDateTime": startDateTime!.toIso8601String(),
    "endDateTime": endDateTime,
    "entryBy": entryBy,
    "entryDateTime": entryDateTime,
    "updatedDateTime": updatedDateTime!.toIso8601String(),
    "startLocationName": startLocationName,
    "endLocationName": endLocationName,
    "placeId": placeId,
  };
}
