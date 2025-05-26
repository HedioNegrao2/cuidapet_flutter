

import 'package:cuidapet32/app/modules/address/address_module.dart';
import 'package:cuidapet32/app/modules/scheduler/schedule_module.dart';
import 'package:cuidapet32/app/modules/supplier/supplier_mudule.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:cuidapet32/app/modules/core/core_mudule.dart';
import 'package:cuidapet32/app/modules/auth/auth_module.dart';
import 'package:cuidapet32/app/modules/home/home_module.dart';


class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  List<Module> get imports => [
    CoreMudule(),    
  ];

  @override
  void routes(r) {
    r.module('/auth/', module:  AuthModule());
    r.module('/home/', module: HomeModule());
    r.module('/address', module: AddressModule());
    r.module('/supplier', module: SupplierMudule());
    r.module('/schedules', module: ScheduleModule());
  }
}

