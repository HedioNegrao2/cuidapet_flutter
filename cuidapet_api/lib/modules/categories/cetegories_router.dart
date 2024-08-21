
import 'package:cuidapet_api/application/routers/i_router.dart';
import 'package:cuidapet_api/modules/categories/controller/categories_controller.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

class CetegoriesRouter implements IRouter {
  @override
  void configure(Router router) {
   final categoriesController = GetIt.I.get<CategoriesController>();
    router.mount('/categories/', categoriesController.router.call);
  }
  
}