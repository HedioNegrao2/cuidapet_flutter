import 'dart:async';
import 'dart:convert';
import 'package:cuidapet_api/application/exceptions/request_validation_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_modules/login_view_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_confirmImputModel.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_refresh_token_input_model.dart';
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
        loginViewModel.loginEmailValidate();
        user = await userService.loginWithEmailPassword(loginViewModel.login,
            loginViewModel.password!, loginViewModel.supplierUser);
      } else {
        loginViewModel.loginSocialValidate();
        user = await userService.loginWithSocial(
          loginViewModel.login,
          loginViewModel.avatar!,
          loginViewModel.socialKey!,
          loginViewModel.socialType!,
        );
      }

      return Response.ok(jsonEncode(
          {'access_token': JwtHelper.genereteJWT(user.id!, user.supplierId)}));
    } on UserNotfoundException {
      return Response.forbidden(
          jsonEncode({'message': 'Usuário não encontrado'}));
    } on RequestValidationException catch (e, s) {
      log.error('Erro ao realizar login', e, s);
      return Response(400, body: jsonEncode(e.errors));
    } catch (e, s) {
      log.error('Erro ao realizar login', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao realizar login'}));
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel =
          UserSaveImputModel.RequestMapping(await request.readAsString());
      await userService.createUser(userModel);
      return Response.ok(jsonEncode({'message': 'Usuário criado com sucesso'}));
    } on UserExistsException {
      return Response(400, body: jsonEncode({'message': 'Usurário já existe'}));
    } catch (e) {
      log.error('Erro ao cadastrar usuário', e);
      return Response.internalServerError();
    }
  }

  @Route('PATCH', '/confirm')
  Future<Response> confirmLogin(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final supplier = int.tryParse(request.headers['supplier'] ?? '');
      final token =
          JwtHelper.genereteJWT(user, supplier).replaceAll('Bearer ', '');

      final inputModel = UserConfirmImputModel(
          userId: user, acessToken: token, data: await request.readAsString());

      inputModel.validateRequest();

      final refreshTokem = await userService.confirmLogin(inputModel);

      return Response.ok(jsonEncode(
          {'access_token': 'Bearer $token', 'refresh_token': refreshTokem}));
    } on RequestValidationException catch (e, s) {
      log.error('Erro ao confirmar login', e, s);
      return Response(400, body: jsonEncode(e.errors));
    } catch (e, s) {
      log.error('Erro ao confirmar login', e, s);
      return Response.internalServerError();
    }
  }

  @Route.put('/refresh')
  Future<Response> refreshToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final supplier = int.tryParse(request.headers['supplier'] ?? '');
      final accessToken = request.headers['access_token']!;
      final model = UserRefreshTokenInputModel(
        user: user,
        supplierId: supplier,
        accessToken: accessToken,
        dataRequest: await request.readAsString(),
      );

      final useRefreshToken = await userService.refreshToken(model);

      return Response.ok(jsonEncode({
        'access_token': useRefreshToken.accessToken,
        'refresh_token': useRefreshToken.refreshToken,
      }));
    } catch (e) {
      log.error('Erro ao atualizar token', e);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao atualizar token'}));
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
