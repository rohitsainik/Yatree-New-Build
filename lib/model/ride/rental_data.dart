// To parse this JSON data, do
//
//     final getRideDetails = getRideDetailsFromJson(jsonString);

import 'dart:convert';

GetRentalDetails getRideDetailsFromJson(String str) =>
    GetRentalDetails.fromJson(json.decode(str));

String getRideDetailsToJson(GetRentalDetails data) =>
    json.encode(data.toJson());

class GetRentalDetails {
  GetRentalDetails({
    this.customListTable,
  });

  List<RentalListTable>? customListTable;

  factory GetRentalDetails.fromJson(Map<dynamic, dynamic> json) =>
      GetRentalDetails(
        customListTable: List<RentalListTable>.from(
            json["customListTable"].map((x) => RentalListTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "customListTable":
            List<dynamic>.from(customListTable!.map((x) => x.toJson())),
      };
}

class RentalListTable {
  RentalListTable(
      {this.id,
      this.entryBy,
      this.entryDateTime,
      this.updatedDateTime,
      this.name,
      this.email,
      this.noOfAutos,
      this.phoneNo,
      this.locationName,
      this.pickupDate,
        this.status,
      this.pickupTime});

  int? id;
  String? name;
  var phoneNo;
  String? email;
  var noOfAutos;
  String? locationName;
  String? pickupDate;
  String? pickupTime;
  String? entryBy;
  String? entryDateTime;
  DateTime? updatedDateTime;
  var status;

  factory RentalListTable.fromJson(Map<String, dynamic> json) =>
      RentalListTable(
        id: json["id"],
        name: json["name"],
        phoneNo: json["phoneNo"].toDouble(),
        email: json["email"].toDouble(),
        noOfAutos: json["noOfAutos"].toDouble(),
        locationName: json["locationName"].toDouble(),
        pickupDate: json["pickupDate"],
        pickupTime: json["pickupTime"],
        entryBy: json["entryBy"],
        entryDateTime: json["entryDateTime"],
        status: json["status"],
        updatedDateTime: DateTime.parse(json["updatedDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNo": phoneNo,
        "email": email,
        "noOfAutos": noOfAutos,
        "locationName": locationName,
        "pickupDate": pickupDate,
        "pickupTime": pickupTime,
        "entryBy": entryBy,
        "entryDateTime": entryDateTime,
        "status": status,
        "updatedDateTime": updatedDateTime!.toIso8601String(),
      };
}
