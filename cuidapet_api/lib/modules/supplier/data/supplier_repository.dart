import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/exceptions/database_exceptions.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api/modules/supplier/data/i_supplier_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:mysql1/mysql1.dart';

@LazySingleton(as: ISupplierRepository)
class SupplierRepository implements ISupplierRepository {
  final IDatabaseConnection connection;
  final ILogger log;
  SupplierRepository({
    required this.connection,
    required this.log,
  });

  @override
  Future<List<SupplierNearbyMeDto>> findNearByPosition(
      double lat, double long, int distance) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query = '''

      select f.id, f.nome, f.logo, f.categorias_fornecedor_id, 
      (6371 * 
        acos( 
                        cos(radians($lat)) * 
                        cos(radians(ST_X(f.latlng))) * 
                        cos(radians($long) - radians(ST_Y(f.latlng))) + sin(radians($lat)) * 
                        sin(radians(ST_X(f.latlng))) 
            )) As distancia 
            from fornecedor f 
            having distancia <= $distance;
    ''';
      final result = await conn.query(query);

      return result
          .map((f) => SupplierNearbyMeDto(
              id: f['id'],
              name: f['nome'],
              logo: (f['logo'] as Blob?)?.toString(),
              distance: f['distancia'],
              categoryId: f['categorias_fornecedor_id']))
          .toList();
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar fornecedores próximos', e, s);
      throw DatabaseException();
    } finally {
      conn?.close();
    }
  }
}
