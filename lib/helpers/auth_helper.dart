import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:halal_chain/models/user_data_model.dart';

Future setUserData(Map<String, dynamic> json) async {
  final storage = FlutterSecureStorage();

  final userData = UserData.fromJSON(json);
  final userDataJson = userData.toJSON();
  await storage.write(key: 'user', value: jsonEncode(userDataJson));

  if (userData.role == 'auditor') {
    final userAuditorData = UserAuditorData.fromJSON(json);
    final userAuditorDataJson = userAuditorData.toJSON();
    await storage.write(key: 'user_auditor', value: jsonEncode(userAuditorDataJson));
  }

  else if (userData.role == 'umkm') {
    final userUmkmData = UserUmkmData.fromJSON(json);
    final userUmkmDataJson = userUmkmData.toJSON();
    await storage.write(key: 'user_umkm', value: jsonEncode(userUmkmDataJson));
  }

  else if (userData.role == 'consumen') {
    final userConsumentData = UserConsumentData.fromJSON(json);
    final userConsumentDataJson = userConsumentData.toJSON();
    await storage.write(key: 'user_consumen', value: jsonEncode(userConsumentDataJson));
  }
}

Future<UserData?> getUserData() async {
  final storage = FlutterSecureStorage();
  final userDataStr = await storage.read(key: 'user');
  if (userDataStr == null) return null;
  final userDataJson = jsonDecode(userDataStr);
  return UserData.fromJSON(userDataJson);
}

Future<UserAuditorData?> getUserAuditorData() async {
  final storage = FlutterSecureStorage();
  final dataStr = await storage.read(key: 'user_auditor');
  if (dataStr == null) return null;
  final dataJson = jsonDecode(dataStr);
  return UserAuditorData.fromJSON(dataJson);
}

Future<UserUmkmData?> getUserUmkmData() async {
  final storage = FlutterSecureStorage();
  final dataStr = await storage.read(key: 'user_umkm');
  if (dataStr == null) return null;
  final dataJson = jsonDecode(dataStr);
  return UserUmkmData.fromJSON(dataJson);
}