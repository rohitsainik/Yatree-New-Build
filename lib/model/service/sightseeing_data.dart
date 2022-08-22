// To parse this JSON data, do
//
//     final placelist = placelistFromJson(jsonString);

import 'dart:convert';

Placelist placelistFromJson(String str) => Placelist.fromJson(json.decode(str));

String placelistToJson(Placelist data) => json.encode(data.toJson());

class Placelist {
  Placelist({
    this.listPlaceMasters,
  });

  List<ListPlaceMaster>? listPlaceMasters;

  factory Placelist.fromJson(Map<String, dynamic> json) => Placelist(
    listPlaceMasters: List<ListPlaceMaster>.from(json["listPlaceMasters"].map((x) => ListPlaceMaster.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "listPlaceMasters": List<dynamic>.from(listPlaceMasters!.map((x) => x.toJson())),
  };
}

class ListPlaceMaster {
  ListPlaceMaster({
    this.typename,
    this.isSelected,
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
    this.placeImage
  });

  bool? isSelected = false;
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
  String? placeCategoryName;
  String? placeImage;
  int? placeSubCategoryId;
  dynamic placeSubCategoryName;

  factory ListPlaceMaster.fromJson(Map<String, dynamic> json) => ListPlaceMaster(
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
    placeImage: json["placeImage"],
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
    "placeImage":placeImage
  };
}
