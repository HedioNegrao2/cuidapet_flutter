import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/exceptions/database_exceptions.dart';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/cripty_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

@LazySingleton(as: IUserRepository)
class UserRepository implements IUserRepository {
  final IDatabaseConnection connection;
  final ILogger log;

  UserRepository({required this.connection, required this.log});

  @override
  Future<User> createUser(User user) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = '''
        INSERT INTO usuario
          (email, tipo_cadastro, img_avatar, senha, fornecedor_id, social_id)
        VALUES
          (?, ?, ?, ?, ?, ? )
      ''';

      final result = await conn.query(query, <Object?>[
        user.email,
        user.registerType,
        user.imageAvatar,
        CriptyHelper.generateSha256(user.password ?? ''),
        user.supplierId,
        user.socialKey
      ]);

      final userId = result.insertId;

      return user.copyWith(id: userId, password: null);
    } on MySqlException catch (e, s) {
      if (e.message.contains('usuario.email_UNIQUE')) {
        log.error('Erro ao criar usuario', e, s);
        throw UserExistsException();
      }
      log.error('Erro ao criar usuario', e, s);
      throw DatabaseException(message: 'Erro ao criar usuario', exception: e);
    } finally {
      conn?.close();
    }
  }

  @override
  Future<User> loginWithEmailPassword(
      String email, String password, bool supplierUser) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();

      var query = '''
      SELECT * FROM  usuario u
      WHERE 
        u.email = ? AND u.senha = ?
    ''';

      if (supplierUser) {
        query += ' and fornecedor_id is not null';
      } else {
        query += ' and fornecedor_id is null';
      }

      final result = await conn.query(query, [
        email,
        CriptyHelper.generateSha256(password),
      ]);

      if (result.isEmpty) {
        log.error('Usuário ou senha invalido!!!');
        throw UserNotfoundException(
            message: 'Usuário ou senha invalido!!!');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],          
          registerType: userSqlData['tipo_cadastro'],
          supplierId: userSqlData['fornecedor_id'],
          socialKey: userSqlData['social_id'],
          iosToken: (userSqlData['ios_token'] as Blob?)?.toString(), 
          androidToken: (userSqlData['android_token'] as Blob?)?.toString(), 
          imageAvatar: (userSqlData['android_token'] as Blob?)?.toString(), 
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar usuario', e, s);
      throw DatabaseException(message: e.message);
    } finally {
      await conn?.close();
    }
  }
}