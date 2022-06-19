import 'package:dio/dio.dart';
import 'package:halal_chain/models/api_model.dart';
import 'package:halal_chain/models/user_data_model.dart';

class CoreService {
  final _prefix = 'http://103.176.79.228:5000';
  final _dio = Dio();

  // AUTH

  Future<ApiResponse> login(Map<String, dynamic> params) async {
    try {
      final url = '$_prefix/auth/login';
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponse> register(UserType userType, Map<String, dynamic> params) async {
    String url;
    if (userType == UserType.umkm) url = '$_prefix/auth/register_umkm';
    else if (userType == UserType.auditor) url = '$_prefix/auth/register_auditor';
    else url = '$_prefix/auth/register_consumen';

    try {
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponse> updateUser(UserType userType, Map<String, dynamic> params) async {
    String url;
    if (userType == UserType.umkm) url = '$_prefix/account/update_umkm';
    else if (userType == UserType.auditor) url = '$_prefix/account/update_auditor';
    else url = '$_prefix/account/update_consumen';

    try {
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponse> getUser(UserType userType, String userId) async {
    String url;
    if (userType == UserType.umkm) url = '$_prefix/account/get_umkm';
    else if (userType == UserType.auditor) url = '$_prefix/account/get_auditor';
    else url = '$_prefix/account/get_consumen';

    try {
      final query = { 'id': userId };
      final response = await _dio.get(url, queryParameters: query );
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  // UMKM

  Future<ApiResponse> createInit(String creatorId) async {
    try {
      final url = '$_prefix/umkm/create_init';
      final data = { 'creator_id': creatorId };
      final response = await _dio.post(url, data: data);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  Future<ApiResponse> createDetailUmkm(Map<String, dynamic> params) async {
    try {
      final url = '$_prefix/umkm/insert_detail_umkm';
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  Future<ApiResponse> createPenetapanTim(Map<String, dynamic> params) async {
    try {
      final url = '$_prefix/umkm/insert_penetapan_tim';
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  Future<ApiResponse> createBuktiPelaksanaan(Map<String, dynamic> params) async {
    try {
      final url = '$_prefix/umkm/insert_bukti_pelaksanaan';
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  Future<ApiResponse> getSoalEvaluasi() async {
    try {
      final url = '$_prefix/umkm/get_soal_evaluasi';
      final response = await _dio.get(url);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  // HTTP UTILS

  Future<ApiResponse> genericGet(String url, Map<String, dynamic> params) async {
    try {
      final response = await _dio.post(url, queryParameters: params);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  ApiResponse _handleResponse(Response dioResponse) {
    ApiResponse apiResponse;

    if (dioResponse.data.runtimeType == String || dioResponse.data['data'] == null) {
      apiResponse = ApiResponse(
        status: dioResponse.statusCode ?? 200,
        data: dioResponse.data,
      );
    }

    else {
      apiResponse = ApiResponse(
        status: dioResponse.statusCode ?? 200,
        data: dioResponse.data['data'],
        message: dioResponse.data['message']
          ?? dioResponse.data['detail'],
      );
    }

    return apiResponse;
  }
}