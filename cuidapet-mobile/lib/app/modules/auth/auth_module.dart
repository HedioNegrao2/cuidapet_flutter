import 'package:flutter_modular/flutter_modular.dart';
import 'package:gradiente_text/app/modules/auth/home/auth_home_page.dart';
import 'package:gradiente_text/app/modules/auth/login/login_module.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) =>  AuthHomePage(authStore: Modular.get(),));
    r.module('/login', module: LoginModule());
  }
}
