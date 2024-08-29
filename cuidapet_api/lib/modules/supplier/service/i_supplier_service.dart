
import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart';
import 'package:cuidapet_api/modules/supplier/view_models/create_spplier_user_view_model.dart';
import 'package:cuidapet_api/modules/supplier/view_models/supplier_update_imput_model.dart';

abstract class ISupplierService {
   Future<List<SupplierNearbyMeDto>> findNearByMe(double lat, double long);
   Future<Supplier?> findById(int id);
   Future<List<SupplierService>> findServiceBySupplierId(int supplierId);
   Future<bool> checkUserEmailExists(String email);
   Future<void> createUserSupplier(CreateSpplierUserViewModel model); 
   Future<Supplier> update(SupplierUpdateImputModel model);
  
}