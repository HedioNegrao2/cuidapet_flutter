import 'dart:math';

import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';
import '../../../core/mySQL/mock_database_connecrion.dart';
import '../../../core/mySQL/mock_mysql_connection.dart';
import '../../../core/mySQL/mock_result_row.dart';
import '../../../core/mySQL/mock_results.dart';

void main() {

  late IDatabaseConnection database;
  late ILogger  log;
  late MySqlConnection mysqlConnection;
  late Results mySQLResults;
  late ResultRow mySQLResultsRow;

  setUp(() {
    // Initialize the database and logger mocks
    database = MockDatabaseConnecrion();
    log = MockLogger();
    mysqlConnection = MockMysqlConnection();
    mySQLResults = MockResults();
    mySQLResultsRow = MockResultRow();
  });


 group('Group test findById', () {
   test('should return user by id', () async {
     //Arrange
     final  userRepository = UserRepository(connection: database, log: log);
     when(() => mysqlConnection.close()).thenAnswer((_) async => _);
     when(() => mySQLResults.first).thenReturn(mySQLResultsRow);
     when(() => mySQLResultsRow['id']).thenAnswer((invocation) => 1);
     when(() => mysqlConnection.query(any(), any())).thenAnswer((_) async  => mySQLResults);
     when(() => mySQLResults.isEmpty).thenReturn(false);
     when(() => database.openConnection()).thenAnswer((_) async => mysqlConnection);
  
     //Act
      final user = await userRepository.findById(1);

     //Assert
      expect(user, isA<User>());
      expect(user.id, 1);
      
     
   });
 });
}