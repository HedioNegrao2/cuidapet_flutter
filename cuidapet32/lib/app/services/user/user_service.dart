import 'package:cuidapet32/app/models/social_login_type.dart';

abstract  class UserService {

   Future<void> register(String email, String password);
   Future<void> login(String email, String password);
   Future<void> socialLogin(SocialLoginType socialLoginType);
   

}