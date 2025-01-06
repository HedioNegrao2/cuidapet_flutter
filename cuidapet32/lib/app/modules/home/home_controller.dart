import 'package:cuidapet32/app/core/live_cycle/controller_live_cycle.dart';
import 'package:cuidapet32/app/core/ui/widgets/loader.dart';
import 'package:cuidapet32/app/entities/address_entity.dart';
import 'package:cuidapet32/app/services/address/address_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store, ControllerLiveCycle {

  final AddressService _addressService;

  HomeControllerBase({
    required AddressService addressService,
  }) : _addressService = addressService;  


  @readonly
  AddressEntity? _addressEntity;
 

  @override
  Future<void> onReady() async{
    Loader.show();
    await _getAddressSelected();
    Loader.hide();
    
  }

  @action
  Future<void> _getAddressSelected() async {

    _addressEntity ??= await _addressService.getAddressSelected();

    if (_addressEntity == null) {
      await goToAddressPage(); 
    }
     
  }

  @action
  Future<void> goToAddressPage() async {
    final address = await Modular.to.pushNamed<AddressEntity>('/address/');
    if (address != null) {  
      _addressEntity = address;
    }
  }  
}