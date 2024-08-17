import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/exceptions/database_exceptions.dart';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/cripty_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/view_modules/platform.dart';
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
        log.error('Usuario já cadastrado', e, s);
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
        throw UserNotfoundException(message: 'Usuário ou senha invalido!!!');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
          registerType: userSqlData['tipo_cadastro'],          
          iosToken: (userSqlData['ios_token'] as Blob?)?.toString(),
          androidToken: (userSqlData['android_token'] as Blob?)?.toString(),          
          refreshToken: (userSqlData['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (userSqlData['img_avatar'] as Blob?)?.toString(),
          supplierId: userSqlData['fornecedor_id'],
          socialKey: (userSqlData['social_id'] as Blob?)?.toString(),
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao realizar login', e, s);
      throw DatabaseException(message: e.message);
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<User> loginByEmailSocialKey(
      String email, String socialKey, String socialType) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
      final result =
          await conn.query('Select * from usuario where email = ?', [email]);

      if (result.isEmpty) {
        throw UserNotfoundException(message: 'Usuário não encontrado');
      } else {
        final userSqlData = result.first;

        if (userSqlData['social_id'] == null ||
            userSqlData['social_id'] == socialKey) {
          await conn
              .query('''Update usuario set social_id = ?, tipo_cadastro = ? 
                       where id = ?''', [
            socialKey,
            socialType,
            userSqlData['id'],
          ]);
        }

        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
          registerType: userSqlData['tipo_cadastro'],
          supplierId: userSqlData['fornecedor_id'],
          socialKey: (userSqlData['social_id'] as Blob?)?.toString(),
          iosToken: (userSqlData['ios_token'] as Blob?)?.toString(),
          androidToken: (userSqlData['android_token'] as Blob?)?.toString(),
          imageAvatar: (userSqlData['img_avatar'] as Blob?)?.toString(),
          refreshToken: (userSqlData['refresh_token'] as Blob?)?.toString(),
        );
      }
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<void> updateUserDeviceTokenAndrefreshToken(User user) async{
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final setParams = {};
      if(user.iosToken != null){
        setParams.putIfAbsent('ios_token', () => user.iosToken);
      } else {
        setParams.putIfAbsent('android_token', () => user.androidToken);
      }

      final query = '''
        UPDATE usuario
        SET ${setParams.keys.elementAt(0)} = ?,
        refresh_token = ?
        WHERE id = ?
      ''';

      await conn.query(query, [
        setParams.values.elementAt(0),
        user.refreshToken!,
        user.id!
      ]);

    } on MySqlException catch (e, s) {
     log.error('Erro ao confirmar token do usuario', e,s);   

     throw DatabaseException();
      
    } finally {
      await conn?.close();
    }
  }
  
  @override
  Future<void> updateRefreshToken(User user) async {
   MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = '''
        UPDATE usuario
        SET refresh_token = ?
        WHERE id = ?
      ''';

      await conn.query(query, [user.refreshToken, user.id]);
    } on MySqlException catch (e, s) {
      log.error('Erro ao atualizar refresh token', e, s);
      throw DatabaseException(message: 'Erro ao atualizar refresh token', exception: e);
    } finally {
      conn?.close();    
    }
  }
  
  @override
  Future<User> findById(int id) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final result = await conn.query('select * from usuario where id = ?', [id]);

      if(result.isEmpty){
        log.error('Usuário não encontrado com id $id');
        throw UserNotfoundException(message: 'Usuário não encontrado coom id $id');
      } else {
        final userSqlData = result.first;
        return User(
          id: userSqlData['id'] as int,
          email: userSqlData['email'],
          registerType: userSqlData['tipo_cadastro'],
          supplierId: userSqlData['fornecedor_id'],
          socialKey: (userSqlData['social_id'] as Blob?)?.toString(),
          iosToken: (userSqlData['ios_token'] as Blob?)?.toString(),
          androidToken: (userSqlData['android_token'] as Blob?)?.toString(),
          imageAvatar: (userSqlData['img_avatar'] as Blob?)?.toString(),
          refreshToken: (userSqlData['refresh_token'] as Blob?)?.toString(),
        );
      }
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar usuario por id', e, s);
      throw DatabaseException(message: 'Erro ao buscar usuario por id', exception: e);
    } finally {
      conn?.close();
    } 

  }
  
  @override
  Future<void> updateUrlAvatar(int userId, String urlAvatar) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final query = '''
        UPDATE usuario
        SET img_avatar = ?
        WHERE id = ?
      ''';
      await conn.query(query, [urlAvatar, userId]);
    } on MySqlException catch (e, s) {
      log.error('Erro ao atualizar o avatar', e, s);
      throw DatabaseException(message: 'Erro ao atualizar o avatar', exception: e);
      
    } finally {
       await conn?.close();
    }
  }
  
  @override
  Future<void> updateDeviceToken(int userId, String deviceToken, Platform platform) async {
    
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      var set = ' ';

      if(platform == Platform.ios){
        set = 'ios_token = ?';
      }else {
         set = 'android_token  = ?';
        }  

      final query = '''
        UPDATE usuario
        SET $set 
        WHERE id = ?
      ''';
      await conn.query(query, [deviceToken, userId]);

    } on MySqlException catch (e, s) {
      log.error('Erro ao atualizar o device token', e, s);
      throw DatabaseException(message: 'Erro ao atualizar o device token', exception: e);
      
    } finally {
       await conn?.close();
    }
  }
}
