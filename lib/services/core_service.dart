import 'package:dio/dio.dart';
import 'package:halal_chain/configs/api_config.dart';
import 'package:halal_chain/models/api_model.dart';
import 'package:halal_chain/models/user_data_model.dart';
import 'package:logger/logger.dart';

class CoreService {
  final _prefix = apiPrefix;
  final _dio = Dio();

  // AUTH

  Future<ApiResponse> login(Map<String, dynamic> params) async {
    try {
      final url = ApiList.login;
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponse> register(UserType userType, Map<String, dynamic> params) async {
    String url;
    if (userType == UserType.umkm) url = ApiList.registerUmkm;
    else if (userType == UserType.auditor) url = ApiList.registerAuditor;
    else url = ApiList.registerConsument;

    try {
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponse> updateUser(UserType userType, Map<String, dynamic> params) async {
    String url;
    if (userType == UserType.umkm) url = ApiList.updateUserUmkm;
    else if (userType == UserType.auditor) url = ApiList.updateUserAuditor;
    else url = ApiList.updateUserConsument;

    try {
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponse> getUser(UserType userType, String userId) async {
    String url;
    if (userType == UserType.umkm) url = ApiList.getUserUmkm;
    else if (userType == UserType.auditor) url = ApiList.getUserAuditor;
    else url = ApiList.getUserConsument;

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
      final url = ApiList.umkmCreateInit;
      final data = { 'creator_id': creatorId };
      final response = await _dio.post(url, data: data);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  Future<ApiResponse> createDetailUmkm(Map<String, dynamic> params) async {
    try {
      final url = ApiList.umkmCreateDetail;
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  Future<ApiResponse> createPenetapanTim(Map<String, dynamic> params) async {
    try {
      final url = ApiList.umkmCreatePenetapanTim;
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  Future<ApiResponse> createBuktiPelaksanaan(Map<String, dynamic> params) async {
    try {
      final url = ApiList.umkmCreateBuktiPelaksanaan;
      final response = await _dio.post(url, data: params);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  Future<ApiResponse> getSoalEvaluasi() async {
    try {
      final url = ApiList.umkmGetEvaluasiSoal;
      final response = await _dio.get(url);
      return _handleResponse(response);
    } catch(err) {
      rethrow;
    }
  }

  // HTTP UTILS

  Future<ApiResponse> genericGet(String url, [Map<String, dynamic> params = const {}]) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  Future<ApiResponse> genericPost(String url, Map<String, dynamic>? parameters, dynamic data) async {
    try {
      final response = await _dio.post(url, data: data, queryParameters: parameters);
      return _handleResponse(response);
    } catch (err) {
      rethrow;
    }
  }

  ApiResponse _handleResponse(Response dioResponse) {
    ApiResponse apiResponse;

    if (dioResponse.data != null && (dioResponse.data.runtimeType == String || dioResponse.data.runtimeType == List || !dioResponse.data.containsKey('data'))) {
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