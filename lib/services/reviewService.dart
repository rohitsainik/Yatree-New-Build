

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

sendReviewRequest(
    {var rideId,
      rating,
      description,
      userId,
      enterBy,
      entryDateTime,
      updateDateTime}) async{
  try {
    String graphQLDocument =
    '''mutation CreateReviewMaster(\$createReviewMasterInput: CreateReviewMasterInput!) {
        createReviewMaster(createReviewMasterInput: \$createReviewMasterInput) {
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

    var variable ={ "createReviewMasterInput" :{
      'id': 0,
      'rideId': rideId,
      'description':description,
      'userId':userId,
      'rating':rating,
      'entryBy':enterBy,
      'entryDateTime':entryDateTime,
      'updatedDateTime':updateDateTime,
    }};

    var operation = Amplify.API.mutate(
        request: GraphQLRequest<String>(document: graphQLDocument, variables: variable));

    var response = await operation.response;
    var data = response.data;

    print('Mutation result: ' + data!);
    print('Mutation result: ' + response.errors.toString());
  } on ApiException catch (e) {
    print('Mutation failed: $e');
  }
}