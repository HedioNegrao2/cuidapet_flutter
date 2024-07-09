import 'package:dotenv/dotenv.dart' show load;

class ApplicationConfig {
  Future<void> loadConfigApplicaton() async {
    await _loadEnv();
  }

  Future<void> _loadEnv() async => load();
}
