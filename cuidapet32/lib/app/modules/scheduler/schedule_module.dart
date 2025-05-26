
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:cuidapet32/app/modules/core/supplier/supplier_core_module.dart';
import 'package:cuidapet32/app/modules/scheduler/schedule_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ScheduleModule extends Module {
  @override
  List<Module> get imports => [
        CoreMudule(),
        SupplierCoreModule(),
      ];


  @override
  void binds(Injector i) {
    // i.addSingleton<HomeController>(HomeController.new);    
  }

   
  @override
  void routes(r) {    
    r.child(Modular.initialRoute, child: (_, ) => const SchedulePage());
  }

  
}