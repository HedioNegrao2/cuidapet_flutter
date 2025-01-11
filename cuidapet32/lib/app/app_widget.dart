import 'package:asuka/asuka.dart';
import 'package:cuidapet32/app/core/database/sqlite_adm_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cuidapet32/app/core/ui/ui_config.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final sqlliteAdmConnection = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(sqlliteAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(sqlliteAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute('/auth');
    Modular.setObservers([Asuka.asukaHeroController]);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, __) => MaterialApp.router(
        title: UiConfig.title,
        debugShowCheckedModeBanner: false,
        builder: Asuka.builder,
        theme: UiConfig.thema,
        routerConfig: Modular.routerConfig,
      ),
    ); //added by extension
  }
}
