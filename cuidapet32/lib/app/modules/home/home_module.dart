import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/home/home_page.dart';


class HomeModule extends Module {

   
  @override
  void routes(r) {
    
    r.child(Modular.initialRoute, child: (_, ) => const HomePage());

  }

}