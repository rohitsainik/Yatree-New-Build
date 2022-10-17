class ProfileData {
  GetUserByCognitoId? getUserByCognitoId;

  ProfileData({this.getUserByCognitoId});

  ProfileData.fromJson(Map<String, dynamic> json) {
    getUserByCognitoId = json['getUserByCognitoId'] != null
        ? new GetUserByCognitoId.fromJson(json['getUserByCognitoId'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.getUserByCognitoId != null) {
      data['getUserByCognitoId'] = this.getUserByCognitoId!.toJson();
    }
    return data;
  }
}

class GetUserByCognitoId {
  String? sTypename;
  int? id;
  String? cognitoId;
  String? name;
  String? email;
  String? phoneNumber;
  Null? aadharNo;
  Null? dlNo;
  Null? age;
  Null? gender;
  Null? autoAssign;
  String? entryBy;
  String? entryDateTime;
  String? updatedDateTime;
  String? userStatus;
  int? roleId;
  String? address;
  Null? photo;
  Null? license;
  Null? aadharCard;
  Null? panCard;
  Null? driverId;

  GetUserByCognitoId(
      {this.sTypename,
        this.id,
        this.cognitoId,
        this.name,
        this.email,
        this.phoneNumber,
        this.aadharNo,
        this.dlNo,
        this.age,
        this.gender,
        this.autoAssign,
        this.entryBy,
        this.entryDateTime,
        this.updatedDateTime,
        this.userStatus,
        this.roleId,
        this.address,
        this.photo,
        this.license,
        this.aadharCard,
        this.panCard,
        this.driverId});

  GetUserByCognitoId.fromJson(Map<String, dynamic> json) {
    sTypename = json['__typename'];
    id = json['id'];
    cognitoId = json['cognitoId'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    aadharNo = json['aadharNo'];
    dlNo = json['dlNo'];
    age = json['age'];
    gender = json['gender'];
    autoAssign = json['autoAssign'];
    entryBy = json['entryBy'];
    entryDateTime = json['entryDateTime'];
    updatedDateTime = json['updatedDateTime'];
    userStatus = json['userStatus'];
    roleId = json['roleId'];
    address = json['address'];
    photo = json['photo'];
    license = json['license'];
    aadharCard = json['aadharCard'];
    panCard = json['panCard'];
    driverId = json['driverId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__typename'] = this.sTypename;
    data['id'] = this.id;
    data['cognitoId'] = this.cognitoId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['aadharNo'] = this.aadharNo;
    data['dlNo'] = this.dlNo;
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['autoAssign'] = this.autoAssign;
    data['entryBy'] = this.entryBy;
    data['entryDateTime'] = this.entryDateTime;
    data['updatedDateTime'] = this.updatedDateTime;
    data['userStatus'] = this.userStatus;
    data['roleId'] = this.roleId;
    data['address'] = this.address;
    data['photo'] = this.photo;
    data['license'] = this.license;
    data['aadharCard'] = this.aadharCard;
    data['panCard'] = this.panCard;
    data['driverId'] = this.driverId;
    return data;
  }
}