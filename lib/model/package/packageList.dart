// // To parse this JSON data, do
// //
// //     final packageListModel = packageListModelFromJson(jsonString);
//
// import 'dart:convert';
//
// PackageListModel packageListModelFromJson(String str) => PackageListModel.fromJson(json.decode(str));
//
// String packageListModelToJson(PackageListModel data) => json.encode(data.toJson());
//
// class PackageListModel {
//   PackageListModel({
//     this.listPackageMasters,
//   });
//
//   List<ListPackageMaster>? listPackageMasters;
//
//   factory PackageListModel.fromJson(Map<String, dynamic> json) => PackageListModel(
//     listPackageMasters: List<ListPackageMaster>.from(json["listPackageMasters"].map((x) => ListPackageMaster.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "listPackageMasters": List<dynamic>.from(listPackageMasters!.map((x) => x.toJson())),
//   };
// }
//
// class ListPackageMaster {
//   ListPackageMaster({
//     this.categoryId,
//     this.description,
//     this.duration,
//     this.entryBy,
//     this.entryDateTime,
//     this.fromTime,
//     this.id,
//     this.isActive,
//     this.name,
//     this.price,
//     this.serviceId,
//     this.subServiceId,
//     this.toTime,
//     this.updatedDateTime,
//   });
//
//   int? categoryId;
//   String? description;
//   int? duration;
//   String? entryBy;
//   var entryDateTime;
//   String? fromTime;
//   int? id;
//   int? isActive;
//   String? name;
//   int? price;
//   int? serviceId;
//   int? subServiceId;
//   String? toTime;
//   var updatedDateTime;
//
//   factory ListPackageMaster.fromJson(Map<String, dynamic> json) => ListPackageMaster(
//     categoryId: json["categoryId"] == null ? null : json["categoryId"],
//     description: json["description"],
//     duration: json["duration"],
//     entryBy: json["entryBy"],
//     entryDateTime: DateTime.parse(json["entryDateTime"]),
//     fromTime: json["fromTime"] == null ? null : json["fromTime"],
//     id: json["id"],
//     isActive: json["isActive"],
//     name: json["name"],
//     price: json["price"],
//     serviceId: json["serviceId"],
//     subServiceId: json["subServiceId"] == null ? null : json["subServiceId"],
//     toTime: json["toTime"] == null ? null : json["toTime"],
//     updatedDateTime: DateTime.parse(json["updatedDateTime"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "categoryId": categoryId == null ? null : categoryId,
//     "description": description,
//     "duration": duration,
//     "entryBy": entryBy,
//     "entryDateTime": entryDateTime.toIso8601String(),
//     "fromTime": fromTime == null ? null : fromTime,
//     "id": id,
//     "isActive": isActive,
//     "name": name,
//     "price": price,
//     "serviceId": serviceId,
//     "subServiceId": subServiceId == null ? null : subServiceId,
//     "toTime": toTime == null ? null : toTime,
//     "updatedDateTime": updatedDateTime.toIso8601String(),
//   };
// }
