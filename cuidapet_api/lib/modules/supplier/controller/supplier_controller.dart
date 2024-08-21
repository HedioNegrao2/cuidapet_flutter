import 'dart:async';
import 'dart:convert';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/supplier/service/i_supplier_service.dart';
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
        body: jsonEncode({'message': 'Erro ao buscar fornecedores próximos'}));
    }
  }

  Router get router => _$SupplierControllerRouter(this);
}
