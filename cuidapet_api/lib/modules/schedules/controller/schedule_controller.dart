import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/schedules/service/i_schedule_service.dart';
import 'package:cuidapet_api/modules/schedules/view_models/schedule_save_imput_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'schedule_controller.g.dart';

@injectable
class ScheduleController {
  final IScheduleService service;
  final ILogger log;

  ScheduleController({
    required this.service,
    required this.log,
  });

  @Route.post('/')
  Future<Response> scheduleServices(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);
      final imputModel = ScheduleSaveImputModel(
          userId: userId, dataRequest: await request.readAsString());

      service.saveSchedule(imputModel);

      return Response.ok(jsonEncode({}));
    } catch (e, s) {
      log.error('Erro a salvar agendamento', e, s);
      return Response.internalServerError();
    }
  }

  @Route.put('/<scheduleId|[0-9]+>/status/<status>')
  Future<Response> changStauts(
      Request request, String scheduleId, String status) async {
    try {
      await service.changeStatus(int.parse(scheduleId), status);
      return Response.ok(jsonEncode({}));
    } catch (e, s) {
      log.error('Erro ao alterar status do agendamento', e, s);
      return Response.internalServerError();
    }
  }

  @Route.get('/')
  Future<Response> findAllchedulesByUser(Request request) async {
    final userId = int.parse(request.headers['user']!);
    try {      
      final result = await service.findAllSchedulerByUser(userId);

      final response = result
          .map((e) => {
                'id': e.id,
                'schedule_date': e.scheduleDate.toIso8601String(),
                'status': e.status,
                'name': e.name,
                'pat_name': e.patName,
                'supplier': {
                  'id': e.supplier.id,
                  'name': e.supplier.name,
                  'logo': e.supplier.logo
                },
                'services': e.services
                    .map((s) => {
                          'id': s.service.id,
                          'name': s.service.name,
                          'price': s.service.price
                        })
                    .toList()
              })
          .toList();
      return Response.ok(jsonEncode(response));
    } catch (e, s) {
      log.error('Erro ao buscar agendamentos pelo usuario [$userId]', e, s);
      return Response.internalServerError();
    }
  }

 @Route.get('/supplier')
  Future<Response> findAllchedulesBySupplier(Request request) async {
    final userId = int.parse(request.headers['user']!);
    try {      
      final result = await service.findAllSchedulerBySupplier(userId);

      final response = result
          .map((e) => {
                'id': e.id,
                'schedule_date': e.scheduleDate.toIso8601String(),
                'status': e.status,
                'name': e.name,
                'pat_name': e.patName,
                'supplier': {
                  'id': e.supplier.id,
                  'name': e.supplier.name,
                  'logo': e.supplier.logo
                },
                'services': e.services
                    .map((s) => {
                          'id': s.service.id,
                          'name': s.service.name,
                          'price': s.service.price
                        })
                    .toList()
              })
          .toList();
      return Response.ok(jsonEncode(response));
    } catch (e, s) {
      log.error('Erro ao buscar agendamentos pelo fornecedor [$userId]', e, s);
      return Response.internalServerError();
    }
  }



  Router get router => _$ScheduleControllerRouter(this);
}
