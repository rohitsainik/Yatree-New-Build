// To parse this JSON data, do
//
//     final trendingData = trendingDataFromJson(jsonString);

import 'dart:convert';

TrendingData trendingDataFromJson(String str) => TrendingData.fromJson(json.decode(str));

String trendingDataToJson(TrendingData data) => json.encode(data.toJson());

class TrendingData {
  TrendingData({
    this.listTrendingNow,
  });

  List<ListTrendingNow>? listTrendingNow;

  factory TrendingData.fromJson(Map<String, dynamic> json) => TrendingData(
    listTrendingNow: List<ListTrendingNow>.from(json["listTrendingNow"].map((x) => ListTrendingNow.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "listTrendingNow": List<dynamic>.from(listTrendingNow!.map((x) => x.toJson())),
  };
}

class ListTrendingNow {
  ListTrendingNow({
    this.typename,
    this.id,
    this.name,
    this.image,
    this.url,
  });

  String? typename;
  int? id;
  String? name;
  String? image;
  String? url;

  factory ListTrendingNow.fromJson(Map<String, dynamic> json) => ListTrendingNow(
    typename: json["__typename"],
    id: json["id"],
    name: json["name"],
    image: json["image"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "name": name,
    "image": image,
    "url": url,
  };
}

