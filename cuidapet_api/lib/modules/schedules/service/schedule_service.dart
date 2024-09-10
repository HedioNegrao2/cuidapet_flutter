
import 'package:cuidapet_api/entities/schedule.dart';
import 'package:cuidapet_api/entities/schedule_supplier_service.dart';
import 'package:cuidapet_api/entities/supplier.dart';
import 'package:cuidapet_api/entities/supplier_service.dart';
import 'package:cuidapet_api/modules/schedules/data/i_schedule_repository.dart';
import 'package:cuidapet_api/modules/schedules/service/i_schedule_service.dart';
import 'package:cuidapet_api/modules/schedules/view_models/schedule_save_imput_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: IScheduleService)
class ScheduleService implements IScheduleService {

  final IScheduleRepository repository;

  ScheduleService({
    required this.repository,
  });


  @override
  Future<void> saveSchedule(ScheduleSaveImputModel model) async {

  final schedule =  Schedule(
      scheduleDate: model.scheduleDate,
      name: model.name,
      patName: model.patName,
      userId: model.userId,
      supplier: Supplier(id:  model.supplierId),
      status: 'P',
      services: model.services.map((e) => ScheduleSupplierService(service: 
        SupplierService(id: e),
        )).toList()      
    );
  
    await repository.save(schedule);}
    
  @override
  Future<void> changeStatus(int scheduleId, String status) => repository.changeStatus(scheduleId, status);
      
  @override
  Future<List<Schedule>> findAllSchedulerByUser(int userId) => repository.findAllSchedulerByUser(userId);
  
  @override
  Future<List<Schedule>> findAllSchedulerBySupplier(int userId) => repository.findAllSchedulerBySupplier(userId);
    
  
}
