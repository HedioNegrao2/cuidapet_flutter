
import 'package:cuidapet32/app/modules/address/address_detail/address_datail_conttroller.dart';
import 'package:cuidapet32/app/modules/address/address_detail/address_detail_page.dart';
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddresDatailModule extends Module {

  @override
  List<Module> get imports => [
        CoreMudule(),
      ];

   
   @override
  void binds(Injector i) {
    i.addSingleton<AddressDatailConttroller>(AddressDatailConttroller.new);
  }

  
  @override
  void routes(r) {

      r.child('/', child: (_) => AddressDetailPage(place: r.args.data));     
    
  }










  
}