import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/ui/exeptions/failre.dart';
import 'package:cuidapet32/app/core/ui/exeptions/user_exists_exception.dart';
import 'package:cuidapet32/app/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
  })  : _userRepository = userRepository,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;

      final userMethod = await firebaseAuth.fetchSignInMethodsForEmail(email);
      if (userMethod.isNotEmpty) {
        throw UserExistsException();
      }
      await _userRepository.register(email, password);
      final userRegister = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userRegister.user?.sendEmailVerification();
    } on FirebaseException catch (e, s) {
      _log.error('Erro ao registrar usuário no Firebase', e, s);
      throw Failure(message: 'Erro ao registrar usuário');
    }
  }
}
