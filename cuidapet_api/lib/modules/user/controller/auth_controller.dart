import 'dart:async';
import 'dart:convert';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_modules/login_view_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_save_imput_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final loginViewModel = LoginViewModel(await request.readAsString());

      User user;

      if (!loginViewModel.socialLogin) {
        user = await userService.loginWithEmailPassword(
            loginViewModel.login, loginViewModel.password, loginViewModel.supplierUser);
      } else {
        user = User();
      }

      return Response.ok(jsonEncode({
        'acces_token': JwtHelper.genereteJWT(user.id!, user.supplierId),
      }));
    } on UserNotfoundException {
      return Response.forbidden(
          jsonEncode({'message': 'Usuário não encontrado'}));
    } catch (e, s) {
      log.error('Erro ao realizar login', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao realizar login'}));
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveImputModel(await request.readAsString());
      await userService.createUser(userModel);
      return Response.ok(jsonEncode({'message': 'Usuário criado com sucesso'}));
    } on UserExistsException {
      return Response(400, body: jsonEncode({'message': 'Usurário já existe'}));
    } catch (e) {
      log.error('Erro ao cadastrar usuário', e);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
