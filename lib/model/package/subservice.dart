// To parse this JSON data, do
//
//     final subserviceDataModel = subserviceDataModelFromJson(jsonString);

import 'dart:convert';

SubserviceDataModel subserviceDataModelFromJson(String str) => SubserviceDataModel.fromJson(json.decode(str));

String subserviceDataModelToJson(SubserviceDataModel data) => json.encode(data.toJson());

class SubserviceDataModel {
  SubserviceDataModel({
    this.customListTable,
  });

  List<CustomListTable>? customListTable;

  factory SubserviceDataModel.fromJson(Map<String, dynamic> value) => SubserviceDataModel(
    customListTable: List<CustomListTable>.from(json.decode(value["customListTable"]).map((x) => CustomListTable.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "customListTable": List<dynamic>.from(customListTable!.map((x) => x.toJson())),
  };
}

class CustomListTable {
  CustomListTable({
    this.entryDateTime,
    this.name,
    this.id,
    this.entryBy,
    this.isActive,
    this.serviceId,
    this.updatedDateTime,
  });

  var entryDateTime;
  String? name;
  int? id;
  String? entryBy;
  int? isActive;
  int? serviceId;
  var updatedDateTime;

  factory CustomListTable.fromJson(Map<String, dynamic> json) => CustomListTable(
    entryDateTime: DateTime.parse(json["entryDateTime"]),
    name: json["name"],
    id: json["id"],
    entryBy: json["entryBy"],
    isActive: json["isActive"],
    serviceId: json["serviceId"],
    updatedDateTime: DateTime.parse(json["updatedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "entryDateTime": entryDateTime.toIso8601String(),
    "name": name,
    "id": id,
    "entryBy": entryBy,
    "isActive": isActive,
    "serviceId": serviceId,
    "updatedDateTime": updatedDateTime.toIso8601String(),
  };
}
