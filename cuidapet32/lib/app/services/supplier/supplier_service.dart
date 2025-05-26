import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/supplier_category_model.dart';
import 'package:cuidapet32/app/models/supplier_model.dart';
import 'package:cuidapet32/app/models/supplier_nearby_me_model.dart';
import 'package:cuidapet32/app/models/supplier_services_model.dart';

abstract class SupplierService {

  Future<List<SupplierCategoryModel>> getCategories();
  Future<List<SupplierNearbyMeModel>> findNearBy(AddressEntity address);
  Future<SupplierModel> findById(int id);
  Future<List<SupplierServicesModel>> findServices(int supplierId);
}