import 'package:dio/dio.dart';

Future registerUmkm(Map<String, dynamic> params) async {
  try {
    final response = await Dio().post(
      'http://103.176.79.228:5001/auth/register_umkm',
      data: params
    );
    return response;
  } catch(err) {
    rethrow;
  }
}