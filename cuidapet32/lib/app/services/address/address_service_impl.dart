import 'package:cuidapet32/app/core/helpers/constants.dart';
import 'package:cuidapet32/app/core/local_storage/local_storage.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/place_model.dart';
import 'package:cuidapet32/app/repositories/address/address_repository.dart';
import 'package:cuidapet32/app/services/address/address_service.dart';

class AddressServiceImpl implements AddressService {
  final AddressRepository _addressReposiotry;
  final LocalStorage _localStorage;

  AddressServiceImpl(
      {required AddressRepository addressRepository,
      required LocalStorage localStorage})
      : _addressReposiotry = addressRepository,
        _localStorage = localStorage;

  @override
  Future<List<PlaceModel>> findAddressesByGooglePaces(String addressPattern) =>
      _addressReposiotry.findAddressesByGooglePaces(addressPattern);

  @override
  Future<void> deleteAddress() => _addressReposiotry.deleteAddress();

  @override
  Future<List<AddressEntity>> getAddress() => _addressReposiotry.getAddress();

  @override
  Future<AddressEntity> saveAddress(
      PlaceModel placeModel, String additional) async {
    final address = AddressEntity(
        address: placeModel.address,
        lat: placeModel.lat,
        lng: placeModel.lng,
        additional: additional);

    var addressesId = await _addressReposiotry.saveAddress(address);
    return address.copyWith(id: addressesId);
  }

  @override
  Future<AddressEntity?> getAddressSelected() async {
    final addressJson = await _localStorage.read<String>(Constants.LOCAl_STORAGE_DEFAULT_ADDRESS_DATA_KEY);
    if (addressJson != null) {
      return AddressEntity.fromJson(addressJson);
    }
    return null;
  }

  @override
  Future<void> selectAddress(AddressEntity addressEntity) async {
    await _localStorage.write(Constants.LOCAl_STORAGE_DEFAULT_ADDRESS_DATA_KEY, addressEntity.toJson());
    
  }
}
