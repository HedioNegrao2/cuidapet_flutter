

import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:cuidapet32/app/modules/auth/auth_module.dart';
import 'package:cuidapet32/app/modules/home/home_module.dart';


class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  List<Module> get imports => [
    CoreMudule(),
  ];

  @override
  void routes(r) {
    r.module('/auth/', module:  AuthModule());
    r.module('/home/', module: HomeModule());
  }
}

