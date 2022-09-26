import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:yatree/utils/commonFunctions.dart';

setBookingData(
    {var totalAdult,
      totalChild,
      basePrice,
      totalAmount,
      tax,
      time,
      date,
      discountId,
      packageId,
      entryBy,
      updatedDateTime,
      entryDateTime,
      status,
      personName,
      personEmail,
      personmobileNumber,
      userId}) async {
  String graphQLDocument =
  '''mutation CreateBookingMaster(\$createBookingMasterInput: CreateBookingMasterInput!) {
        createBookingMaster(createBookingMasterInput: \$createBookingMasterInput) {
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

  var variables = {
    "createBookingMasterInput": {
      "id":0,
      "totalAdult": totalAdult,
      "totalChild": totalChild,
      "packageId": packageId,
      "time": time,
      "date": date,
      "totalAmount": totalAmount,
      "basePrice":basePrice,
      "tax": double.parse(tax),
      "status": int.parse(status.toString()),
      "userId": userId,
      "entryBy": entryBy,
      "discountId":discountId,
      "entryDateTime": entryDateTime,
      "updatedDateTime": updatedDateTime,
    }
  };
  var operation = Amplify.API.query(
      request: GraphQLRequest<String>(
          document: graphQLDocument, variables: variables));



  var response = await operation.response;

  print('booking data result: ' + operation.response.toString());
  print('data error: ' + response.errors.toString());

  var data = json.decode(response.data.toString());
  // showToast(message: "Booking Confirmed");
  // showToast(message: "Payment Failed");
  // Get.back();





  // var value = json.decode(data);

  return data;
}

setCustomDetailData(
    {var passengerEmail,
      bookingId,
      passengerName,
      totalAmount,
      passengerPhone,
      entryBy,
      entryDateTime,
      tax,
      discountId,
      status,
      updatedDateTime,
      userId}) async {
  try {
    //todo create
    String graphQLDocument =
    '''mutation CreateBookingPassengerDetails(\$createBookingPassengerDetailsInput: CreateBookingPassengerDetailsInput!) {
        createBookingPassengerDetails(createBookingPassengerDetailsInput: \$createBookingPassengerDetailsInput) {
          __typename
          id
          bookingId
          passengerEmail
          passengerPhone
          passengerName
          entryBy
          entryDateTime
          updatedDateTime
        }
      }''';

    var variables = {
      "createBookingPassengerDetailsInput": {
        "id":0,
        "bookingId": bookingId,
        "passengerEmail": passengerEmail,
        "passengerPhone": passengerPhone,
        "passengerName": passengerName,
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
    print('data detail result: ' + response.errors.toString() );

    var value = json.decode(data);

    return value;
  } catch (e) {
    print('getCustomTableData Query failed: $e');
  }

}


createOrderMaster({var bookingId,status,enterBy,entryDateTime,updateTime}) async{

  String graphQLDocument =

  '''mutation CreateOrderMaster(\$createOrderMasterInput: CreateOrderMasterInput!) {
        createOrderMaster(createOrderMasterInput: \$createOrderMasterInput) {
          __typename
          id
          bookingId
          status
          entryBy
          entryDateTime
          updatedDateTime
        }
        }
     ''';

  var variables = {
    "createOrderMasterInput": {
      "id": 0,
      "bookingId": bookingId,
      "status": status,
      "entryBy": enterBy,
      "entryDateTime": entryDateTime,
      "updatedDateTime": updateTime,
    }
  };

  print("--------------------------------------------------------------");
  print(variables);
  print("--------------------------------------------------------------");

  var operation = Amplify.API.mutate(
      request: GraphQLRequest<String>(
          document: graphQLDocument, variables: variables));

  var response = await operation.response;
  var data = response.data;

  print('data result: ' + data!);

  //var value = json.decode(data);
  print('data error: ' + response.errors.toString());


  var value = json.decode(data);

  return value;

}


createTransaction({var orderId,transactionid,amount,paymentType,transactionDateTime,entryBy,entryDateTime,updatedDateTime}) async{



  try {
    String graphQLDocument =
    '''mutation CreateTransactionMaster(\$createTransactionMasterInput: CreateTransactionMasterInput!) {
        createTransactionMaster(createTransactionMasterInput: \$createTransactionMasterInput) {
          __typename
          id
          orderId
          paymentProviderTransactionId
          amount
          paymentType
          transactionDateTime
          entryBy
          entryDateTime
          updatedDateTime
        }
      }''';

    var variables = {
      "createTransactionMasterInput": {
        "id": 0,
        "orderId": orderId,
        "paymentProviderTransactionId": transactionid,
        "amount": amount,
        "paymentType": paymentType,
        "transactionDateTime": transactionDateTime,
        "entryBy": entryBy,
        "entryDateTime": entryDateTime,
        "updatedDateTime": updatedDateTime,
      }
    };
    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: variables));

    var response = await operation.response;
    var data = response.data;

    print('data result: ' + data!);

    //var value = json.decode(data);
    print('data error: ' + response.errors.toString());

  } catch (e) {
    print('getCustomTableData Query failed: $e');
  }
}

generateRide({var bookingId, userId, status,rideStartDateTime,rideType,startLocationlat,startLocationlong,enLocdationlong,endLocationlat,startLocationName,endLocationName}) async{
  var rideDuration;
  var variables;

  print('sdkweiofy8sigvduietiydivkdsygfdikgfg7w8fyfiogeriogybg8y');
  if(rideType == "2"){
    rideDuration = await getDuration(startPosition:LatLng(startLocationlat, startLocationlong),endPosition:LatLng(endLocationlat, enLocdationlong));

  }
  String graphQLDocument =   '''query GenerateRide(\$bookingId: Int, \$userId: String!, \$rideStartDateTime: String, \$status: Int, \$rideType: Int, \$entryBy: String!, \$driverId: String, \$rideDuration: Int) {
        generateRide(bookingId: \$bookingId, userId: \$userId, rideStartDateTime: \$rideStartDateTime, status: \$status, rideType: \$rideType, entryBy: \$entryBy, driverId: \$driverId, rideDuration: \$rideDuration) {
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
  if(rideType == "1"){
    variables = {
      "bookingId": bookingId,
      "userId": userId,
      "status": status,
      // "rideStartDateTime": rideStartDateTime == null ? null : rideStartDateTime ,
      "rideType": int.parse(rideType),
      "entryBy":userId,
      "driverId":""
    };
  }else{
    variables = {
      "bookingId": bookingId,
      "userId": userId,
      "status": status,
      "rideDuration": rideDuration,
      "rideStartDateTime": rideStartDateTime ,
      "rideType": 1,
      "entryBy":userId,
      "driverId":""
    };
  }

  // print('generate Master result: ' + variables!);

  var operation = Amplify.API.query(
      request: GraphQLRequest<String>(
          document: graphQLDocument,
          variables:variables
      ));

  var response = await operation.response;
  var data = response.data;

  print('generate Master result: ' + data!);


  print('generate Master error: ' + response.errors.toString());
  var finaldata = json.decode(data);

  if(response.errors.length == 0){
    await createRideDetails(
      rideId: finaldata["generateRide"]["id"],
      startLocationLongitude: startLocationlong,
      startLocationLatitude: startLocationlat,
      endLocationLongitude: endLocationlat,
      endLocationLatitude: enLocdationlong,
      startDateTime: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      endDateTime: 0,
      entryBy: userId,
      entryDateTime: DateTime.now().toIso8601String(),
      updatedDateTime: DateTime.now().toIso8601String(),
      locationName: "",
      startLocationName: startLocationName,
      endLocationName: endLocationName,
    );
    return true;
  }else{
    return false;
  }

}


createRideDetails(
    {var id,
      rideId,
      startLocationLongitude,
      startLocationLatitude,
      endLocationLongitude,
      endLocationLatitude,
      startDateTime,
      endDateTime,
      entryBy,
      entryDateTime,
      updatedDateTime,
      locationName,
      startLocationName,
      endLocationName}) async {
  String graphQLDocument =
  '''mutation CreateRideDetails(\$createRideDetailsInput: CreateRideDetailsInput!) {
        createRideDetails(createRideDetailsInput: \$createRideDetailsInput) {
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

  var variables = {
    "createRideDetailsInput": {
      "id":0,
      "rideId":rideId,
      "startLocationLongitude":startLocationLongitude,
      "startLocationLatitude":startLocationLatitude,
      "endLocationLongitude":endLocationLatitude,
      "endLocationLatitude":endLocationLongitude,
      "startDateTime":startDateTime,
      "endDateTime":"",
      "entryBy":entryBy,
      "entryDateTime":entryDateTime,
      "updatedDateTime":updatedDateTime,
      "startLocationName":startLocationName,
      "endLocationName":endLocationName,
    }
  };
  var operation = Amplify.API.mutate(
      request: GraphQLRequest<String>(
          document: graphQLDocument, variables: variables));

  var response = await operation.response;
  var data = response.data;

  print('create ride detail result: ' + data!);

  //var value = json.decode(data);
  print('create ride detail error: ' + response.errors.toString());

  //   try {
//     String graphQLDocument =
//     '''mutation CreateTransactionMaster(\$createTransactionMasterInput: CreateTransactionMasterInput!) {
//         createTransactionMaster(createTransactionMasterInput: \$createTransactionMasterInput) {
//           __typename
//           id
//           orderId
//           paymentProviderTransactionId
//           amount
//           paymentType
//           transactionDateTime
//           entryBy
//           entryDateTime
//           updatedDateTime
//         }
//       }''';
//
//     var variables = {
//       "createTransactionMasterInput": {
//         "id": "0",
//         "orderId": orderId,
//         "paymentProviderTransactionId": transactionid,
//         "amount": amount,
//         "paymentType": paymentType,
//         "transactionDateTime": transactionDateTime,
//         "entryBy": entryBy,
//         "entryDateTime": entryDateTime,
//         "updatedDateTime": updatedDateTime,
//       }
//     };
//     var operation = Amplify.API.query(
//         request: GraphQLRequest<String>(
//             document: graphQLDocument, variables: variables));
//
//     var response = await operation.response;
//     var data = response.data;
//
// //print('data result: ' + data);
//
//     //var value = json.decode(data);
//     print('data error: ' + response.errors.toString());
//
//
//     //return value;
//   } catch (e) {
//     print('getCustomTableData Query failed: $e');
//   }
}

updateRideMaster(
    {var id,status}) async {
  String graphQLDocument =
  '''mutation UpdateRideMaster(\$updateRideMasterInput: UpdateRideMasterInput!) {
        updateRideMaster(updateRideMasterInput:\$updateRideMasterInput) {
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

  var variables = {
    "updateRideMasterInput": {
      "id":id,
      "status":status,
    }
  };
  var operation = Amplify.API.mutate(
      request: GraphQLRequest<String>(
          document: graphQLDocument, variables: variables));

  var response = await operation.response;
  var data = response.data;

  print('create ride detail result: ' + data!);

  //var value = json.decode(data);
  print('create ride detail error: ' + response.errors.toString());

  //   try {
//     String graphQLDocument =
//     '''mutation CreateTransactionMaster(\$createTransactionMasterInput: CreateTransactionMasterInput!) {
//         createTransactionMaster(createTransactionMasterInput: \$createTransactionMasterInput) {
//           __typename
//           id
//           orderId
//           paymentProviderTransactionId
//           amount
//           paymentType
//           transactionDateTime
//           entryBy
//           entryDateTime
//           updatedDateTime
//         }
//       }''';
//
//     var variables = {
//       "createTransactionMasterInput": {
//         "id": "0",
//         "orderId": orderId,
//         "paymentProviderTransactionId": transactionid,
//         "amount": amount,
//         "paymentType": paymentType,
//         "transactionDateTime": transactionDateTime,
//         "entryBy": entryBy,
//         "entryDateTime": entryDateTime,
//         "updatedDateTime": updatedDateTime,
//       }
//     };
//     var operation = Amplify.API.query(
//         request: GraphQLRequest<String>(
//             document: graphQLDocument, variables: variables));
//
//     var response = await operation.response;
//     var data = response.data;
//
// //print('data result: ' + data);
//
//     //var value = json.decode(data);
//     print('data error: ' + response.errors.toString());
//
//
//     //return value;
//   } catch (e) {
//     print('getCustomTableData Query failed: $e');
//   }
}


isDriverAvailable(var rideDateTime) async {
  String graphQLDocument =
  '''query GetAvailableDrivers(\$rideDateTime: String!) {
        getAvailableDrivers(rideDateTime: \$rideDateTime) {
          __typename
          id
          driverId
          regNo
        }
      }''';

  var variables = {
    "rideDateTime": rideDateTime,
  };
  var operation = Amplify.API.mutate(
      request: GraphQLRequest<String>(
          document: graphQLDocument, variables: variables));

  var response = await operation.response;
  var data = response.data;
  print('isDriverAvailable error: ' + response.errors.toString());
  print('isDriverAvailable result: ' + data!);

  var value = json.decode(data);




  return value["getAvailableDrivers"]!.length;
  //   try {
//     String graphQLDocument =
//     '''mutation CreateTransactionMaster(\$createTransactionMasterInput: CreateTransactionMasterInput!) {
//         createTransactionMaster(createTransactionMasterInput: \$createTransactionMasterInput) {
//           __typename
//           id
//           orderId
//           paymentProviderTransactionId
//           amount
//           paymentType
//           transactionDateTime
//           entryBy
//           entryDateTime
//           updatedDateTime
//         }
//       }''';
//
//     var variables = {
//       "createTransactionMasterInput": {
//         "id": "0",
//         "orderId": orderId,
//         "paymentProviderTransactionId": transactionid,
//         "amount": amount,
//         "paymentType": paymentType,
//         "transactionDateTime": transactionDateTime,
//         "entryBy": entryBy,
//         "entryDateTime": entryDateTime,
//         "updatedDateTime": updatedDateTime,
//       }
//     };
//     var operation = Amplify.API.query(
//         request: GraphQLRequest<String>(
//             document: graphQLDocument, variables: variables));
//
//     var response = await operation.response;
//     var data = response.data;
//
// //print('data result: ' + data);
//
//     //var value = json.decode(data);
//     print('data error: ' + response.errors.toString());
//
//
//     //return value;
//   } catch (e) {
//     print('getCustomTableData Query failed: $e');
//   }
}



//order
//2 pending
//1 success
//0 failed

//ride
//3 upcomming
//2 ongoing
//1 completed
//0 canceled

//ridetype
//1 package
//2 pic and drop