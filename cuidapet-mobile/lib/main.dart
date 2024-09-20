import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:gradiente_text/app/app_widget.dart';

import 'app/app_module.dart';

void main() {
  runApp(ModularApp( // ModularApp is a widget that initializes the Modular system
    module: AppModule(), 
    child: const AppWidget() // AppModule is the root module of the application
  ));
}
