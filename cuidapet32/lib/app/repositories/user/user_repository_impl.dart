import 'dart:io';

import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client_exception.dart';
import 'package:cuidapet32/app/core/exeptions/failre.dart';
import 'package:cuidapet32/app/core/exeptions/user_exists_exception.dart';
import 'package:cuidapet32/app/models/confirm_login_model.dart';
import 'package:cuidapet32/app/models/social_network_model.dart';
import 'package:cuidapet32/app/models/user_model.dart';
import 'package:cuidapet32/app/repositories/user/user_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;
  final AppLogger _log;
  

  UserRepositoryImpl({
    required RestClient restClient,
    required AppLogger log,
  })  : _log = log,
        _restClient = restClient;

  @override
  Future<void> register(String email, String password) async {
    try {
      await _restClient
          .unauth()
          .post('/auth/register', data: {'email': email, 'password': password});
    } on RestClientException catch (e, s) {
      if (e.statusCode == 409 &&
          e.response.data['message'].contains('Usuário já cadastrado')) {
        _log.error(e.error, e, s);
        throw UserExistsException();
      }
      _log.error('Erro ao cadastra usuario', e, s);
      throw Failure(message: 'Erro ao registra usuário');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final result = await _restClient.unauth().post('/auth/', data: {
        'login': email,
        'password': password,
        'social_login': false,
        'supplier_user': false,
      });
      return result.data['access_token'];
    } on RestClientException catch (e, s) {
      if (e.statusCode == 403) {
        throw Failure(
            message:
                'Usuário inconsistente, entre em contato com o suporte!!!');
      }

      _log.error('Erro ao realizar login', e, s);
      throw Failure(
          message: 'Erro ao realizar login, tente novamente mais tarde');
    }
  }

  @override
  Future<ConfirmLoginModel> confirmLogin() async {
    try {
      final devaceToken = await FirebaseMessaging.instance.getToken();

      final result = await _restClient.auth().patch('/auth/confirm', data: {
        'ios_token': Platform.isIOS ? devaceToken : null,
        'android_token': Platform.isAndroid ? devaceToken : null,
      });

      return ConfirmLoginModel.fromJson(result.data);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao confirmar login', e, s);
      throw Failure(
          message: 'Erro ao confirmar login, tente novamente mais tarde');
    }
  }

  @override
  Future<UserModel> getUserLogged() async {
    try {
      final result = await _restClient.get('/user/');
      return UserModel.fromMap(result.data);
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar usuario logado', e, s);
      throw Failure(
          message: 'Erro ao buscar usuario logado, tente novamente mais tarde');
    }
  }

  @override
  Future<String> loginSocial(SocialNetworkModel model) async {
    try {
      final result = await _restClient.unauth().post('/auth/', data: {
        'login': model.email,
        'social_login': true,
        'avatar': model.avatar,
        'social_type': model.type,
        'social_key': model.id,
        'supplier_user': false,
      });

      return result.data['access_token'];
    } on RestClientException catch (e, s) {
      if (e.statusCode == 403) {
        throw Failure(
            message:
                'Usuário inconsistente, entre em contato com o suporte!!!');
      }

      _log.error('Erro ao realizar login', e, s);
      throw Failure(
          message: 'Erro ao realizar login, tente novamente mais tarde');
    }
  }
}
