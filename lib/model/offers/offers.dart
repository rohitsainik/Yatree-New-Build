// To parse this JSON data, do
//
//     final offerDataModel = offerDataModelFromJson(jsonString);

import 'dart:convert';

OfferDataModel offerDataModelFromJson(String str) => OfferDataModel.fromJson(json.decode(str));

String offerDataModelToJson(OfferDataModel data) => json.encode(data.toJson());

class OfferDataModel {
  OfferDataModel({
    this.listOfferMasters,
  });

  List<ListOfferMaster>? listOfferMasters;

  factory OfferDataModel.fromJson(Map<String, dynamic> json) => OfferDataModel(
    listOfferMasters: List<ListOfferMaster>.from(json["listOfferMasters"].map((x) => ListOfferMaster.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "listOfferMasters": List<dynamic>.from(listOfferMasters!.map((x) => x.toJson())),
  };
}

class ListOfferMaster {
  ListOfferMaster({
    this.typename,
    this.id,
    this.name,
    this.image,
    this.isActive,
    this.entryBy,
    this.entryDateTime,
    this.updatedDateTime,
    this.description,
    this.couponCode,
    this.validUpto
  });

  String? typename;
  int? id;
  String? name;
  String? image;
  int? isActive;
  String? entryBy;
  String? description;
  String? validUpto;
  String? couponCode;
  DateTime? entryDateTime;
  DateTime? updatedDateTime;

  factory ListOfferMaster.fromJson(Map<String, dynamic> json) => ListOfferMaster(
    typename: json["__typename"],
    id: json["id"],
    name: json["name"],
    image: json["image"],
    isActive: json["isActive"],
    validUpto: json["validUpto"],
    entryBy: json["entryBy"],
    entryDateTime: DateTime.parse(json["entryDateTime"]),
    description:json["description"],
    couponCode: json["couponCode"],
    updatedDateTime: DateTime.parse(json["updatedDateTime"],


    ),
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "name": name,
    "image": image,
    "isActive": isActive,
    "entryBy": entryBy,
    "validUpto": validUpto,
    "entryDateTime": entryDateTime!.toIso8601String(),
    "updatedDateTime": updatedDateTime!.toIso8601String(),
    "description": description,
    "couponCode": couponCode,
  };
}
