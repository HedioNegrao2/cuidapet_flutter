import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_save_imput_model.dart';

abstract class IUserService {
   Future<User> createUser(UserSaveImputModel user);
}