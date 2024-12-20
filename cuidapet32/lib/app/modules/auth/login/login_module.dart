import 'package:cuidapet32/app/modules/auth/auth_module.dart';
import 'package:cuidapet32/app/modules/auth/login/widgets/login_controller.dart';
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/auth/login/login_page.dart';

class LoginModule extends Module {

  

  @override
  List<Module> get imports => [
    CoreMudule(),  
    AuthModule(),
  ];
  
  @override
  void binds(i) {
    i.addLazySingleton<LoginController>(() => LoginController(userService: i(), log: i()));
    
    
  }

   
  @override
  void routes(r) {
    
    r.child(Modular.initialRoute, child: (_, ) => const LoginPage());

  }

}