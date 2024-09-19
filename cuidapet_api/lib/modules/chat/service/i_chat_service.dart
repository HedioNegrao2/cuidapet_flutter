import 'package:cuidapet_api/entities/chat.dart';
import 'package:cuidapet_api/modules/chat/view_models/chat_notfy_view_model.dart';

abstract class IChatService {
   Future<int> startChat(int scheduleId);
   Future<void> notifyChat(ChatNotfyViewModel model);
   Future<List<Chat>> getChatsByUser(int userId);
   Future<List<Chat>> getChatsBySupplier(int supplierId);
   Future<void> endChat(int chatId);
}