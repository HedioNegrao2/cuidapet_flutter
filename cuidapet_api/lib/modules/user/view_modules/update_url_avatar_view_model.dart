
import 'package:cuidapet_api/application/helpers/request_mapping.dart';


class UpdateUrlAvatarViewModel extends RequestMapping {
  int userId; 
  late String urlAvatar;

  
  UpdateUrlAvatarViewModel({required this.userId, required String dataReqest}) : super(dataReqest);  
  
  @override
  void map() {
    urlAvatar = data['url_avatar'];   
  }
 
  
}