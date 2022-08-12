// To parse this JSON data, do
//
//     final allPackageDataModel = allPackageDataModelFromJson(jsonString);

import 'dart:convert';

AllPackageDataModel allPackageDataModelFromJson(String str) => AllPackageDataModel.fromJson(json.decode(str));

String allPackageDataModelToJson(AllPackageDataModel data) => json.encode(data.toJson());

class AllPackageDataModel {
  AllPackageDataModel({
    this.getPackagesDetails,
  });

  List<GetPackagesDetail>? getPackagesDetails;

  factory AllPackageDataModel.fromJson(Map<String, dynamic> json) => AllPackageDataModel(
    getPackagesDetails: List<GetPackagesDetail>.from(json["getPackagesDetails"].map((x) => GetPackagesDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "getPackagesDetails": List<dynamic>.from(getPackagesDetails!.map((x) => x.toJson())),
  };
}

class GetPackagesDetail {
  GetPackagesDetail({
    this.typename,
    this.packageId,
    this.packageName,
    this.packageDescription,
    this.packageTotalDuration,
    this.packagePrice,
    this.serviceId,
    this.serviceName,
    this.subServiceId,
    this.subServiceName,
    this.isActive,
    this.fromTime,
    this.toTime,
    this.placeCount,
    this.packagePlaceMappingDetails,
    this.categoryId,
    this.categoryName,
    this.packageDiscountDetails,
  });

  String? typename;
  int? packageId;
  String? packageName;
  String? packageDescription;
  int? packageTotalDuration;
  int? packagePrice;
  int? serviceId;
  String? serviceName;
  int? subServiceId;
  String? subServiceName;
  int? isActive;
  String? fromTime;
  String? toTime;
  int? placeCount;
  var categoryId;
  var categoryName;
  List<PackagePlaceMappingDetail>? packagePlaceMappingDetails;
  List<PackageDiscountDetail>? packageDiscountDetails;


  factory GetPackagesDetail.fromJson(Map<String, dynamic> json) => GetPackagesDetail(
    typename: json["__typename"],
    packageId: json["package_id"],
    packageName: json["package_name"],
    packageDescription: json["package_description"],
    packageTotalDuration: json["package_total_duration"],
    packagePrice: json["package_price"],
    serviceId: json["serviceId"],
    serviceName: json["service_name"],
    subServiceId: json["subServiceId"],
    subServiceName: json["sub_service_name"],
    isActive: json["isActive"],
    fromTime: json["fromTime"],
    toTime: json["toTime"],
    categoryId:json["categoryId"],
    categoryName:json["categoryName"],
    placeCount: json["place_count"],
    packagePlaceMappingDetails: List<PackagePlaceMappingDetail>.from(json["PackagePlaceMappingDetails"].map((x) => PackagePlaceMappingDetail.fromJson(x))),
    packageDiscountDetails: List<PackageDiscountDetail>.from(json["PackageDiscountDetails"].map((x) => PackageDiscountDetail.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "package_id": packageId,
    "package_name": packageName,
    "package_description": packageDescription,
    "package_total_duration": packageTotalDuration,
    "package_price": packagePrice,
    "serviceId": serviceId,
    "service_name": serviceName,
    "subServiceId": subServiceId,
    "sub_service_name": subServiceName,
    "isActive": isActive,
    "fromTime": fromTime,
    "toTime": toTime,
    "place_count": placeCount,
    "categoryId":categoryId,
    "categoryName":categoryName,
    "PackagePlaceMappingDetails": List<dynamic>.from(packagePlaceMappingDetails!.map((x) => x.toJson())),
    "PackageDiscountDetails": List<dynamic>.from(packageDiscountDetails!.map((x) => x.toJson())),
  };
}

class PackageDiscountDetail {
  PackageDiscountDetail({
    this.discountId,
    this.type,
    this.couponCode,
    this.amount,
    this.amountType,
    this.packageId,
  });

  int? discountId;
  int? type;
  String? couponCode;
  int? amount;
  int? amountType;
  int? packageId;

  factory PackageDiscountDetail.fromJson(Map<String, dynamic> json) => PackageDiscountDetail(
    discountId: json["discountId"],
    type: json["type"],
    couponCode: json["couponCode"],
    amount: json["amount"],
    amountType: json["amountType"],
    packageId: json["packageId"],
  );

  Map<String, dynamic> toJson() => {
    "discountId": discountId,
    "type": type,
    "couponCode": couponCode,
    "amount": amount,
    "amountType": amountType,
    "packageId": packageId,
  };
}

class PackagePlaceMappingDetail {
  PackagePlaceMappingDetail({
    this.typename,
    this.packageId,
    this.placeId,
    this.placeName,
    this.duration,
    this.latitude,
    this.longitude,
    this.imageName,
    this.imageLocation,
    this.description
  });

  String? typename;
  int? packageId;
  int? placeId;
  String? placeName;
  int? duration;
  double? latitude;
  double? longitude;
  String? imageName;
  String? imageLocation;
  var description;

  factory PackagePlaceMappingDetail.fromJson(Map<String, dynamic> json) => PackagePlaceMappingDetail(
    typename: json["__typename"],
    packageId: json["packageId"],
    placeId: json["placeId"],
    placeName: json["place_name"],
    duration: json["duration"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    imageName: json["imageName"],
    imageLocation: json["imageLocation"],
      description:json['description']
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "packageId": packageId,
    "placeId": placeId,
    "place_name": placeName,
    "duration": duration,
    "latitude": latitude,
    "longitude": longitude,
    "imageName": imageName,
    "imageLocation": imageLocation,
    "description":description,
  };
}
