
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserConfirmImputModel extends RequestMapping {
  int userId;
  String acessToken;
  late String iosDeviceToken;
  late String androidDeviceToken;

  UserConfirmImputModel({
    required this.userId,
    required this.acessToken,   
    required String data,
  }):super(data);
  
  @override
  void map() {
   iosDeviceToken = data['ios_token'];
   androidDeviceToken = data['android_token'];

  }
  
}
