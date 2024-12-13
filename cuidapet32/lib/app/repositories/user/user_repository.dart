import 'package:cuidapet32/app/models/confirm_login_model.dart';
import 'package:cuidapet32/app/models/social_network_model.dart';
import 'package:cuidapet32/app/models/user_model.dart';


abstract interface class UserRepository {

  Future<void> register(String email, String password);
  Future<String> login(String email, String password);
  Future<ConfirmLoginModel> confirmLogin();
  Future<UserModel> getUserLogged();
  Future<String> loginSocial(SocialNetworkModel model);

}