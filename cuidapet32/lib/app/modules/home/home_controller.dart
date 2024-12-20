import 'package:cuidapet32/app/core/live_cycle/controller_live_cycle.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store, ControllerLiveCycle {
 

  @override
  Future<void> onReady() async{
    await _hasResgistredAddress();
  }

  Future<void> _hasResgistredAddress() async {  
    await Modular.to.pushNamed('/address/');
  }

  

}