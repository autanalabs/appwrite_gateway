import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'dart:io';

late final appwrite.Client client;
late final appwrite.Database database;

Future init(String apiKey) async {
  client = appwrite.Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(Platform.environment['APPWRITE_PROJECT_ID'])
        .setKey(apiKey);

  database = appwrite.Database(client);
}