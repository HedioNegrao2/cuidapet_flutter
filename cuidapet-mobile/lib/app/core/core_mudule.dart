import 'package:flutter_modular/flutter_modular.dart';
import 'package:gradiente_text/app/core/auth/auth_store.dart';

class CoreMudule extends Module {

   @override
   void exportedBinds(i){
    i.addLazySingleton(AuthStore.new);
    
   }
   

}