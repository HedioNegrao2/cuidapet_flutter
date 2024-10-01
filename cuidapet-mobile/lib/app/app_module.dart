

import 'package:flutter_modular/flutter_modular.dart';
import 'package:gradiente_text/app/core/core_mudule.dart';
import 'package:gradiente_text/app/modules/auth/auth_module.dart';
import 'package:gradiente_text/app/modules/home/home_module.dart';


class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  List<Module> get imports => [
    CoreMudule(),
  ];

  @override
  void routes(r) {
    r.module('/auth', module:  AuthModule());
    r.module('/home', module: HomeModule());
  }
}

