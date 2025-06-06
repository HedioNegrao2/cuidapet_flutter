
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:cuidapet32/app/modules/core/supplier/supplier_core_module.dart';
import 'package:cuidapet32/app/modules/supplier/supplier_controller.dart';
import 'package:cuidapet32/app/modules/supplier/supplier_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SupplierMudule extends Module {
  @override
  List<Module> get imports => [
        CoreMudule(),
        SupplierCoreModule(),
      ];


  @override
  void binds(Injector i) {
    i.addSingleton<SupplierController>(SupplierController.new);    
  }

   
  @override
  void routes(r) {    
    r.child(Modular.initialRoute, child: (_ ) =>  SupplierPage(
      supplierId:  int.parse( r.args.data),
    ));
  }

}
  
