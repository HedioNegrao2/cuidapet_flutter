import 'package:cuidapet32/app/core/helpers/environments.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class ApplicationConfig {
  
  Future<void> configureApp() async {
    WidgetsFlutterBinding.ensureInitialized();
   await _firibaseConfig();
   await loadEnvs();
  }
  
  _firibaseConfig() async  {
      await Firebase.initializeApp();    
  }

  Future<void> loadEnvs() => Environments.loadEnvs();
} 