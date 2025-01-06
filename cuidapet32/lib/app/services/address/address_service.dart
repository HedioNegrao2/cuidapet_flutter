import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/place_model.dart';

abstract class AddressService {
  Future<List<PlaceModel>> findAddressesByGooglePaces(String addressPattern);
  Future<List<AddressEntity>> getAddress();
  Future<AddressEntity> saveAddress(PlaceModel placeModel, String additional);
  Future<void> deleteAddress();  
  Future<void> selectAddress(AddressEntity addressEntity);
  Future<AddressEntity?> getAddressSelected();
}