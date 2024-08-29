import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api/entities/category.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart';
import 'package:cuidapet_api/modules/supplier/data/i_supplier_repository.dart';
import 'package:cuidapet_api/modules/supplier/service/i_supplier_service.dart';
import 'package:cuidapet_api/modules/supplier/view_models/create_spplier_user_view_model.dart';
import 'package:cuidapet_api/modules/supplier/view_models/supplier_update_imput_model.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_save_imput_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ISupplierService)
class SupplaierService implements ISupplierService {
  final ISupplierRepository repository;
  final IUserService userService;

   static const DISTANCE = 5;
 
  SupplaierService({
    required this.repository,
    required this.userService,
  });
 

  @override
  Future<List<SupplierNearbyMeDto>> findNearByMe(double lat, double long) =>
      repository.findNearByPosition(lat, long, DISTANCE);

  @override
  Future<Supplier?> findById(int id) => repository.findById(id);

  @override
  Future<List<SupplierService>> findServiceBySupplierId(int supplierId) => repository.findServiceBySupplierId(supplierId);
  
  @override
  Future<bool> checkUserEmailExists(String email) => repository.checkUserEmailExists(email);

  @override
   Future<void> createUserSupplier(CreateSpplierUserViewModel model) async {
     final supplierEntity = Supplier(
      name: model.supplierName,
      category: Category(id: model.category), 
     );
     final supplierId = await repository.saveSupplier(supplierEntity);

     
    final userInputModel = UserSaveImputModel(
      email: model.email,
      password: model.password,
      supplierId: supplierId,
    );

    await userService.createUser(userInputModel);


   }

  @override
  Future<Supplier> update(SupplierUpdateImputModel model) async {
   
   var supplier =  Supplier(
      id: model.supplierId,
      name: model.name,      
      address: model.address,
      lat: model.lat,
      lng: model.lng,
      logo: model.logo,
      phone: model.phone,
      category: Category(id: model.categoryId),
    );
    return await repository.update(supplier);
  
  }
  

  
}
