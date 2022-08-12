// To parse this JSON data, do
//
//     final adStrip = adStripFromJson(jsonString);

import 'dart:convert';

AdStrip adStripFromJson(String str) => AdStrip.fromJson(json.decode(str));

String adStripToJson(AdStrip data) => json.encode(data.toJson());

class AdStrip {
  AdStrip({
    this.listAdStripMasters,
  });

  List<ListAdStripMaster>? listAdStripMasters;

  factory AdStrip.fromJson(Map<String, dynamic> json) => AdStrip(
    listAdStripMasters: List<ListAdStripMaster>.from(json["listAdStripMasters"].map((x) => ListAdStripMaster.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "listAdStripMasters": List<dynamic>.from(listAdStripMasters!.map((x) => x.toJson())),
  };
}

class ListAdStripMaster {
  ListAdStripMaster({
    this.typename,
    this.id,
    this.description,
    this.isActive,
    this.entryBy,
    this.entryDateTime,
    this.updatedDateTime,
    this.title
  });

  String? typename;
  int? id;
  String? description;
  int? isActive;
  String? entryBy;
  DateTime? entryDateTime;
  DateTime? updatedDateTime;
  var title;

  factory ListAdStripMaster.fromJson(Map<String, dynamic> json) => ListAdStripMaster(
    typename: json["__typename"],
    id: json["id"],
    description: json["description"],
    isActive: json["isActive"],
    entryBy: json["entryBy"],
    title: json["title"],
    entryDateTime: DateTime.parse(json["entryDateTime"]),
    updatedDateTime: DateTime.parse(json["updatedDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "description": description,
    "isActive": isActive,
    "entryBy": entryBy,
    "entryDateTime": entryDateTime!.toIso8601String(),
    "updatedDateTime": updatedDateTime!.toIso8601String(),
    "title":title,
  };
}
