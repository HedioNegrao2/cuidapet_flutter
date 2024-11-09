import 'package:cuidapet32/app/core/ui/exeptions/user_exists_exception.dart';
import 'package:cuidapet32/app/core/ui/widgets/loader.dart';
import 'package:cuidapet32/app/core/ui/widgets/messages.dart';
import 'package:cuidapet32/app/services/user/user_service.dart';
import 'package:mobx/mobx.dart';
import 'package:cuidapet32/app/core/logger/app_logger.dart';

part 'register_controller.g.dart';

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  final UserService _userServicie;
  final AppLogger _log;

  RegisterControllerBase({
    required UserService userServcie,
    required AppLogger log,
  })  : _log = log,
        _userServicie = userServcie;

  Future<void> register(
      {required String email, required String password}) async {
    try {
      Loader.show();
      await _userServicie.register(email, password);
      Messages.alert('E-mail de confirmação enviado, por favor verifique sua caixa de entrada');
      Loader.hide();
    } on UserExistsException {
      Loader.hide();
      Messages.alert('E-mail já utilizado, por favor utilize outro e-mail');
    } catch (e, s) {
      Loader.hide();
      _log.error('Erro ao cadastrar usuário', e, s);
      Messages.alert('Erro ao cadastrar usuário');
    }
  }
}
