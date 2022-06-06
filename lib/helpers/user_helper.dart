import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, dynamic>?> getUserData() async {
  final storage = FlutterSecureStorage();
  final userDataStr = await storage.read(key: 'user');

  if (userDataStr == null) {
    return null;
  }

  else {
    final userData = jsonDecode(userDataStr);
    return userData;
  }
}