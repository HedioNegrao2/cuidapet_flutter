import 'package:cuidapet_api/entities/user.dart';

abstract interface class IUserRepository {
  Future<User> createUser(User user);
  Future<User?> loginWithEmailPassword(String email, String password , bool supplierUser);

}