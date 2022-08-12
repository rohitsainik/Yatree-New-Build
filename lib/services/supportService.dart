

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';


sendSupportRequest(
    {var rideId,
    bookingId,
    description,
    userId,
    enterBy,
    entryDateTime,
    updateDateTime}) async{
  try {
    String graphQLDocument =
    '''mutation CreateSupportMaster(\$createSupportMasterInput: CreateSupportMasterInput!) {
        createSupportMaster(createSupportMasterInput:\$createSupportMasterInput) {
          __typename
          id
          rideId
          bookingId
          description
          userId
          entryBy
          entryDateTime
          updatedDateTime
        }
      }''';

    var variable = {
     "createSupportMasterInput" :{'id': 0,
      'rideId': rideId,
      'bookingId':bookingId,
      'description':description,
      'userId':userId,
      'entryBy':enterBy,
      'entryDateTime':entryDateTime,
      'updatedDateTime':updateDateTime,}
    };

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: variable));

    var response = await operation.response;
    var data = response.data;

    print('Mutation result: ' + data!);
    print('Mutation error: ' + response.errors.toString());
  } on ApiException catch (e) {
    print('Mutation failed: $e');
  }
}