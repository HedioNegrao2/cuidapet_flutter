import 'package:cuidapet32/app/core/live_cycle/controller_live_cycle.dart';
import 'package:cuidapet32/app/core/ui/widgets/loader.dart';
import 'package:cuidapet32/app/core/ui/widgets/messages.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/models/place_model.dart';
import 'package:cuidapet32/app/services/address/address_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobx/mobx.dart';
import 'package:geocoding/geocoding.dart';

part 'address_controller.g.dart';


class AddressController = AddressControllerBase with _$AddressController;

abstract class AddressControllerBase with Store, ControllerLiveCycle {
  final AddressService _addressService;

  @readonly
  var _addresses = <AddressEntity> [];

  @readonly
  var _locationServiceUnavailable = false.obs();

  @readonly
  Observable<LocationPermission>? _locationPermission;

  @readonly
  PlaceModel? _placeModel;

  

  AddressControllerBase({
    required AddressService addressService,
  }) : _addressService = addressService;

  @override
  onReady() {
    getAddressess();
  }

  @action
  Future<void> getAddressess() async {
    Loader.show();
    _addresses = await _addressService.getAddress();
    Loader.hide();
  }

  @action
 Future<void> myLocation() async {
   
   

    final serviceEnable = await Geolocator.isLocationServiceEnabled();
    
    if (!serviceEnable) {
      _locationServiceUnavailable = true.obs();
      return;
    }

    final locationPermission = await Geolocator.checkPermission();

   
    switch (locationPermission) {
      case LocationPermission.denied:
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _locationPermission = Observable(permission);
          return;
        }
        break;
      case LocationPermission.deniedForever:
        _locationPermission = Observable(locationPermission);

        break;
      case LocationPermission.whileInUse:
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
        break;    
    }

    Loader.show();
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placeMark = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    final palce = placeMark.first;
    final address = '${palce.thoroughfare}, ${palce.subThoroughfare}';

    final placeModel = PlaceModel(address: address, lat: position.latitude, lng: position.longitude);

    Loader.hide();
    goToAddresDetail(placeModel);
    

  }

  Future<void> goToAddresDetail(PlaceModel place) async {
   final address = await  Modular.to.pushNamed('/address/detail/', arguments: place);
   if(address is PlaceModel){
     _placeModel = address;
   }else if(address is AddressEntity){
     await selectAddress(address);
   }
  }

  Future<void> selectAddress(AddressEntity addressEntity) async {
    await _addressService.selectAddress(addressEntity);
    Modular.to.pop(addressEntity);
  }

  Future<bool> addressWasSelectec() async {
    final address = await _addressService.getAddressSelected();
    if(address != null){
      return true;
      
    }
    else{
      Messages.alert( 'Por favar selecione ou cadastre um endereço');
      return false;
    }
    
  }

}
