import 'package:cuidapet32/app/models/place_model.dart';
import 'package:cuidapet32/app/services/address/address_service.dart';
import 'package:mobx/mobx.dart';
part 'address_seach_controller.g.dart';

class AddressSeachController = AddressSeachControllerBase with _$AddressSeachController;

abstract class AddressSeachControllerBase with Store {
  final AddressService _addressService;

    AddressSeachControllerBase({
    required AddressService addressService,

    }) : _addressService = addressService;


    Future<List<PlaceModel>> searchAddress(String addressPattern) => 
       _addressService.findAddressesByGooglePaces(addressPattern);
    

}