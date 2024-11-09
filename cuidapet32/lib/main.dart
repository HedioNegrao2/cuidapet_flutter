import 'package:cuidapet32/app/app_widget.dart';
import 'package:cuidapet32/app/core/ui/application_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app/app_module.dart';

void main() async {
  await ApplicationConfig().configureApp();

  runApp(ModularApp( // ModularApp is a widget that initializes the Modular system
    module: AppModule(), 
    child: const AppWidget() // AppModule is the root module of the application
  ));
}
