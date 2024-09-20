

import 'package:flutter_modular/flutter_modular.dart';
import 'package:gradiente_text/app/modules/auth/auth_module.dart';


class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.module('/auth', module:  AuthModule());
  }
}

