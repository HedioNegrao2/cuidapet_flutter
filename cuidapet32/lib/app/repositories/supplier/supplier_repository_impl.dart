import 'package:cuidapet32/app/core/exeptions/failre.dart';
import 'package:cuidapet32/app/core/logger/app_logger.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client.dart';
import 'package:cuidapet32/app/core/rest_client/rest_client_exception.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/supplier_category_model.dart';
import 'package:cuidapet32/app/models/supplier_nearby_me_model.dart';
import './supplier_repository.dart';

class SupplierRepositoryImpl extends SupplierRepository {
  final RestClient _restClient;
  final AppLogger _logger;

  SupplierRepositoryImpl(
      {required RestClient restClient, required AppLogger logger})
      : _restClient = restClient,
        _logger = logger;

  @override
  Future<List<SupplierCategoryModel>> getCategories() async {
    try {
      final result = await _restClient.auth().get('/categories/');
      return result.data
          .map<SupplierCategoryModel>((categoryResponse) =>
              SupplierCategoryModel.fromMap(categoryResponse))
          .toList();
    } on RestClientException catch (e, s) {
      const message = 'Erro ao buscar categorias';
      _logger.error(message, e, s);
      throw Failure(message: message);
    }
  }

  @override
  Future<List<SupplierNearbyMeModel>> findNearBy(AddressEntity address) async {
    try {
      final result =
          await _restClient.auth().get('/suppliers/', queryParameters: {
        'lat': address.lat,
        'lng': address.lng,
      });

      return result.data
          .map<SupplierNearbyMeModel>((supplierResponse) =>
              SupplierNearbyMeModel.fromMap(supplierResponse))
          .toList();
    } on RestClientException catch (e, s) {
      const message = 'Erro ao buscar fornecedores próximos';
      _logger.error(message, e, s);
      throw Failure(message: message);
    }
  }
}
