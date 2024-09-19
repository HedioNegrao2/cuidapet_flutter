import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/chat/service/i_chat_service.dart';
import 'package:cuidapet_api/modules/chat/view_models/chat_notfy_view_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'chat_controller.g.dart';

@Injectable()
class ChatController {
  final IChatService service;
  final ILogger log;

  ChatController({
    required this.service,
    required this.log,
  });

  @Route.post('/schedule/<scheduleId>/start-chat')
  Future<Response> startChatByScheduleId(
      Request request, String scheduleId) async {
    try {
      final chatId = await service.startChat(int.parse(scheduleId));
      return Response.ok(jsonEncode({'chat_id': chatId}));
    } catch (e, s) {
      log.error('Erro ao iniciar chat', e, s);
      return Response.internalServerError();
    }
  }

  @Route.post('/notify')
  Future<Response> notfyUser(Request request) async {
    try {
      final model = ChatNotfyViewModel(await request.readAsString());
      await service.notifyChat(model);
      return Response.ok(jsonEncode({}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao enviar notificação'}));
    }
  }

  @Route.get('/user')
  Future<Response> findChatByUser(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);
      final chats = await service.getChatsByUser(userId);
      final resultChats = chats
          .map((c) => {
                'id': c.id,
                'user': c.user,
                'name': c.nome,
                'name_pet': c.petName,
                'supplier': {
                  'id': c.supplier.id,
                  'name': c.supplier.name,
                  'logo': c.supplier.logo,
                }
              })
          .toList();

      return Response.ok(jsonEncode(resultChats));
    } catch (e, s) {
      log.error('Erro ao buscar chats', e, s);
      return Response.internalServerError();
    }
  }

  @Route.get('/supplier')
  Future<Response> findChatsBySupplier(Request request) async {
    try {
      final suppplier = request.headers['supplier'];

      if (suppplier == null) {
        return Response(400,
            body:
                jsonEncode({'message': 'Usuário logado não é um fornecedor'}));
      }

      final supplierId = int.parse(suppplier);

      final chats = await service.getChatsBySupplier(supplierId);
      final resultChats = chats
          .map((c) => {
                'id': c.id,
                'user': c.user,
                'name': c.nome,
                'name_pet': c.petName,
                'supplier': {
                  'id': c.supplier.id,
                  'name': c.supplier.name,
                  'logo': c.supplier.logo,
                }
              })
          .toList();

      return Response.ok(jsonEncode(resultChats));
    } catch (e, s) {
      log.error('Erro ao buscar chats por fornecedor', e, s);
      return Response.internalServerError();
    }
  }

  @Route.put('/<chatId>/end-chat')
  Future<Response> endChat(Request request, String chatId) async {
    try {
      await service.endChat(int.parse(chatId));
      return Response.ok(jsonEncode({}));
    } catch (e, s) {
      log.error('Erro ao finalizar chat', e, s);
      return Response.internalServerError();
    }
  }

  Router get router => _$ChatControllerRouter(this);
}
