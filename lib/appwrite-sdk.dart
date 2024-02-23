import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;
import 'package:dart_appwrite/models.dart';
import 'dart:io';

late final appwrite.Client client;
late final appwrite.Databases databases;
bool _initialized = false;

Future init(final context, final String apiKey) async {
  if (!_initialized) {
    client = appwrite.Client()
          .setEndpoint('https://cloud.appwrite.io/v1')
          .setProject(Platform.environment['APPWRITE_PROJECT_ID'])
          .setKey(apiKey);

    databases = appwrite.Databases(client);
    _initialized = true;
    context.log('Appwrite SDK initialized');
  }
}

Future<dynamic> executeDatabase(final context, String httpMethod, String path, dynamic body) async {
  // Parsear el path para obtener databaseId, collectionId, y documentId (si existe)
  final pathSegments = path.split('/');
  if (pathSegments.length < 4) {
    throw Exception('Path inválido. Debe ser "/api/{databaseId}/{collectionId}/{documentId}?".');
  }

  final databaseId = pathSegments[2];
  final collectionId = pathSegments[3];
  String? documentId = (pathSegments.length > 4 && pathSegments[4].trim().isNotEmpty) ? 
     pathSegments[4].trim() : null;

  if (documentId != null && documentId.isEmpty)

  context.log('databaseId: $databaseId');
  context.log('collectionId: $collectionId');
  context.log('documentId: ${documentId ?? 'NULL'}');

  switch (httpMethod.toUpperCase()) {
    case 'GET':
      if (documentId == null) {
        // Listar documentos si no se proporciona documentId
        context.log('operation: reading documents.');
        final DocumentList documents = await databases
        .listDocuments(databaseId: databaseId, 
        collectionId: collectionId);
        return documents.documents.map((doc) => doc.data).toList();
      } else {
        // Recuperar un documento específico si se proporciona documentId
        context.log('operation: reading document by ID.');
        final document = await databases.getDocument(databaseId: databaseId, 
        collectionId: collectionId, documentId: documentId);
        // Devuelve directamente la data del documento.
        return document.data;
      }
    case 'POST':
      if (documentId == null) {
        // Crear un nuevo documento si no se proporciona documentId
        context.log('operation: creating document.');
        final document = await databases.createDocument(databaseId: databaseId, 
        collectionId: collectionId,  documentId: 'newId()',
        data: body);
        return document.data;
      } else {
        // Actualizar un documento específico si se proporciona documentId
        context.log('operation: updating document.');
        final document = await databases.updateDocument(databaseId: databaseId, 
        collectionId: collectionId, documentId: documentId, 
        data: body);
        return document.data;
      }
    case 'DELETE':
      if (documentId == null) {
        throw Exception('Eliminar todos los documentos no está permitido.');
      } else {
        // Eliminar un documento específico
        context.log('operation: deleting document.');
        return await databases.deleteDocument(databaseId: databaseId, 
        collectionId: collectionId, documentId: documentId);
      }
    default:
      throw Exception('Método HTTP no soportado.');
  }
}
