import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/models/user_data_model.dart';

Future setUserData(UserData userData) async {
  final storage = FlutterSecureStorage();
  final userDataJson = userData.toJSON();
  await storage.write(key: 'user', value: jsonEncode(userDataJson));
}

Future<UserData?> getUserData() async {
  final storage = FlutterSecureStorage();
  final userDataStr = await storage.read(key: 'user');
  if (userDataStr == null) return null;
  final userDataJson = jsonDecode(userDataStr);
  return UserData.fromJSON(userDataJson);
}