import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  Environments._();

  static String? param(String paramname) {
    if (kReleaseMode) {
      return FirebaseRemoteConfig.instance.getString(paramname);
    } else {
      return dotenv.env[paramname];
    }
  }

  static Future<void> loadEnvs() async {
    if (kReleaseMode) {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      )
      );
      await remoteConfig.fetchAndActivate();

    } else {
      await dotenv.load(fileName: '.env');
    }
  }
}
