import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:cuidapet32/app/repositories/user/user_repository.dart';
import 'package:cuidapet32/app/repositories/user/user_repository_impl.dart';
import 'package:cuidapet32/app/services/user/user_service.dart';
import 'package:cuidapet32/app/services/user/user_service_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/auth/home/auth_home_page.dart';
import 'package:cuidapet32/app/modules/auth/login/login_module.dart';
import 'package:cuidapet32/app/modules/auth/register/register_module.dart';

class AuthModule extends Module {
    @override
    List<Module> get imports => [
    CoreMudule(),  
  ];

  
  @override
   void exportedBinds(i) {  
    i.addSingleton<UserRepository>(UserRepositoryImpl.new);
    i.addSingleton<UserService>(UserServiceImpl.new);
  }

  
  @override
  void routes(r) {
    r.child('/', child: (context) =>  AuthHomePage(authStore: Modular.get(),));
    r.module('/login/', module: LoginModule());
    r.module('/register/', module: RegisterModule());
  }
}
