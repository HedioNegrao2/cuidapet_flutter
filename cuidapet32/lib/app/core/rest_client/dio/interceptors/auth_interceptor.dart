
import 'package:cuidapet32/app/core/helpers/constants.dart';
import 'package:cuidapet32/app/core/local_storage/local_storage.dart';
import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/modules/core/auth/auth_store.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorage _localStorage;
  final AppLogger _log;
  final AuthStore _authStore;


  AuthInterceptor({
    required LocalStorage localStorage,
    required AppLogger log,
    required AuthStore authStore,
  })  : _localStorage = localStorage,
        _log = log,
        _authStore = authStore;

  @override
  void  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    final authRiquered = options.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] ?? false; 

    if(authRiquered) {
      final accessToken = await _localStorage.read<String>(Constants.LOCAl_STORAGE_ACCESS_TOKEN_KEY);
    if(accessToken == null) {
      _authStore.logout();
      return handler.reject(        
        DioException(
          requestOptions: options, 
          error: 'Acesso negado',
          type: DioExceptionType.cancel,
        )
      );
    }

    options.headers['Authorization'] =  accessToken;  
    }
    else {
      options.headers.remove('Authorization');
    }

    return handler.next(options);    

  } 

//  @override
//  void onResponse(Response response) {
//    return response;
//  }

//  @override
//  void onError(DioError err) {
//    return err;
//  }
  
}