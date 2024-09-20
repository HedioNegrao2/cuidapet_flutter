import 'package:flutter_modular/flutter_modular.dart';
import 'package:gradiente_text/app/modules/auth/home/auth_home_page.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child('/', child: (context) => const AuthHomePage());
  }
}
