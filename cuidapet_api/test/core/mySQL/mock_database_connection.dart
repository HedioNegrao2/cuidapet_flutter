
import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_mysql_connection.dart';
import 'mock_mysql_exception.dart';
import 'mock_results.dart';


class MockDatabaseConnection extends Mock implements IDatabaseConnection {

  final mysqlConnection = MockMysqlConnection();

  MockDatabaseConnection() {
    when(() => openConnection()).thenAnswer((_) async => mysqlConnection);
  }

   void mockQuery(MockResults mockResults, [List<Object>? params]) {
    when(() => mysqlConnection.query(any(), params ?? any()))
        .thenAnswer((_) async => mockResults);
  }

  void mockQueryException([ MockMysqlException? mockException, List<Object>? params]) {
    var exception = mockException;  

    if (exception == null) {
      exception = MockMysqlException();
      when(() => exception!.message).thenReturn('Erro mysql gerenrico');
    }

    when(() => mysqlConnection.query(any(), params ?? any()))
        .thenThrow(exception);
  }
  
 
  void veryfyConnectionCloser() {
    verify(() => mysqlConnection.close()).called(1);
  }
}