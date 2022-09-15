// To parse this JSON data, do
//
//     final spinAround = spinAroundFromJson(jsonString);

import 'dart:convert';

import 'package:yatree/model/service/sightseeing.dart';

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
  List<ListPlaceMaster>? placeData;

  factory PlaceCategoriesDatum.fromJson(Map<String, dynamic> json) => PlaceCategoriesDatum(
    typename: json["__typename"],
    placeCategoryId: json["placeCategoryId"],
    placeCategoryName: json["placeCategoryName"],
    placeCategoryImage: json["placeCategoryImage"],
    placeData: List<ListPlaceMaster>.from(json["placeData"].map((x) => ListPlaceMaster.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "placeCategoryId": placeCategoryId,
    "placeCategoryName": placeCategoryName,
    "placeCategoryImage": placeCategoryImage,
    "placeData": List<dynamic>.from(placeData!.map((x) => x.toJson())),
  };
}

