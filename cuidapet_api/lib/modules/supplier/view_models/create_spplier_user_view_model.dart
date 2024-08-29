
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class CreateSpplierUserViewModel extends RequestMapping {
  late String supplierName;
  late String email;
  late String password;
  late int category;
  
  
  CreateSpplierUserViewModel(String dataRequest): super(dataRequest);

  @override


  void map() {
    supplierName = data['supplierName'];
    email = data['email'];
    password = data['password'];
    category = data['category_id'];
  }
  
}