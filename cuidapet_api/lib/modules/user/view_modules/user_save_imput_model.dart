import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserSaveImputModel extends RequestMapping {
  late String email;
  late String password;
  int? supplierId;

  UserSaveImputModel(String dataRequest) : super(dataRequest);

  @override
  void map() {
    email = data['email'];
    password = data['password'];
  }
}
