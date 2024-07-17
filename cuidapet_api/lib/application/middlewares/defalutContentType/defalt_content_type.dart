
import 'package:cuidapet_api/application/middlewares/middlewares.dart';
import 'package:shelf/shelf.dart';

class DefaltContentType extends Middlewares {
  
  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);
    
    return response.change(headers: {'Content-Type': 'application/json;charset=utf-8'});
  }
  
}