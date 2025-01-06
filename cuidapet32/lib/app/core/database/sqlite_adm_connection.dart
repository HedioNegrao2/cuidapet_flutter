
import 'package:cuidapet32/app/core/database/sqlite_connection_factory.dart';
import 'package:flutter/material.dart';

class SqliteAdmConnection  with WidgetsBindingObserver {
 
 @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    var connection = SqliteConnectionFactory();

   switch(state){
    case AppLifecycleState.hidden: 
    case AppLifecycleState.resumed:
      break;
    case AppLifecycleState.inactive:      
    case AppLifecycleState.paused:      
    case AppLifecycleState.detached:
      connection.closeConnection;
      break;
  }

 
    super.didChangeAppLifecycleState(state);
  }

  
}