
import 'dart:convert';
import 'package:cuidapet_api/application/helpers/jwt_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/application/middlewares/middlewares.dart';
import 'package:cuidapet_api/application/middlewares/security/security_skip_url.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/src/request.dart';
import 'package:shelf/src/response.dart';

class SecuriyMeddleware extends Middlewares {
  
  final ILogger log;
  final skpUrl = <SecuritySkipUrl>[];

  SecuriyMeddleware(this.log);
  
  @override
  Future<Response> execute(Request request) async {
  
    if (skpUrl.contains(
        SecuritySkipUrl(url: '/${request.url.path}', method: request.method))) {
      return innerHandler(request);
    }

    final authHeader = request.headers['Authorization'];

    if (authHeader == null || authHeader.isEmpty) {     
      return Response.forbidden(jsonEncode({}));
    }

    final authHeaderContent = authHeader.split(' ');

    if (authHeaderContent[0] != 'Bearer') {
      return Response.forbidden(jsonEncode({}));
    }

    try {

      final authorizationTonken = authHeaderContent[1];   
      final claims = JwtHelper.getClaims(authorizationTonken);
 
      if(request.url.path != 'auth/refresh'){        
          claims.validate;      
      }

      final claimsMap = claims.toJson();
      final userId = claimsMap['sub'];
      final supplierId = claimsMap['supplier'];

      if(userId == null) {
        throw JwtException.invalidToken;
      }

      final securityHeaders = {'user': userId, 'access_token': authorizationTonken, 'supplier': supplierId};
      return innerHandler(request.change(headers: securityHeaders ));

    
    } on JwtException catch  (e) {
      log.error('Erro ao validar token', e);
      return Response.forbidden(jsonEncode({}));
    } catch  (e, s) {
      log.error('Internal Server Error', e,s);
    return Response.forbidden(jsonEncode({}));

  }
  
}
}