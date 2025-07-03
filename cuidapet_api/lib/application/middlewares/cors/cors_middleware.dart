
import 'dart:io';

import 'package:cuidapet_api/application/middlewares/middlewares.dart';
import 'package:shelf/shelf.dart';


class CorsMiddleware extends Middlewares {
  final Map<String, String> headers = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': '${HttpHeaders.contentTypeHeader},$HttpHeaders.authorizationHeader}',
    };
      
  
  @override
  Future<Response> execute(Request request) async {
    
    if(request.method == 'OPTIONS'){    
      return Response(HttpStatus.ok, headers: headers);
    }
    
    final response = await innerHandler(request);
    
    return response.change(headers: headers);

  }
  
} 