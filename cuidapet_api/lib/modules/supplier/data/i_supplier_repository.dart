import 'package:cuidapet_api/dtos/supplier_nearby_me_dto.dart';

abstract class ISupplierRepository {
  Future<List<SupplierNearbyMeDto>> findNearByPosition(double lat, double long, int distance);

}