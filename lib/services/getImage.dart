import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'dart:io';

import 'package:amplify_storage_s3/amplify_storage_s3.dart';

Future<String>? getDownloadUrl({var key}) async {
  try {
    S3GetUrlOptions options = S3GetUrlOptions(
        accessLevel: StorageAccessLevel.guest, expires: 10000);
    var result =
    await Amplify.Storage.getUrl(key: key,options:options );
    var data = result.url;
    return data;
    print('Got URL: ${result.url}');
  } catch (e) {
    print('Error getting download URL: $e');
    return "https://unsplash.com/s/photos/blue-color";
  }
}