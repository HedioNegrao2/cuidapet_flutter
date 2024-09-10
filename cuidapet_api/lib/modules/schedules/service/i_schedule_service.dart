
import 'package:cuidapet_api/entities/schedule.dart';
import 'package:cuidapet_api/modules/schedules/view_models/schedule_save_imput_model.dart';

abstract class IScheduleService {
  Future<void> saveSchedule(ScheduleSaveImputModel model);
  Future<void> changeStatus(int scheduleId, String status);
  Future<List<Schedule>> findAllSchedulerByUser(int userId);
  Future<List<Schedule>> findAllSchedulerBySupplier(int userId);
}