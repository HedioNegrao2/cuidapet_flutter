import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client_exception.dart';
import 'package:cuidapet32/app/core/ui/exeptions/failre.dart';
import 'package:cuidapet32/app/core/ui/exeptions/user_exists_exception.dart';
import 'package:cuidapet32/app/repositories/user/user_repository.dart';

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
          .unath()
          .post('/auth/register', data: {'email': email, 'password': password});
    } on RestClientException catch (e, s) {
      if (e.statusCode == 409 &&
          e.response.data['message'].contains('Usuário já cadastrado')) {
        _log.error(e.error, e, s);
        throw UserExistsException();
      }
      _log.error('Erro ao cadastra usuario', e, s);
      throw Failure(message:'Erro ao registra usuário');
    }
  }
}
