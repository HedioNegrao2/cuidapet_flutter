import 'package:cuidapet32/app/core/helpers/constants.dart';
import 'package:cuidapet32/app/core/helpers/environments.dart';
import 'package:cuidapet32/app/core/local_storage/local_storage.dart';
import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/rest_client/dio/interceptors/auth_interceptor.dart';
import 'package:cuidapet32/app/core/rest_client/dio/interceptors/auth_refresh_token_interceptor.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client_exception.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client_response.dart';
import 'package:cuidapet32/app/modules/core/auth/auth_store.dart';
import 'package:dio/dio.dart';

class DioRestClient implements RestClient {
  late final Dio _dio;

  final _defaultOptions = BaseOptions(
    baseUrl: Environments.param(Constants.ENV_BASE_URL_KEY) ?? '',
    connectTimeout: Duration(
        milliseconds: int.parse(
            Environments.param(Constants.ENV_REST_CLIENTE_CONNECT_TIMEOUT) ??
                '0')),
    receiveTimeout: Duration(
        milliseconds: int.parse(
            Environments.param(Constants.ENV_REST_CLIENTE_RECEIVE_TIMEOUT) ??
                '0')),
  );

  DioRestClient({
    required LocalStorage localStorage,
    required AppLogger log,
    required AuthStore authStore,
    required LocalSecureStorage localSecureStorage,
    BaseOptions? options,
  }) {
    _dio = Dio(options ?? _defaultOptions);
    _dio.interceptors.addAll([
      AuthInterceptor(
        localStorage: localStorage,
        authStore: authStore,
      ),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
      AuthRefreshTokenInterceptor(
        authStore: authStore,
        localStorage: localStorage,
        localSecureStorage: localSecureStorage,
        restClient: this,
        log: log,
      ),  
    ]);
  }

  @override
  RestClient auth() {
    _defaultOptions.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] = true;
    return this;
  }

  @override
  RestClient unauth() {
    _defaultOptions.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] = false;
    return this;
  }

  @override
  Future<RestClientResponse<T>> delete<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _dioResponseConvert<T>(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _dioResponseConvert(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _dioResponseConvert(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _dioResponseConvert(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return _dioResponseConvert(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(String path,
      {required String method,
      data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers, method: method),
      );

      return _dioResponseConvert(response);
    } on DioException catch (e) {
      _trowRestClientException(e);
    }
  }

  Future<RestClientResponse<T>> _dioResponseConvert<T>(
      Response<dynamic> response) async {
    return RestClientResponse<T>(
      data: response.data,
      statusCode: response.statusCode ?? 0,
      statusMessage: response.statusMessage ?? '',
    );
  }

  Never _trowRestClientException(DioException dioException) {
    final response = dioException.response;

    throw RestClientException(
      error: dioException.error,
      message: response?.statusMessage,
      statusCode: response?.statusCode,
      response: RestClientResponse(
        data: response?.data,
        statusCode: response?.statusCode ?? 0,
        statusMessage: response?.statusMessage ?? '',
      ),
    );
  }
}
