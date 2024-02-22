import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'dart:io';

late final appwrite.Client client;
late final appwrite.Database database;
bool _initialized = false;

Future init(String apiKey) async {
  if (!_initialized) {
    client = appwrite.Client()
          .setEndpoint('https://cloud.appwrite.io/v1')
          .setProject(Platform.environment['APPWRITE_PROJECT_ID'])
          .setKey(apiKey);

    database = appwrite.Database(client);
    _initialized = true;
  }
}