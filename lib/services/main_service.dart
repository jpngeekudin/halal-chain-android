import 'package:dio/dio.dart';

const SERVICE_BASE_URL = 'http://103.176.79.228:5000';

Future<Response> registerUmkm(Map<String, dynamic> params) async {
  try {
    return await Dio().post(
      '$SERVICE_BASE_URL/auth/register_umkm',
      data: params
    );
  } catch(err) {
    rethrow;
  }
}

Future<Response> registerAuditor(Map<String, dynamic> params) async {
  try {
    return await Dio().post(
      '$SERVICE_BASE_URL/auth/register_auditor',
      data: params
    );
  } catch(err) {
    rethrow;
  }
}

Future<Response> registerConsumen(Map<String, dynamic> params) async {
  try {
    return await Dio().post(
      '$SERVICE_BASE_URL/auth/register_consumen',
      data: params
    );
  } catch(err) {
    rethrow;
  }
}

Future<Response> login(Map<String, dynamic> params) async {
  try {
    return await Dio().post(
      '$SERVICE_BASE_URL/auth/login',
      data: params
    );
  } catch(err) {
    rethrow;
  }
}