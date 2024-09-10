
import 'package:cuidapet_api/entities/schedule_supplier_service.dart';
import 'package:cuidapet_api/entities/supplier.dart';


class Schedule {
  final int? id;
  final DateTime scheduleDate;
  final String status;
  final String name;
  final String patName;
  final int userId;
  final Supplier supplier;
  final List<ScheduleSupplierService> services;

  Schedule({
    this.id,
    required this.scheduleDate,
    required this.status,
    required this.name,
    required this.patName,
    required this.userId,
    required this.supplier,
    required this.services,
  });

}
