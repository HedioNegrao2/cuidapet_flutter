
import 'package:cuidapet_api/application/routers/i_router.dart';
import 'package:cuidapet_api/modules/categories/cetegories_router.dart';
import 'package:cuidapet_api/modules/supplier/supplier_router.dart';
import 'package:cuidapet_api/modules/user/user_router.dart';
import 'package:shelf_router/shelf_router.dart';


class RouterConfigure {
  final Router _router;

  final List<IRouter> _routers = [ 
    UserRouter(),
    CetegoriesRouter(),
    SupplierRouter(),
  ];
  
  RouterConfigure(this._router);

  void configure() => _routers.forEach((r) => r.configure(_router));

}