import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_confirmImputModel.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_save_imput_model.dart';

abstract class IUserService {
   Future<User> createUser(UserSaveImputModel user);
   Future<User> loginWithEmailPassword(String email, String password , bool supplierUser);
   Future<User> loginWithSocial(String email, String avatar, String socialKey, String  socialType);
   Future<String> confirmLogin(UserConfirmImputModel imputModel);
}