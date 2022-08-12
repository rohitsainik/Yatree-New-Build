// To parse this JSON data, do
//
//     final discount = discountFromJson(jsonString);

import 'dart:convert';

Discount discountFromJson(String str) => Discount.fromJson(json.decode(str));

String discountToJson(Discount data) => json.encode(data.toJson());

class Discount {
  Discount({
    this.getDiscountData,
  });

  List<GetDiscountDatum>? getDiscountData;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
    getDiscountData: List<GetDiscountDatum>.from(json["getDiscountData"].map((x) => GetDiscountDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {

    "getDiscountData": List<dynamic>.from(getDiscountData!.map((x) => x.toJson())),
  };
}

class GetDiscountDatum {
  GetDiscountDatum({
    this.typename,
    this.id,
    this.type,
    this.couponCode,
    this.amount,
    this.amountType,
    this.applicableOn,
  });

  String? typename;
  int? id;
  int? type;
  String? couponCode;
  int? amount;
  int? amountType;
  String? applicableOn;

  factory GetDiscountDatum.fromJson(Map<String, dynamic> json) => GetDiscountDatum(
    typename: json["__typename"],
    id: json["id"],
    type: json["type"],
    couponCode: json["couponCode"],
    amount: json["amount"],
    amountType: json["amountType"],
    applicableOn: json["applicableOn"],
  );

  Map<String, dynamic> toJson() => {
    "__typename": typename,
    "id": id,
    "type": type,
    "couponCode": couponCode,
    "amount": amount,
    "amountType": amountType,
    "applicableOn": applicableOn,
  };
}
