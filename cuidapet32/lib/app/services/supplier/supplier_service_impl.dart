import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/supplier_category_model.dart';
import 'package:cuidapet32/app/models/supplier_model.dart';
import 'package:cuidapet32/app/models/supplier_nearby_me_model.dart';
import 'package:cuidapet32/app/models/supplier_services_model.dart';
import 'package:cuidapet32/app/repositories/supplier/supplier_repository.dart';
import 'package:cuidapet32/app/services/supplier/supplier_service.dart';

class SupplierServiceImpl extends SupplierService {
  final SupplierRepository _repository;

  SupplierServiceImpl({required SupplierRepository repository})
      : _repository = repository;

  @override
  Future<List<SupplierCategoryModel>> getCategories() =>
      _repository.getCategories();

  @override
  Future<List<SupplierNearbyMeModel>> findNearBy(AddressEntity address) =>
      _repository.findNearBy(address);

  @override
  Future<SupplierModel> findById(int id) => _repository.findById(id);

  @override
  Future<List<SupplierServicesModel>> findServices(int supplierId) =>
      _repository.findServices(supplierId);
}
