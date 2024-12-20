
import 'package:cuidapet32/app/core/live_cycle/controller_live_cycle.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract class PageLiveCycleState<C extends ControllerLiveCycle, P extends StatefulWidget> 
extends State<P> {  
  final controller = Modular.get<C>();

  Map<String, dynamic>? get params => null;

  @override
  void initState() {    
    super.initState();
    controller.onInit(params);
    WidgetsBinding.instance.addPostFrameCallback((_) =>  controller.onReady());
    
  }

}