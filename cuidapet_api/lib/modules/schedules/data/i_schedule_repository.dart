import 'package:cuidapet_api/entities/schedule.dart';

abstract class IScheduleRepository {
  Future<void> save(Schedule schedule);
  Future<void> changeStatus(int scheduleId, String status);
  Future<List<Schedule>> findAllSchedulerByUser(int userId);
  Future<List<Schedule>> findAllSchedulerBySupplier(int userId);

}