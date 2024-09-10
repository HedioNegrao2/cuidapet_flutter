// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ScheduleControllerRouter(ScheduleController service) {
  final router = Router();
  router.add(
    'POST',
    r'/',
    service.scheduleServices,
  );
  router.add(
    'PUT',
    r'/<scheduleId|[0-9]+>/status/<status>',
    service.changStauts,
  );
  router.add(
    'GET',
    r'/',
    service.findAllchedulesByUser,
  );
  router.add(
    'GET',
    r'/supplier',
    service.findAllchedulesBySupplier,
  );
  return router;
}
