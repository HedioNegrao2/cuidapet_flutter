abstract interface class UserRepository {

  Future<void> register(String email, String password);

}