import 'dart:async';
import 'dart:convert';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_modules/update_url_avatar_view_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_update_token_device_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_controller.g.dart';

@Injectable()
class UserController {
  IUserService userService;
  ILogger log;

  UserController({
    required this.userService,
    required this.log,
  });

  @Route.get('/')
  Future<Response> findByToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final userData = await userService.findById(user);

      return Response.ok(jsonEncode({
        'email': userData.email,
        'registerType': userData.registerType,
        'imageAvatar': userData.imageAvatar,
      }));
    } on UserNotfoundException {
      return Response(204);
    } catch (e, s) {
      log.error('Erro ao buscar usuario', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'erro ao buscao usuario '}));
    }
  }

  @Route.put('/avatar')
  Future<Response> updateAvatar(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);
      final updateUrlAvatar = UpdateUrlAvatarViewModel(
        userId: userId,
        dataReqest: await request.readAsString(),
      );
      final user = await userService.updateUrlAvatar(updateUrlAvatar);
      return Response.ok(jsonEncode({
        'email': user.email,
        'registerType': user.registerType,
        'imageAvatar': user.imageAvatar,
      }));
    } catch (e, s) {
      log.error('Erro ao buscar usuario', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'erro ao buscao usuario '}));
    }
  }

  @Route.put('/device')
  Future<Response>updateDevicetoken(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);
      final updateDeviceToken = UserUpdateTokenDeviceInputModel(
        userId: userId,
        dataRequest: await request.readAsString(),
      );
      await userService.updateDeviceToken(updateDeviceToken);
      return Response.ok(jsonEncode({}));
    } catch (e, s) {
      log.error('Erro ao atualizar o device token', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao atualizar o device token'}));
    }
  }

  Router get router => _$UserControllerRouter(this);
}
