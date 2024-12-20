import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/exeptions/failre.dart';
import 'package:cuidapet32/app/core/exeptions/user_not_exists_exception.dart';
import 'package:cuidapet32/app/core/ui/widgets/loader.dart';
import 'package:cuidapet32/app/core/ui/widgets/messages.dart';
import 'package:cuidapet32/app/models/social_login_type.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import 'package:cuidapet32/app/services/user/user_service.dart';

part 'login_controller.g.dart';

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;

  LoginControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _userService = userService,
        _log = log;

  Future<void> login(String login, String password) async {
    try {
      Loader.show();
      await _userService.login(login, password);
      Loader.hide();
      Modular.to.navigate('/auth/');

    } on Failure catch (e, s) {
      final erroMessage = e.message ?? 'Erro ao realizar login';
      _log.error(erroMessage, e, s);
      Loader.hide();
      Messages.alert(erroMessage);
    } on UserNotExistsException {
      final erroMessage = 'Usuario nao cadastrado';

      _log.error(erroMessage);
      Loader.hide();
      Messages.alert(erroMessage);
    }
  }

  Future<void> loginSocial(SocialLoginType socialLoginType) async {
    try {
      Loader.show();
      await _userService.socialLogin(socialLoginType);
      Loader.hide();
      Modular.to.navigate('/auth/');

    } on Failure  catch (e, s) {
      Loader.hide();
         final erroMessage = e.message ?? 'Erro ao realizar login';
      _log.error(erroMessage, e, s);
      Messages.alert(erroMessage);
    }
  }
}
