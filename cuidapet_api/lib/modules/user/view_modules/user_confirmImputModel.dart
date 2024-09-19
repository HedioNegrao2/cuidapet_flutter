
import 'package:cuidapet_api/application/exceptions/request_validation_exception.dart';
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserConfirmImputModel extends RequestMapping {
  int userId;
  String acessToken;
  String? iosDeviceToken;
  String? androidDeviceToken;

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
  
  void validateRequest() {
     final errors = <String, String>{};

    if (iosDeviceToken == null  && androidDeviceToken == null) {
      errors['ios_token or android_token'] = 'required';
    }  

    if (errors.isNotEmpty) {
      throw RequestValidationException(errors);
    }
  } 
}
