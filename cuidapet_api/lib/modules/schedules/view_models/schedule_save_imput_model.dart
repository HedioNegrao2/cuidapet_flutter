
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class ScheduleSaveImputModel extends RequestMapping{
int userId;
late DateTime scheduleDate;
late String name;
late String patName;
late int supplierId;
late List<int> services;

  ScheduleSaveImputModel({required this.userId, required String dataRequest}) : super(dataRequest);



  @override
  void map() {
    scheduleDate = DateTime.parse(data['schedule_date']);
    supplierId = data['supplier_id'];
    services = List.castFrom<dynamic, int>(data['services']); 
    name = data['name'];
    patName = data['pat_name'];
  }

 


}