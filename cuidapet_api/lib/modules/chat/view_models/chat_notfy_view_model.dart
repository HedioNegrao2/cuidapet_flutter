
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

enum NotificationUserType { user, supplier }

class ChatNotfyViewModel extends RequestMapping {
  
  late int chatId;
  late String message;
  late NotificationUserType notificationUserType;
  
  ChatNotfyViewModel(String dataRequest) : super(dataRequest);
  
 
  
  @override
  void map()  {
    chatId = data['chatId'];
    message = data['message'];
    String notificationTypeRq = data['to'];
    notificationUserType = notificationTypeRq.toLowerCase() == 'u' ? NotificationUserType.user : NotificationUserType.supplier;
  }
}