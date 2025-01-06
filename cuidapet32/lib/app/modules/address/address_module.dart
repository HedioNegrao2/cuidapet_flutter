import 'package:cuidapet32/app/modules/address/address_detail/address_datail_module.dart';
import 'package:cuidapet32/app/modules/address/address_page.dart';
import 'package:cuidapet32/app/modules/address/widgets/address_controller.dart';
import 'package:cuidapet32/app/modules/address/widgets/address_seach_widget/address_seach_controller.dart';
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AddressModule extends Module {
  @override
  List<Module> get imports => [
        CoreMudule(),
      ];

  @override
  void binds(Injector i) {
    i.addLazySingleton<AddressSeachController>(AddressSeachController.new);
    i.addLazySingleton<AddressController>(AddressController.new);
  }

  @override
  void routes(r) {
    r.child(Modular.initialRoute, child: ( _, ) => const AddresPage());     
    r.module('/detail', module: AddresDatailModule());
  }
}
