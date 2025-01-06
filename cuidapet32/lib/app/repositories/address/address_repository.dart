
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/place_model.dart';

abstract class AddressRepository {

  Future<List<PlaceModel>> findAddressesByGooglePaces(String addressPattern);
  Future<List<AddressEntity>> getAddress();
  Future<int> saveAddress(AddressEntity address);
  Future<void> deleteAddress();  
  
}