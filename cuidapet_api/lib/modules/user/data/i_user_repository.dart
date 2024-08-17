import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/view_modules/platform.dart';

abstract interface class IUserRepository {
  Future<User> createUser(User user);
  Future<User> loginWithEmailPassword(String email, String password , bool supplierUser);
  Future<User> loginByEmailSocialKey(String email, String socialKey, String  socialType);
  Future<void> updateUserDeviceTokenAndrefreshToken(User user);
  Future<void> updateRefreshToken(User user);
  Future<User> findById(int id);
  Future<void> updateUrlAvatar(int userId, String urlAvatar);
  Future<void> updateDeviceToken(int userId, String deviceToken, Platform platform);
}