import 'dart:convert';

import 'package:cuidapet_api/application/exceptions/database_exceptions.dart';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/cripty_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/test.dart';
import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/mySQL/mock_database_connection.dart';
import '../../../core/mySQL/mock_mysql_exception.dart';
import '../../../core/mySQL/mock_results.dart';


void main() {

  late MockDatabaseConnection database;
  late ILogger  log;
  late UserRepository userRepository;

  setUp(() {
    // Initialize the database and logger mocks
    database = MockDatabaseConnection();
    log = MockLogger();
    userRepository = UserRepository(connection: database, log: log);
    
   
  });


 group('Group test findById', () {
   test('should return user by id', () async {
     //Arrange
     final userFixtureDB = FixtureReader.getJsonData('modules/user/data/fixture/find_by_id_sucesss_fixture.json');
     final   mysqlResults = MockResults(userFixtureDB, [
      'ios_token',
      'android_token',
      'refresh_token',
      'img_avatar',
      'social_id'
     ]) ;
     
     
     database.mockQuery(mysqlResults);

      final userMap = jsonDecode(userFixtureDB);
      final userExpected = User(
         id: userMap['id'] as int,
          email: userMap['email'],
          registerType: userMap['tipo_cadastro'],
          supplierId: userMap['fornecedor_id'],
          socialKey: userMap['social_id'] ,
          iosToken: userMap['ios_token'] ,
          androidToken: userMap['android_token'] ,
          imageAvatar: userMap['img_avatar'] ,
          refreshToken: userMap['refresh_token'] ,
       );
        
  
     //Act
      final user = await userRepository.findById(1);

     //Assert
      expect(user, isA<User>());
      expect(user.id, 1);
      expect(user, userExpected);
      
     
   });

  test('Shwuld return exception UserNotFoundException', () async {
   //Arrange
    final id = 1;
    final mockResults = MockResults();
    
    database.mockQuery(mockResults, [id]);
    
   
   //Act
    var call = userRepository.findById; 
   //Assert

   expect(() => call(id), throwsA(isA<UserNotfoundException>()));
   
 });
 });

 group('Group test create user', () {
  test('Shouls create user with success', () async {
    //Arrange
    final userId = 1;
    final mockResults  = MockResults();
    when(() => mockResults.insertId).thenReturn(userId);
    database.mockQuery(mockResults);

    final userInsert = User(id: userId,
      email: 'josedasilava@gamil.com',
      registerType: 'email',
      supplierId: 1,
      imageAvatar: '',
      socialKey: 'socialKey',
      password: '123123'
      );

      final userExpected = User(id: userId,
      email: 'josedasilava@gamil.com',
      registerType: 'email',
      supplierId: 1,
      imageAvatar: '',
      socialKey: 'socialKey',
      password: '',
     );

   
    //Act
    
    final user = await userRepository.createUser(userInsert);

        //Assert
   // expect(user, isA<User>());
    expect(user.id, userId);
    expect(user, userExpected);

  });

  test('Should trhow DatabaseException', () async {
    //Arrange
    database.mockQueryException();


    //Act
    var call = userRepository.createUser;

    //Assert
    expect(() => call(User()), throwsA(isA<DatabaseException>()));

  });


  
  test('Should trhow DatabaseException', () async {
    //Arrange
    final exception = MockMysqlException();
    when(() => exception.message).thenReturn('usuario.email_UNIQUE');
    database.mockQueryException(exception);


    //Act
    var call = userRepository.createUser;

    //Assert
    expect(() => call(User()), throwsA(isA<UserExistsException>()));

  });
   
 });
 
}