import 'dart:convert';
import 'package:amplify_api/amplify_api.dart';

import 'package:amplify_flutter/amplify_flutter.dart';

getCustomTableData({var tableName, condition}) async {
  try {
    String graphQLDocument =
        '''query CustomListTable(\$tableName: TableNames!,\$condition: String!) {
      customListTable(tableName: \$tableName, condition: \$condition)
      }''';

    var variables = {
      "tableName": tableName,
      "condition": condition,
    };
    var operation = Amplify.API.query(
        request: GraphQLRequest<String>(
            document: graphQLDocument, variables: variables));

    var response = await operation.response;
    var data = response.data;

    print('getCustomTableData result: ' + data!);

    var value = json.decode(data);

    return value;
  } catch (e) {
    print('getCustomTableData Query failed: $e');
  }
}
