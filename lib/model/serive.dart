// To parse this JSON data, do
//
//     final serviceDataModel = serviceDataModelFromJson(jsonString);

import 'dart:convert';

ServiceDataModel serviceDataModelFromJson(String str) => ServiceDataModel.fromJson(json.decode(str));

String serviceDataModelToJson(ServiceDataModel data) => json.encode(data.toJson());

class ServiceDataModel {
  ServiceDataModel({
    this.listServiceMasters,
  });

  List<ListServiceMaster>? listServiceMasters;

  factory ServiceDataModel.fromJson(Map<String, dynamic> json) => ServiceDataModel(
    listServiceMasters: List<ListServiceMaster>.from(json["listServiceMasters"].map((x) => ListServiceMaster.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "listServiceMasters": List<dynamic>.from(listServiceMasters!.map((x) => x.toJson())),
  };
}

class ListServiceMaster {
  ListServiceMaster({
    this.typename,
    this.id,
    this.name,
    this.paymentType,
    this.entryBy,
    this.entryDateTime,
    this.updatedDateTime,
    this.isActive,
    this.price,
    this.image
  });

  String? typename;
  int? id;
  String? name;
  int? paymentType;
  String? entryBy;
  var entryDateTime;
  var updatedDateTime;
  int? isActive;
  var price;
  var image;

  factory ListServiceMaster.fromJson(Map<String, dynamic> json) => ListServiceMaster(
    typename: json["__typename"],
    id: json["id"],
    name: json["name"],
    paymentType: json["paymentType"],
    entryBy: json["entryBy"],
    entryDateTime: json["entryDateTime"],
    updatedDateTime: json["updatedDateTime"],
    isActive: json["isActive"],
    price: json["price"],
      image:json["image"]
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "name": name,
    "paymentType": paymentType,
    "entryBy": entryBy,
    "entryDateTime": entryDateTime.toIso8601String(),
    "updatedDateTime": updatedDateTime.toIso8601String(),
    "isActive": isActive,
    "price":price,
    "image":image
  };
}
