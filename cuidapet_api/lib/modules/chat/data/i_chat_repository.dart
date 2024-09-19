import 'package:cuidapet_api/entities/chat.dart';

abstract class IChatRepository {
  Future<int> startChat(int scheduleId);
  Future<Chat?> findChatById(int chatId);
  Future<List<Chat>> findChatsByUser(int userId);
  Future<List<Chat>> findChatsBySupplier(int supplier);
  Future<void> endChat(int chatId);
}