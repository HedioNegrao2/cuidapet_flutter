import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/exceptions/database_exceptions.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/category.dart';
import 'package:cuidapet_api/modules/categories/data/i_categories_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

@LazySingleton(as: ICategoriesRepository)
class CategoriesRepository implements ICategoriesRepository {
  IDatabaseConnection connection;
  ILogger log;

  CategoriesRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<List<Category>> findAll() async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();
    final restult = await conn.query('select * from categorias_fornecedor');

    if(restult.isNotEmpty){
      return restult.map((e) => Category(
        id: e['id'],
        name: e['nome_categoria'],
        type: e['tipo_categoria']
      )).toList();
    }
    return [];
    
    }  on MySqlException catch (e, s) {
      log.error('Erro ao consultar as categorias de fornecedor', e, s);
      throw DatabaseException();    
    }
    finally {
      await conn?.close();
    }
  }
}

