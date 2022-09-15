// To parse this JSON data, do
//
//     final newPackageList = newPackageListFromJson(jsonString);

import 'dart:convert';

NewPackageList newPackageListFromJson(String str) => NewPackageList.fromJson(json.decode(str));

String newPackageListToJson(NewPackageList data) => json.encode(data.toJson());

class NewPackageList {
  NewPackageList({
    this.createCustomerPackages,
  });

  CreateCustomerPackages? createCustomerPackages;

  factory NewPackageList.fromJson(Map<String, dynamic> json) => NewPackageList(
    createCustomerPackages: CreateCustomerPackages.fromJson(json["createCustomerPackages"]),
  );

  Map<String, dynamic> toJson() => {
    "createCustomerPackages": createCustomerPackages?.toJson(),
  };
}

class CreateCustomerPackages {
  CreateCustomerPackages({
    this.typename,
    this.id,
    this.name,
    this.description,
    this.serviceId,
    this.duration,
    this.price,
    this.entryBy,
    this.entryDateTime,
    this.updatedDateTime,
    this.categoryId,
    this.isActive,
    this.fromTime,
    this.toTime,
    this.subServiceId,
    this.buffer,
    this.isCreatedByCustomer,
  });

  String? typename;
  int? id;
  String? name;
  String? description;
  int? serviceId;
  int? duration;
  int? price;
  String? entryBy;
  DateTime? entryDateTime;
  DateTime? updatedDateTime;
  int? categoryId;
  int? isActive;
  dynamic fromTime;
  dynamic toTime;
  dynamic subServiceId;
  int? buffer;
  int? isCreatedByCustomer;

  factory CreateCustomerPackages.fromJson(Map<String, dynamic> json) => CreateCustomerPackages(
    typename: json["__typename"],
    id: json["id"],
    name: json["name"],
    description: json["description"],
    serviceId: json["serviceId"],
    duration: json["duration"],
    price: json["price"],
    entryBy: json["entryBy"],
    entryDateTime: DateTime.parse(json["entryDateTime"]),
    updatedDateTime: DateTime.parse(json["updatedDateTime"]),
    categoryId: json["categoryId"],
    isActive: json["isActive"],
    fromTime: json["fromTime"],
    toTime: json["toTime"],
    subServiceId: json["subServiceId"],
    buffer: json["buffer"],
    isCreatedByCustomer: json["isCreatedByCustomer"],
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "name": name,
    "description": description,
    "serviceId": serviceId,
    "duration": duration,
    "price": price,
    "entryBy": entryBy,
    "entryDateTime": entryDateTime,
    "updatedDateTime": updatedDateTime,
    "categoryId": categoryId,
    "isActive": isActive,
    "fromTime": fromTime,
    "toTime": toTime,
    "subServiceId": subServiceId,
    "buffer": buffer,
    "isCreatedByCustomer": isCreatedByCustomer,
  };
}
