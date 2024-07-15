
import 'package:cuidapet_api/application/routers/i_router.dart';
import 'package:cuidapet_api/modules/teste/teste_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class TesteRouter implements IRouter {
  @override
  void configure(Router router) {
    router.mount('/hello/', TesteController().router);  
  }
  
}