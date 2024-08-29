import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/supplier/service/i_supplier_service.dart';
import 'package:cuidapet_api/modules/supplier/view_models/create_spplier_user_view_model.dart';
import 'package:cuidapet_api/modules/supplier/view_models/supplier_update_imput_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'supplier_controller.g.dart';

@Injectable()
class SupplierController {
  final ISupplierService service;
  final ILogger log;

  SupplierController({
    required this.service,
    required this.log,
  });

  @Route.get('/')
  Future<Response> findNearByMe(Request request) async {
    try {
      final lat = double.tryParse(request.url.queryParameters['lat'] ?? '');
      final lng = double.tryParse(request.url.queryParameters['lng'] ?? '');

      if (lat == null || lng == null) {
        return Response(400,
            body: jsonEncode(
                {'message': 'Latitude e longitude são obrigatórios'}));
      }

      final suppliers = await service.findNearByMe(lat, lng);
      final result = suppliers
          .map((s) => {
                'name': s.name,
                'logo': s.logo,
                'distance': s.distance,
                'categoryId': s.categoryId,
                'id': s.id,
              })
          .toList();

      return Response.ok(jsonEncode(result));
    } catch (e, s) {
      log.error('Erro ao buscar fornecedores próximos', e, s);
      return Response.internalServerError(
          body:
              jsonEncode({'message': 'Erro ao buscar fornecedores próximos'}));
    }
  }

  @Route.get('/<id|[0-9]+>')
  Future<Response> findById(Request request, String id) async {
    final supplier = await service.findById(int.parse(id));

    if (supplier == null) {
      return Response.notFound(
          jsonEncode({'message': 'Fornecedor não encontrado'}));
    }

    return Response.ok(_supplierMapper(supplier));
  }

  String _supplierMapper(supplier) {
    return jsonEncode({
      'id': supplier.id,
      'name': supplier.name,
      'logo': supplier.logo,
      'address': supplier.address,
      'phone': supplier.phone,
      'lat': supplier.lat,
      'lng': supplier.lng,
      'category': {
        'id': supplier.category?.id,
        'name': supplier.category?.name,
        'type': supplier.category?.type
      }
    });
  }

  @Route.get('/<supplierId|[0-9]+>/services')
  Future<Response> findServicesBySupplierId(
      Request request, String supplierId) async {
    try {
      final supplierServices =
          await service.findServiceBySupplierId(int.parse(supplierId));

      final result = supplierServices
          .map((s) => {
                'id': s.id,
                'name': s.name,
                'supplier_id': s.supplierId,
                'price': s.price
              })
          .toList();
      return Response.ok(jsonEncode(result));
    } catch (e, s) {
      log.error('Erro ao buscar serviços do fornecedor', e, s);
      return Response.internalServerError(
          body:
              jsonEncode({'message': 'Erro ao buscar serviços do fornecedor'}));
    }
  }

  @Route.get('/user')
  Future<Response> chckUserExists(Request request) async {
    final email = request.url.queryParameters['email'];
    if (email == null) {
      return Response(400,
          body: jsonEncode({'message': 'Email é obrigatório'}));
    }

    final isEmailExists = await service.checkUserEmailExists(email);
    return isEmailExists ? Response(200) : Response(204);
  }

  @Route.post('/user')
  Future<Response> createNewUser(Request request) async {
    try {
      final model = CreateSpplierUserViewModel(await request.readAsString());

      await service.createUserSupplier(model);
      return Response.ok(jsonEncode(''));
    } on Exception catch (e, s) {
      log.error('Erro ao criar usuário fornecedor', e, s);
      return Response.internalServerError(
          body: jsonEncode({'message': 'Erro ao criar usuário fornecedor'}));
    }
  }
@Route.put('/')
Future<Response> update (Request request) async{
  try {
  final supplier = int.parse(request.headers['supplier'] ?? '0');
  
  if(supplier == 0){
    return Response(400, body: jsonEncode({'message': 'Fornecedor é obrigatório'}));
  }
  
  final model = SupplierUpdateImputModel(supplierId: supplier, dataRequest:  await   request.readAsString());
   
  final supplierResponse = await service.update(model); 
  
   return Response.ok(_supplierMapper(supplierResponse));
} catch (e,s) {
  log.error('Erro ao atualizar fornecedor', e, s);
  return Response.internalServerError();
}
}


  Router get router => _$SupplierControllerRouter(this);
}
