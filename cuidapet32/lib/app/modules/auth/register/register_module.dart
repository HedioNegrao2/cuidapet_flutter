import 'package:cuidapet32/app/modules/auth/auth_module.dart';
import 'package:cuidapet32/app/modules/auth/register/register_controller.dart';
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/auth/register/register_page.dart';

class RegisterModule extends Module {

    @override
  List<Module> get imports => [
    AuthModule(),
    CoreMudule(),
  ];


    @override
  void binds(i) {
    i.addLazySingleton<RegisterController>(() => RegisterController(userServcie: i(), log: i()));
    
  }

   
  @override
  void routes(r) {
    
    r.child(Modular.initialRoute, child: (_, ) => const RegisterPage());

  }

}