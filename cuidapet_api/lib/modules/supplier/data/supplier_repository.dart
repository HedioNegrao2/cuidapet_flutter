import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/exceptions/database_exceptions.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api/entities/category.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart';
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

  @override
  Future<Supplier?> findById(int id) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query = '''

      select f.id, f.nome, f.logo, f.endereco, f.telefone,  ST_X(f.latlng) as lat, ST_Y(f.latlng) as lng, 
      f.categorias_fornecedor_id,c.nome_categoria, c.tipo_categoria
      from fornecedor f
      inner join categorias_fornecedor c on (c.id = f.categorias_fornecedor_id)
      where f.id = ?;
    ''';
      final result = await conn.query(query, [id]);

      if (result.isEmpty) {
        return null;
      }

      final f = result.first;
      return Supplier(
          id: f['id'],
          name: f['nome'],
          logo: (f['logo'] as Blob?)?.toString(),
          address: f['endereco'],
          phone: f['telefone'],
          lat: f['lat'],
          lng: f['lng'],
          category: Category(
              id: f['categorias_fornecedor_id'],
              name: f['nome_categoria'],
              type: f['tipo_categoria']));
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar fornecedores próximos', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<List<SupplierService>> findServiceBySupplierId(int supplierId) async {
    MySqlConnection? conn;

    try {
      conn = await connection.openConnection();

      final query = '''
      select id, fornecedor_id, nome_servico, valor_servico      
      from fornecedor_servicos
      where fornecedor_id = ?;     
    ''';
      final result = await conn.query(query, [supplierId]);

      if (result.isEmpty) {
        return [];
      }

      return result
          .map((f) => SupplierService(
              id: f['id'],
              supplierId: f['fornecedor_id'],
              name: f['nome_servico'],
              price: f['valor_servico']))
          .toList();
    } on MySqlException catch (e, s) {
      log.error('Erro ao buscar serviços de fornecedor', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<bool> checkUserEmailExists(String email) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final result = await conn.query(
          'select count(*) as total from usuario where email = ?', [email]);
      return result.first['total'] > 0;
    } on MySqlException catch (e, s) {
      log.error('Erro ao verificar se email do fornecedor existe', e, s);
      throw DatabaseException();
    } finally {
      conn?.close();
    }
  }

  @override
  Future<int> saveSupplier(Supplier supplier) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
      final result = await conn.query(
          '''insert into fornecedor(nome, logo, endereco, telefone, latlng, categorias_fornecedor_id)
           values(?, ?, ?, ?,ST_GeomfromText(?), ?)
      
      ''',
          [
            supplier.name,
            supplier.logo,
            supplier.address,
            supplier.phone,
            'POINT(${supplier.lat ?? 0} ${supplier.lng ?? 0})',
            supplier.category?.id
          ]);
      return result.insertId ?? 0;
    } on MySqlException catch (e, s) {
      log.error('Erro ao cadastrar novo fornecedor', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }

  @override
  Future<Supplier> update(Supplier supplier) async {
    MySqlConnection? conn;
    try {
      conn = await connection.openConnection();
        await conn.query('''update  fornecedor
              set 
                nome = ?, 
                logo = ?, 
                endereco = ?, 
                telefone = ?, 
                latlng = ST_GeomfromText(?), 
                categorias_fornecedor_id = ?
            where id = ?      
      ''', [
        supplier.name,
        supplier.logo,
        supplier.address,
        supplier.phone,
        'POINT(${supplier.lat ?? 0} ${supplier.lng ?? 0})',
        supplier.category?.id,
        supplier.id
      ]);

      Category? category;

      if (supplier.category?.id != null) {
        final resultCategory = await conn.query('''
          select c.nome_categoria, c.tipo_categoria
          from categorias_fornecedor c
          where c.id = ?;
        ''', <Object?>[supplier.category?.id]);
        category = Category(
          id: supplier.category?.id,
          name: resultCategory.first['nome_categoria'],
          type: resultCategory.first['tipo_categoria'],
        );
      }

      return supplier = supplier.copyWith(category: category);
    } on MySqlException catch (e, s) {
      log.error('Erro ao atualizar dados do fornecedor', e, s);
      throw DatabaseException();
    } finally {
      await conn?.close();
    }
  }
}
