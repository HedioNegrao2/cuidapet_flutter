import 'package:cuidapet32/app/core/ui/widgets/loader.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/place_model.dart';
import 'package:cuidapet32/app/services/address/address_service.dart';
import 'package:mobx/mobx.dart';

part 'address_datail_conttroller.g.dart';

class AddressDatailConttroller = AddressDatailConttrollerBase with _$AddressDatailConttroller;

abstract class AddressDatailConttrollerBase with Store {
  final AddressService _addressService;

  @readonly
  AddressEntity? _addressEntity;

  AddressDatailConttrollerBase({required AddressService addressService}) : _addressService = addressService;

  Future<void> saveAddress(PlaceModel place, String additional) async {  
    Loader.show();
    final addressEntity = await _addressService.saveAddress(place, additional);
    Loader.hide();
    _addressEntity = addressEntity;
  }

}