// To parse this JSON data, do
//
//     final spinAround = spinAroundFromJson(jsonString);

import 'dart:convert';

SpinAround spinAroundFromJson(String str) => SpinAround.fromJson(json.decode(str));

String spinAroundToJson(SpinAround data) => json.encode(data.toJson());

class SpinAround {
  SpinAround({
    this.getServicePlaceMapping,
  });

  GetServicePlaceMapping? getServicePlaceMapping;

  factory SpinAround.fromJson(Map<String, dynamic> json) => SpinAround(
    getServicePlaceMapping: GetServicePlaceMapping.fromJson(json["getServicePlaceMapping"]),
  );

  Map<String, dynamic> toJson() => {
    "getServicePlaceMapping": getServicePlaceMapping?.toJson(),
  };
}

class GetServicePlaceMapping {
  GetServicePlaceMapping({
    this.typename,
    this.serviceId,
    this.placeCategoriesData,
  });

  String? typename;
  int? serviceId;
  List<PlaceCategoriesDatum>? placeCategoriesData;

  factory GetServicePlaceMapping.fromJson(Map<String, dynamic> json) => GetServicePlaceMapping(
    typename: json["__typename"],
    serviceId: json["serviceId"],
    placeCategoriesData: List<PlaceCategoriesDatum>.from(json["placeCategoriesData"].map((x) => PlaceCategoriesDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "serviceId": serviceId,
    "placeCategoriesData": List<dynamic>.from(placeCategoriesData!.map((x) => x.toJson())),
  };
}

class PlaceCategoriesDatum {
  PlaceCategoriesDatum({
    this.typename,
    this.placeCategoryId,
    this.placeCategoryName,
    this.placeCategoryImage,
    this.placeData,
  });

  String? typename;
  int? placeCategoryId;
  String? placeCategoryName;
  String? placeCategoryImage;
  List<PlaceDatum>? placeData;

  factory PlaceCategoriesDatum.fromJson(Map<String, dynamic> json) => PlaceCategoriesDatum(
    typename: json["__typename"],
    placeCategoryId: json["placeCategoryId"],
    placeCategoryName: json["placeCategoryName"],
    placeCategoryImage: json["placeCategoryImage"],
    placeData: List<PlaceDatum>.from(json["placeData"].map((x) => PlaceDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "placeCategoryId": placeCategoryId,
    "placeCategoryName": placeCategoryName,
    "placeCategoryImage": placeCategoryImage,
    "placeData": List<dynamic>.from(placeData!.map((x) => x.toJson())),
  };
}

class PlaceDatum {
  PlaceDatum({
    this.typename,
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.entryBy,
    this.entryDateTime,
    this.updatedDateTime,
    this.description,
    this.parentPlaceId,
    this.parentPlaceName,
    this.price,
    this.placeCategoryId,
    this.placeCategoryName,
    this.placeSubCategoryId,
    this.placeSubCategoryName,
  });

  String? typename;
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  String? entryBy;
  DateTime? entryDateTime;
  DateTime? updatedDateTime;
  String? description;
  int? parentPlaceId;
  dynamic parentPlaceName;
  int? price;
  int? placeCategoryId;
  dynamic placeCategoryName;
  int? placeSubCategoryId;
  dynamic placeSubCategoryName;

  factory PlaceDatum.fromJson(Map<String, dynamic> json) => PlaceDatum(
    typename: json["__typename"],
    id: json["id"],
    name: json["name"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    entryBy: json["entryBy"],
    entryDateTime: DateTime.parse(json["entryDateTime"]),
    updatedDateTime: DateTime.parse(json["updatedDateTime"]),
    description: json["description"],
    parentPlaceId: json["parentPlaceId"],
    parentPlaceName: json["parentPlaceName"],
    price: json["price"],
    placeCategoryId: json["placeCategoryId"],
    placeCategoryName: json["placeCategoryName"],
    placeSubCategoryId: json["placeSubCategoryId"],
    placeSubCategoryName: json["placeSubCategoryName"],
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
    "entryBy": entryBy,
    "entryDateTime": entryDateTime,
    "updatedDateTime": updatedDateTime,
    "description": description,
    "parentPlaceId": parentPlaceId,
    "parentPlaceName": parentPlaceName,
    "price": price,
    "placeCategoryId": placeCategoryId,
    "placeCategoryName": placeCategoryName,
    "placeSubCategoryId": placeSubCategoryId,
    "placeSubCategoryName": placeSubCategoryName,
  };
}
