
import 'package:cuidapet32/app/models/supplier_services_model.dart';

class ScheduleViewModel {
  final int supplierId;
  final List<SupplierServicesModel> services;
  ScheduleViewModel({
    required this.supplierId,
    required this.services,
  });
  
}
