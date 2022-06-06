import 'package:dio/dio.dart';

Future<Response> registerUmkm(Map<String, dynamic> params) async {
  try {
    return await Dio().post(
      'http://103.176.79.228:5001/auth/register_umkm',
      data: params
    );
  }
  
  catch(err) {
    rethrow;
  }
}

Future<Response> login(Map<String, dynamic> params) async {
  try {
    return await Dio().post(
      'http://103.176.79.228:5001/auth/login',
      data: params
    );
  }

  catch(err) {
    rethrow;
  }
}