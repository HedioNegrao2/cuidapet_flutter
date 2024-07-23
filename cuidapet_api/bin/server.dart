import 'dart:io';

import 'package:cuidapet_api/application/config/application_config.dart';
import 'package:cuidapet_api/application/middlewares/cors/cors_middleware.dart';
import 'package:cuidapet_api/application/middlewares/defalutContentType/defalt_content_type.dart';
import 'package:cuidapet_api/application/middlewares/security/security_meddleware.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';




void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  
  final ip = InternetAddress.anyIPv4;
  
  // Configure routes.
  final router = Router();  
  final appConfig = ApplicationConfig();
  await appConfig.loadConfigApplicaton(router);

  final getIt =  GetIt.I;

  // Configure a pipeline that logs requests.
  final handler = const Pipeline()
    .addMiddleware(CorsMiddleware().handler)
    .addMiddleware(DefaltContentType().handler)
    .addMiddleware(SecurityMeddleware(getIt.get()).handler)
    .addMiddleware(logRequests())
    .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
