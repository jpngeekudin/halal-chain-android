import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/models/umkm_model.dart';

void setUmkmDocument(UmkmDocument document) async {
  final storage = FlutterSecureStorage();
  final documentJson = document.toJSON();
  await storage.write(key: 'umkm_document', value: jsonEncode(documentJson));
}

Future<UmkmDocument?> getUmkmDocument() async {
  final storage = FlutterSecureStorage();
  final documentJsonStr = await storage.read(key: 'umkm_document');
  if (documentJsonStr == null) return null;
  final documentJson = jsonDecode(documentJsonStr);
  final document = UmkmDocument.fromJSON(documentJson);
  return document;
}