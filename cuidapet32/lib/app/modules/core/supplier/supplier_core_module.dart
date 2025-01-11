
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:cuidapet32/app/repositories/supplier/supplier_repository.dart';
import 'package:cuidapet32/app/repositories/supplier/supplier_repository_impl.dart';
import 'package:cuidapet32/app/services/supplier/supplier_service.dart';
import 'package:cuidapet32/app/services/supplier/supplier_service_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SupplierCoreModule extends Module {
  
  @override
  void binds(i) {
     i.addLazySingleton<SupplierRepository>(SupplierRepositoryImpl.new);
     i.addLazySingleton<SupplierService>(SupplierServiceImpl.new);
  }

  @override
  List<Module> get imports => [
    CoreMudule(),
  ];
  
}