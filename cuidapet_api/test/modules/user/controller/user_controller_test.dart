import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/user/controller/user_controller.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/modules/user/view_modules/user_update_token_device_input_model.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';
import 'mock/mock_user_service.dart';

void main() {

  late IUserService userService;
  late ILogger log;
  late Request  request;
  late UserController userController;

 setUp( () {
  userService = MockUserService();
  log = MockLogger();
  request = MockShelfRequest();
  userController = UserController(userService: userService, log: log);
   // Initialize any necessary resources or mocks here
 });


 group('', () {
   test('Should update divice token', () async {
     //Arrange
     final userId = '123';
     when(() => request.headers).thenReturn({'user':'123'});

    final requestFixture = FixtureReader.getJsonData(
        'modules/user/controller/fixture/update_device_token.json');
    final model = UserUpdateTokenDeviceInputModel(
      userId: int.parse(userId),
      dataRequest: requestFixture
    );
    
    
     // Mock the userService.updateDeviceToken method
     final _ = Future.value(null);
    when(() => request.readAsString()).thenAnswer((_) async => requestFixture); 
    when(() => userService.updateDeviceToken(model)).thenAnswer((_) async => _);
    
     //Act
    final response = await userController.updateDevicetoken(request);
     
     //Assert
    expect(response.statusCode, 200);
    verify(() => request.readAsString()).called(1);
   });
 });
}