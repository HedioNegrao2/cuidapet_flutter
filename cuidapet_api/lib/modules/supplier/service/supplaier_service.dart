import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';
import 'package:cuidapet_api/modules/supplier/data/i_supplier_repository.dart';
import 'package:cuidapet_api/modules/supplier/service/i_supplier_service.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ISupplierService)
class SupplaierService implements ISupplierService {
   static const DISTANCE = 5;
  final ISupplierRepository repository;
  SupplaierService({
    required this.repository,
  });
 

  @override
  Future<List<SupplierNearbyMeDto>> findNearByMe(double lat, double long) =>
      repository.findNearByPosition(lat, long, DISTANCE);
}
