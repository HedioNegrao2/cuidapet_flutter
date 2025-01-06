import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:cuidapet32/app/modules/home/home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/home/home_page.dart';


class HomeModule extends Module {
  @override
  List<Module> get imports => [
        CoreMudule(),
      ];


  @override
  void binds(Injector i) {
     i.addSingleton<HomeController>(HomeController.new);    
  }

   
  @override
  void routes(r) {    
    r.child(Modular.initialRoute, child: (_, ) => const HomePage());
  }

}