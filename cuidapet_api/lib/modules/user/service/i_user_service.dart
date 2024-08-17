import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/view_modules/refresh_token_view_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/update_url_avatar_view_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_confirmImputModel.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_refresh_token_input_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_save_imput_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_update_token_device_input_model.dart';

abstract class IUserService {
   Future<User> createUser(UserSaveImputModel user);
   Future<User> loginWithEmailPassword(String email, String password , bool supplierUser);
   Future<User> loginWithSocial(String email, String avatar, String socialKey, String  socialType);
   Future<String> confirmLogin(UserConfirmImputModel imputModel);
   Future<RefreshTokenViewModel> refreshToken(UserRefreshTokenInputModel model);
   Future<User> findById(int id);
   Future<User> updateUrlAvatar(UpdateUrlAvatarViewModel viewModel);
   Future<void> updateDeviceToken(UserUpdateTokenDeviceInputModel model);

}