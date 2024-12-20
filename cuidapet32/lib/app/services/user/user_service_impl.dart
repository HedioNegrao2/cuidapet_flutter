import 'package:cuidapet32/app/core/helpers/constants.dart';
import 'package:cuidapet32/app/core/local_storage/local_storage.dart';
import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/exeptions/failre.dart';
import 'package:cuidapet32/app/core/exeptions/user_exists_exception.dart';
import 'package:cuidapet32/app/core/exeptions/user_not_exists_exception.dart';
import 'package:cuidapet32/app/models/social_login_type.dart';
import 'package:cuidapet32/app/models/social_network_model.dart';
import 'package:cuidapet32/app/repositories/social/social_repository.dart';
import 'package:cuidapet32/app/repositories/user/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;
  final LocalStorage _localStorage;
  final LocalSecureStorage _localSecureStorage;
  final SocialRepository _socialRepository;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
    required LocalStorage localStorage,
    required LocalSecureStorage localSecureStorage,
    required SocialRepository socialRepository,
  })  : _userRepository = userRepository,
        _log = log,
        _localStorage = localStorage,
        _localSecureStorage = localSecureStorage,
        _socialRepository = socialRepository;

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

  @override
  Future<void> login(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final loginMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.isEmpty) {
        throw UserNotExistsException();
      }

      if (loginMethods.contains('password')) {
        final userCredential = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        final userVirified = userCredential.user?.emailVerified ?? false;

        if (!userVirified) {
          userCredential.user?.sendEmailVerification();
          throw Failure(
              message:
                  'Usuário não verificado, por favor verifique sua caixa de spam');
        }

        final accessToken = await _userRepository.login(email, password);
        await _saveAccessToken(accessToken);
        await _confirmLogin();
        await _getUserData();
      } else {
        throw Failure(message: 'Login não pode ser feito por email e senha');
      }
    } on FirebaseAuthException catch (e, s) {
      _log.error('Usuário ou senha inválidos FirebaseAuth[${e.code}]', e, s);
      throw Failure(message: 'Usuário ou senha inválidos');
    }
  }

  Future<void> _saveAccessToken(String accessToken) => _localStorage.write(
      Constants.LOCAl_STORAGE_ACCESS_TOKEN_KEY, accessToken);

  Future<void> _confirmLogin() async {
    final confirmLoginModel = await _userRepository.confirmLogin();
    await _saveAccessToken(confirmLoginModel.accessToken);
    await _localSecureStorage.write(Constants.LOCAl_STORAGE_REFRESH_TOKEN_KEY,
        confirmLoginModel.refreshToken);
  }

  Future<void> _getUserData() async {
    final userModel = await _userRepository.getUserLogged();
    await _localStorage.write<String>(
        Constants.LOCAl_STORAGE_USER_LOGGED_DATA_KEY, userModel.toJson());
  }

  @override
  Future<void> socialLogin(SocialLoginType socialLoginType) async {
    final SocialNetworkModel socialModel;
    final AuthCredential authCredential;
    final firebaseAuth = FirebaseAuth.instance;

    try {
      switch (socialLoginType) {
        case SocialLoginType.facebook:
          throw Failure(message: 'Login com facebook não implementado');

        case SocialLoginType.google:
          socialModel = await _socialRepository.googleLogin();
          authCredential = GoogleAuthProvider.credential(
            accessToken: socialModel.accessToken,
            idToken: socialModel.id,
          );
          break;
      }

      final loginMethods =
          await firebaseAuth.fetchSignInMethodsForEmail(socialModel.email);

      final methodCheck = _getMethodToSocialType(socialLoginType);

      if (loginMethods.isNotEmpty && !loginMethods.contains(methodCheck)) {
        throw Failure(
            message:
                'Login não pode ser feito por $methodCheck, tente  outro provedor de login');
      }

      await firebaseAuth.signInWithCredential(authCredential);
      final accassToken = await _userRepository.loginSocial(socialModel);
      await _saveAccessToken(accassToken);
      await _confirmLogin();
      await _getUserData();
    } on FirebaseAuthException catch (e, s) {
      _log.error('message: Erro ao realizar login com $socialLoginType', e, s);
      throw Failure(message: 'Erro ao realizar login com $socialLoginType');
    }
  }

  String _getMethodToSocialType(SocialLoginType socialLoginType) {
    switch (socialLoginType) {
      case SocialLoginType.google:
        return 'google.com';
      case SocialLoginType.facebook:
        return 'facebook.com';
    }
  }
}
