import 'package:cuidapet32/app/modules/address/address_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddressModule extends Module {
    @override
  void binds(Injector i) {}


 @override
  void routes(r) {    
    r.child(Modular.initialRoute, child: (_, ) => const AddresPage());
  }
  
} 