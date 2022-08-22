import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:yatree/model/asStrip.dart';
import 'package:yatree/model/discountList.dart';
import 'package:yatree/model/offers/offers.dart';
import 'package:yatree/model/package/packageData.dart';
import 'package:yatree/model/ride/ride_master_modle.dart';
import 'package:yatree/model/ride/ride_modle.dart';
import 'package:yatree/model/serive.dart';
import 'package:yatree/model/service/sightseeing.dart';
import 'package:yatree/model/service/spinaround.dart';
import 'package:yatree/utils/sharedPreference.dart';

getUserMasterData() async {
  print("id");
  SharedPref pref = SharedPref();
  var id = await pref.getUserId();
  print(id);
  try {
    String graphQLDocument = '''query GetUserMaster($id: Int!) {
        getUserMaster(id: $id) {
          __typename
          id
          cognitoId
          name
          email
          phoneNumber
          aadharNo
          dlNo
          age
          gender
          autoAssign
          entryBy
          entryDateTime
          updatedDateTime
          userStatus
          roleId
          address
          photo
          license
          aadharCard
          panCard
          driverId
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;

    print('Auto Master result: ' + data!);
  } catch (e) {
    print('Query failed: $e');
  }
}

// get Package Data
// getPackageData() async {
//   try {
//     String graphQLDocument = '''query ListPackageMasters {
//         listPackageMasters {
//           __typename
//           id
//           name
//           description
//           serviceId
//           duration
//           price
//           entryBy
//           entryDateTime
//           updatedDateTime
//           categoryId
//           isActive
//           fromTime
//           toTime
//           subServiceId
//         }
//       }''';
//
//     var operation = Amplify.API.query(
//         request: GraphQLRequest<String>(
//           document: graphQLDocument,
//         ));
//
//     var response = await operation.response;
//     var data = response.data;
//     print('Package data result: ' + data);
//     PackageListModel pacakgeListData = packageListModelFromJson(data);
//     return pacakgeListData;
//
//   } catch (e) {
//     print('Query failed: $e');
//   }
// }

//get sub Service
/*getSubService() async {

  try {
    String graphQLDocument = '''query ListSubServiceMasters {
        listSubServiceMasters {
          __typename
          id
          name
          isActive
          entryBy
          entryDateTime
          updatedDateTime
          serviceId
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
          document: graphQLDocument,
        ));

    var response = await operation.response;
    var data = response.data;
    print('sub service result: ' + data);
    SubServiceModel subservicedata = SubServiceModel.fromJson(json.decode(data));

    return subservicedata;

    //  print('sub service result: ' + subservicedata.listSubServiceMasters!.length.toString());
  } catch (e) {
    print('Query failed: $e');
  }
}*/

//get auto data
getAutoMasterData() async {
  try {
    String graphQLDocument = '''query ListAutoMasters {
        listAutoMasters {
          __typename
          id
          regNo
          uniqueNo
          insuranceDate
          renewalPeriod
          rcNo
          entryBy
          entryDateTime
          updatedDateTime
          rc
          insurance
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;

    print('Auto Master result: ' + data!);
  } catch (e) {
    print('Query failed: $e');
  }
}

//get booking Master
getBookingMasterData() async {
  try {
    String graphQLDocument = '''query ListBookingMasters {
    listBookingMasters {
      __typename
      id
      packageId
      time
      date
      totalAdult
      totalChild
      basePrice
      tax
      discountId
      totalAmount
      status
      userId
      entryBy
      entryDateTime
      updatedDateTime
    }
  }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;

    print('booking Master result: ' + data!);
  } catch (e) {
    print('Query failed: $e');
  }
}

getOfferMasterData() async {
  try {
    String graphQLDocument = '''query ListOfferMasters {
        listOfferMasters {
          __typename
          id
          name
          image
          isActive
          entryBy
          entryDateTime
          updatedDateTime
          description
          couponCode
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;
    print('Offer Master result: ' + data!);
    OfferDataModel offerData = OfferDataModel.fromJson(json.decode(data));
    return offerData;
  } catch (e) {
    print('offer Query failed: $e');
  }
}

getFaqMasterData() async {
  try {
    String graphQLDocument = '''query ListFaqMasters {
  listFaqMasters {
    id
    question
    answer
    entryBy
    entryDateTime
    updatedDateTime
  }
}''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;
    print('faq Master result: ' + data!);
    var faqData = json.decode(data);
    return faqData;
  } catch (e) {
    print('faq Master failed: $e');
  }
}

//get discount Master
getDiscountMasterData() async {
  try {
    String graphQLDocument = '''query ListDiscountMasters {
        listDiscountMasters {
          __typename
          id
          type
          couponCode
          amount
          amountType
          serviceId
          subServiceId
          packageId
          fromDate
          toDate
          locationLongitude
          locationLatitude
          entryBy
          entryDateTime
          updatedDateTime
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;
    print('Offer Master result: ' + data!);
    OfferDataModel offerData = OfferDataModel.fromJson(json.decode(data));
    return offerData;
  } catch (e) {
    print('offer Query failed: $e');
  }
}

//get reviewList
getReviewData() async {
  try {
    String graphQLDocument = '''query ListReviewMasters {
        listReviewMasters {
          __typename
          id
          rideId
          description
          rating
          userId
          entryBy
          entryDateTime
          updatedDateTime
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;

    print('review Master result: ' + data!);
  } catch (e) {
    print('Query failed: $e');
  }
}

//get packageDetails
getPackageDetailsData(
    {var serviceId, subServiceId, currentTime, packageId, categoryId}) async {
  try {
    String graphQLDocument =
        '''query GetPackagesDetails(\$serviceId: Int!, \$subServiceId: Int!, \$currentTime: String!, \$packageId: Int!, \$categoryId: Int!) {
  getPackagesDetails(serviceId: \$serviceId, subServiceId: \$subServiceId, currentTime: \$currentTime, packageId: \$packageId, categoryId: \$categoryId) {
    package_id
    package_name
    package_description
    package_total_duration
    package_price
    serviceId
    service_name
    subServiceId
    sub_service_name
    isActive
    fromTime
    toTime
    place_count
    categoryId
    categoryName
    PackagePlaceMappingDetails {
      description
      packageId
      placeId
      place_name
      duration
      latitude
      longitude
      imageName
      imageLocation
    }
    PackageDiscountDetails {
      discountId
      type
      couponCode
      amount
      amountType
      packageId
    }
  }
}''';
    var variables = {
      "serviceId": serviceId,
      "subServiceId": subServiceId,
      "currentTime": currentTime,
      "packageId": packageId,
      "categoryId": categoryId
    };

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: variables));

    var response = await operation.response;
    var data = response.data;
    print('package Master result: ' + data!);
    print('package Master result: ' + response.errors.toString());

    AllPackageDataModel newpackageData =
        AllPackageDataModel.fromJson(json.decode(data));
    return newpackageData;

    print('review Master result: ' + data);
  } catch (e) {
    print('getPackageDetailsData Query failed: $e');
  }
}

//getservedata
getServiceData() async {
  try {
    String graphQLDocument = '''query ListServiceMasters {
        listServiceMasters {
          __typename
          id
          name
          paymentType
          entryBy
          entryDateTime
          updatedDateTime
          isActive
          price
          image
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;

    print('service result: ' + data!);
    ServiceDataModel servicedata = ServiceDataModel.fromJson(json.decode(data));
    return servicedata;
  } catch (e) {
    print('Query failed: $e');
  }
}

//getMyrideData

getUserRide({var customerId}) async {
  try {
    String graphQLDocument =
        '''query GetUserRides(\$customerId: String, \$driverId: String) {
        getUserRides(customerId: \$customerId, driverId: \$driverId) {
          __typename
          id
          bookingId
          rideDuration
          rideType
          rideStartDateTime
          packageName
          status
          rideEndDateTime
          entryDateTime
          userId
          driverId
          customerName
          driverName
          imageLocation
          regNo
          driverImage
          packageId
          basePrice
          totalAmount
          tax
          driverPhoneNumber
          autoId
        
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument,
            variables: {"customerId": customerId, "driverId": null}));

    var response = await operation.response;
    var data = response.data;

    print('user ride result: ' + data!);
    print('user ride error: ' + response.errors.toString());
    RideModel ride = RideModel.fromJson(json.decode(data));
    return ride;
  } catch (e) {
    print('Query failed: $e');
  }
}

//getrider master
getRideMaster({var id}) async {
  try {
    String graphQLDocument = '''query GetRideMaster(\$id: Int!) {
        getRideMaster(id: \$id) {
          __typename
          id
          bookingId
          userId
          rideDuration
          rideStartDateTime
          rideEndDateTime
          driverId
          status
          entryBy
          entryDateTime
          updatedDateTime
          otp
          rideType
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: {
      "id": id,
    }));

    var response = await operation.response;
    var data = response.data;
    print('Ride Master Response' + response.toString());
    print('Ride Master result: ' + data!);
    print('Ride Master error: ' + response.errors.toString());
    RideMasterModel ride = RideMasterModel.fromJson(json.decode(data));
    return ride;
  } catch (e) {
    print('Query failed: $e');
  }
}

//UpdateEndpoint
UpdateEndpoint({var userId, token}) async {
  try {
    String graphQLDocument =
        '''query UpdateEndpoint(\$userId: String!, \$token: String!) {
        updateEndpoint(userId: \$userId, token: \$token)
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument,
            variables: {"userId": userId, "token": token}));

    var response = await operation.response;
    var data = response.data;

    print('UpdateEndpoint result: ' + data!);
    print('UpdateEndpoint error: ' + response.errors.toString());
  } catch (e) {
    print('Query failed: $e');
  }
}

//UpdateEndpoint
GetCategoryMaster({var userId, token}) async {
  try {
    String graphQLDocument = '''query GetPackageCategoryMaster(\$id: Int!) {
        getPackageCategoryMaster(id: \$id) {
          __typename
          id
          categoryName
          entryBy
          entryDateTime
          updatedDateTime
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument,
            variables: {"userId": userId, "token": token}));

    var response = await operation.response;
    var data = response.data;

    print('UpdateEndpoint result: ' + data!);
    print('UpdateEndpoint error: ' + response.errors.toString());
  } catch (e) {
    print('Query failed: $e');
  }
}

AdStripList() async {
  try {
    String graphQLDocument = '''query ListAdStripMasters {
        listAdStripMasters {
          __typename
          id
          description
          isActive
          entryBy
          entryDateTime
          updatedDateTime
          title
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument,
    ));

    var response = await operation.response;
    var data = response.data;

    print('adStrip result: ' + data!);
    print('adStrip error: ' + response.errors.toString());
    AdStrip ride = AdStrip.fromJson(json.decode(data));
    return ride;
  } catch (e) {
    print('Query failed: $e');
  }
}

getServicePlaceMapping() async {
  try {
    String graphQLDocument = '''query GetServicePlaceMapping(\$serviceId: Int!) {
        getServicePlaceMapping(serviceId: \$serviceId) {
          __typename
          serviceId
          placeCategoriesData {
            __typename
            placeCategoryId
            placeCategoryName
            placeCategoryImage
            placeData {
              __typename
              id
              name
              latitude
              longitude
              entryBy
              entryDateTime
              updatedDateTime
              description
              parentPlaceId
              parentPlaceName
              price
              placeCategoryId
              placeCategoryName
              placeSubCategoryId
              placeSubCategoryName
            }
          }
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument, variables: {"serviceId": 13}
    ));

    var response = await operation.response;
    var data = response.data;

    SpinAround spinData = SpinAround.fromJson(json.decode(data.toString()));

    print('service mapping result: ' + data!);
    print('adStrip error: ' + response.errors.toString());
    return spinData;
  } catch (e) {
    print('service mapping  Query failed: $e');
  }
}


getListPlaceMaster() async {
  try {
    String graphQLDocument = '''query ListPlaceMasters(\$placeCategoryId: Int!, \$placeSubCategoryId: Int!) {
        listPlaceMasters(placeCategoryId: \$placeCategoryId, placeSubCategoryId: \$placeSubCategoryId) {
          __typename
          id
          name
          latitude
          longitude
          entryBy
          entryDateTime
          updatedDateTime
          description
          parentPlaceId
          parentPlaceName
          price
          placeCategoryId
          placeCategoryName
          placeSubCategoryId
          placeSubCategoryName
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
      document: graphQLDocument, variables: {"placeCategoryId": -1,"placeSubCategoryId":-1}
    ));

    var response = await operation.response;
    var data = response.data;

    Placelist placeData = Placelist.fromJson(json.decode(data.toString()));

    print('places list result: ' + data!);
    print('places error: ' + response.errors.toString());
    return placeData;
  } catch (e) {
    print('places list Query failed: $e');
  }
}


getRideDetail({var id}) async {
  try {
    String graphQLDocument = '''query GetRideDetails(\$id: Int!) {
        getRideDetails(id: \$id) {
          __typename
          id
          rideId
          startLocationLongitude
          startLocationLatitude
          endLocationLongitude
          endLocationLatitude
          startDateTime
          endDateTime
          entryBy
          entryDateTime
          updatedDateTime
          startLocationName
          endLocationName
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: {"id": id}));

    var response = await operation.response;
    var data = response.data;

    print('GetRideDetails result: ' + data!);
    print('GetRideDetails error: ' + response.errors.toString());
    // AdStrip ride = AdStrip.fromJson(json.decode(data));
    // return ride;

  } catch (e) {
    print('Query failed: $e');
  }
}

getDiscountData(
    {var serviceId,
    subServiceId,
    packageId,
    locationLatitude,
    locationLongitude,
    bookingDate}) async {
  try {
    String graphQLDocument =
        '''query GetDiscountData(\$serviceId: Int!, \$subServiceId: Int!, \$packageId: Int!, \$locationLatitude: Float, \$locationLongitude: Float, \$bookingDate: Date) {
        getDiscountData(serviceId: \$serviceId, subServiceId: \$subServiceId, packageId: \$packageId, locationLatitude: \$locationLatitude, locationLongitude: \$locationLongitude, bookingDate: \$bookingDate) {
          __typename
          id
          type
          couponCode
          amount
          amountType
          applicableOn
        }
      }''';

    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: {
      "serviceId": serviceId,
      "subServiceId": subServiceId,
      "packageId": packageId,
      "locationLatitude": locationLatitude,
      "locationLongitude": locationLongitude,
      "bookingDate": bookingDate,
    }));

    var response = await operation.response;
    var data = response.data;

    print('GetDiscountData result: ' + data!);
    print('GetDiscountData error: ' + response.errors.toString());
    Discount discount = Discount.fromJson(json.decode(data));

    return discount;
  } catch (e) {
    print('Query failed: $e');
  }
}

sendRentalData(
    {var passengerEmail,
    passengerName,
    noOfAutos,
    passengerPhone,
    entryBy,
    entryDateTime,
    updatedDateTime,
    locationName,
    startDate,
    startTime,
    userId}) async {
  try {
    //todo create
    String graphQLDocument =
        '''mutation CreateEvRentalQueryMaster(\$createEvRentalQueryMasterInput: CreateEvRentalQueryMasterInput!) {
  createEvRentalQueryMaster(createEvRentalQueryMasterInput: \$createEvRentalQueryMasterInput) {
    id
    name
    phoneNo
    email
    noOfAutos
    locationName
    pickupDate
    pickupTime
    entryBy
    entryDateTime
    updatedDateTime
  }
}''';

    var variables = {
      "createEvRentalQueryMasterInput": {
        "id": 0,
        "name": passengerName,
        "phoneNo": passengerPhone,
        "email": passengerEmail,
        "noOfAutos": noOfAutos,
        "locationName": locationName,
        "pickupDate": startDate,
        "pickupTime": startTime,
        "entryBy": entryBy,
        "entryDateTime": entryDateTime,
        "updatedDateTime": updatedDateTime,
      }
    };
    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: variables));

    var response = await operation.response;
    var data = response.data;

    print('data detail result: ' + data!);
    print('data detail result: ' + response.errors.toString());

    var value = json.decode(data);

    return value;
  } catch (e) {
    print('getCustomTableData Query failed: $e');
  }
}


createCustomPackage(
    {var id,
      placeId,
    name,
    description,
    serviceId,
    duration,
    price,
    entryBy,
      entryDateTime,
      updatedDateTime,
      categoryId,
      isActive,fromTime,toTime,
      subServiceId,buffer,
      isCreatedByCustomer
    }) async {
  try {
    SharedPref pref = SharedPref();
    var userId = await pref.getUserId();
    String graphQLDocument =
        '''mutation CreateCustomerPackages(\$createCustomerPackagesInput: CreateCustomerPackagesInput) {
        createCustomerPackages(createCustomerPackagesInput: \$createCustomerPackagesInput) {
          __typename
          id
          name
          description
          serviceId
          duration
          price
          entryBy
          entryDateTime
          updatedDateTime
          categoryId
          isActive
          fromTime
          toTime
          subServiceId
          buffer
          isCreatedByCustomer
        }
      }''';

    var custompackdetail = {
      "id": 0,
      "name": name,
      "description": description,
      "serviceId": serviceId,
      "duration":0,
      "price": price,
      "entryBy": userId,
      "entryDateTime": DateTime.now().toIso8601String(),
      "updatedDateTime": DateTime.now().toIso8601String(),
      "categoryId": categoryId,
      "isActive": true,
      // "fromTime": String,
      // "toTime": String,
      // "subServiceId": Int,
      // "buffer": Int,
      // "isCreatedByCustomer": Int,
    };
    var variables = {
      "CreateCustomerPackagesInput": {
        "createCustomerPackagesInput": custompackdetail,
        "placeIds":placeId,
        "userId":userId,
      }

    };

    print('custom package request body $variables');
    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: variables));

    var response = await operation.response;
    var data = response.data;

    print('custom package detail result: ' + data!);
    print('custom package result: ' + response.errors.toString());

    var value = json.decode(data);

    return value;
  } catch (e) {
    print('getCustomTableData Query failed: $e');
  }
}
