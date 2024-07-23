import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_save_imput_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  final IUserRepository userRepository;

  UserService({
    required this.userRepository,
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
}
