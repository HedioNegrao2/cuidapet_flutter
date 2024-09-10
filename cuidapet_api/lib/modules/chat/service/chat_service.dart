
import 'package:cuidapet_api/modules/chat/data/i_chat_repository.dart';
import 'package:cuidapet_api/modules/chat/service/i_chat_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IChatService)
class ChatService implements IChatService {
  final IChatRepository repository;
  
  ChatService({
    required this.repository,
  });

  @override
  Future<int> startChat(int scheduleId) => repository.startChat(scheduleId);   
  
}
