import 'package:cuidapet_api/application/facades/push_notification_facade.dart';
import 'package:cuidapet_api/entities/chat.dart';
import 'package:cuidapet_api/modules/chat/data/i_chat_repository.dart';
import 'package:cuidapet_api/modules/chat/service/i_chat_service.dart';
import 'package:cuidapet_api/modules/chat/view_models/chat_notfy_view_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IChatService)
class ChatService implements IChatService {
  final IChatRepository repository;
  final PushNotificationFacade pushNotificationFacade;

  ChatService(     {
    required this.pushNotificationFacade, 
    required this.repository,
  });

  @override
  Future<int> startChat(int scheduleId) => repository.startChat(scheduleId);

  @override
  Future<void> notifyChat(ChatNotfyViewModel model) async {
    final chat = await repository.findChatById(model.chatId);

    if (chat != null) {
      switch (model.notificationUserType) {
        case NotificationUserType.user:
          //notificar usuario
          _notifyUser(chat.userDeviceToken?.tokens, model, chat);
          break;
        case NotificationUserType.supplier:
          //notificar fornecedor
          _notifyUser(chat.supplierDeviceToken?.tokens, model, chat);
          break;
        default:
          throw Exception('Tipo de notificação inválida');
      }
    }
  }

  void _notifyUser(List<String?>? tokens, ChatNotfyViewModel model, Chat chat) {
    final payload = <String, dynamic>{
      'type': 'CHAT_MESSAGE',
      'chat': {
        'id': chat.id,
        'name': chat.nome,
        'forncedor': {
          'nome': chat.supplier.name,
          'logo': chat.supplier.logo,
        }
      }
    };

    pushNotificationFacade.sendMessage(
      devaices: tokens ?? [],
      title: 'Nova mensagem',
      body: model.message,
      pyload: payload,
    );
  }
  
  @override
  Future<List<Chat>> getChatsByUser(int userId) => repository.findChatsByUser(userId);

  @override
  Future<List<Chat>> getChatsBySupplier(int supplierId) => repository.findChatsBySupplier(supplierId);
  
  @override
  Future<void> endChat(int chatId) => repository.endChat(chatId);
    
}
