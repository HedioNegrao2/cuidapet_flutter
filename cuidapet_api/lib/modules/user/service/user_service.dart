import 'package:cuidapet_api/application/exceptions/service_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_modules/refresh_token_view_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/update_url_avatar_view_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_confirmImputModel.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_refresh_token_input_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_save_imput_model.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_update_token_device_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepository userRepository;
  ILogger log;

  UserService({
    required this.userRepository,
    required this.log,
  });

  @override
  Future<User> createUser(UserSaveImputModel user) {
    final userEntity = User(
        email: user.email,
        password: user.password,
        registerType: 'APP',
        supplierId: user.supplierId);

    return userRepository.createUser(userEntity);
  }

  @override
  Future<User> loginWithEmailPassword(
          String email, String password, bool supplierUser) =>
      userRepository.loginWithEmailPassword(email, password, supplierUser);

  @override
  Future<User> loginWithSocial(
      String email, String avatar, String socialKey, String socialType) async {
    try {
      return await userRepository.loginByEmailSocialKey(
          email, socialKey, socialType);
    } on UserNotfoundException catch (e) {
      log.error('Usuario não encontrado, criando um usuário', e);

      final user = User(
        email: email,
        imageAvatar: avatar,
        socialKey: socialKey,
        registerType: socialType,
        password: DateTime.now().toString(),
      );
      return await userRepository.createUser(user);
    }
  }

  @override
  Future<String> confirmLogin(UserConfirmImputModel imputModel) async {
    final refreshToken = JwtHelper.refreshToken(imputModel.acessToken);

    final user = User(
      id: imputModel.userId,
      refreshToken: refreshToken,
      iosToken: imputModel.iosDeviceToken,
      androidToken: imputModel.androidDeviceToken,
    );

    await userRepository.updateUserDeviceTokenAndrefreshToken(user);

    return refreshToken;
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(UserRefreshTokenInputModel model) async {
    _validateRefreshToken(model);

    final newAssessToken = JwtHelper.genereteJWT(model.user, model.supplierId);  
    final newRefreshToken = JwtHelper.refreshToken(newAssessToken.replaceAll('Bearer ', ''));

    final user = User(
      id: model.user,
      refreshToken: newRefreshToken,
     
    );

    await userRepository.updateRefreshToken(user);

    return RefreshTokenViewModel(
      accessToken: newAssessToken,
      refreshToken: newRefreshToken,
    );
  }
  _validateRefreshToken(UserRefreshTokenInputModel model) {
    try {
      final refreshToken = model.refreshToken.split(' ');
      if (refreshToken.length != 2 || refreshToken.first != 'Bearer') {
        log.error('Refresh token inválido');
        throw ServiceException('Refresh token inválido');
      }
      final refreshTokenClaim = JwtHelper.getClaims(refreshToken.last);
      refreshTokenClaim.validate(issuer: model.accessToken);
    } on ServiceException {
      rethrow;  
    
    } on JwtException catch (e) {
      log.error('Refresh token inválido',e);
      throw ServiceException('Refresh token inválido'); 
    
    } catch (e) {
      throw ServiceException('Refresh token inválido');
    }
  }
  
  @override
  Future<User> findById(int id) => userRepository.findById(id);
  
  @override
  Future<User> updateUrlAvatar(UpdateUrlAvatarViewModel viewModel) async {
   
  await userRepository.updateUrlAvatar(viewModel.userId, viewModel.urlAvatar);
  return await userRepository.findById(viewModel.userId);

  }

  @override
  Future<void> updateDeviceToken(UserUpdateTokenDeviceInputModel model) =>
     userRepository.updateDeviceToken(model.userId, model.token, model.platform,
     );
  
 
}
