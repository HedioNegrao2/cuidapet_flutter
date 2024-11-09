import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/auth/login/login_page.dart';

class LoginModule extends Module {

   
  @override
  void routes(r) {
    
    r.child(Modular.initialRoute, child: (_, ) => const LoginPage());

  }

}