import 'dart:convert';

import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/controller/auth_controller.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
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
  late AuthController authController;
  late Request request;

  setUp(() {
    userService = MockUserService();
    log = MockLogger();
    authController = AuthController(userService: userService, log: log);
    request =  MockShelfRequest();
    load();

   // registerFallbackValue(User());
  });

group('Group teste login', () {

  test('Should login with success', () async {
  //Arrange
  final loginRequestFixture = FixtureReader.getJsonData('modules/user/controller/fixture/login_with_email_password_request.json');
  final loginRequstData = jsonDecode(loginRequestFixture);
  final login = loginRequstData['login'];
  final password = loginRequstData['password'];
  final supplierUser = loginRequstData['supplier_user'];

  

  when(() => request.readAsString())
      .thenAnswer((_) async => loginRequestFixture);

  when(() => userService.loginWithEmailPassword(login, password, supplierUser)
          )
      .thenAnswer((_) async => User(
        id: 1,
        email: login,
      ));
  //Act
    final response = await authController.login(request);
  //Assert
  final responseData =  jsonDecode(await response.readAsString());
  expect(response.statusCode, 200);
  expect(responseData['access_token'], isNotEmpty);
  verify(() => userService.loginWithEmailPassword(login, password, supplierUser)).called(1);
  verifyNever(() => userService.loginWithSocial(any(), any(), any(), any()));
  
  });


  test('Should retun RequestValidationException on login', () async {
    final loginRequestFixture = FixtureReader.getJsonData(
      'modules/user/controller/fixture/login_with_email_password_request_validatio_erro.json');
  
  //Arrange
  when(() => request.readAsString())
      .thenAnswer((_) async => loginRequestFixture);

 
  //Act
    final response = await authController.login(request);
  //Assert
  final responseData =  jsonDecode(await response.readAsString());
  expect(response.statusCode, 400);
expect(responseData['password'], 'required');
  verifyNever(() => userService.loginWithEmailPassword(any(), any(), any() ));
  verifyNever(() => userService.loginWithSocial(any(), any(), any(), any()));
    
  });

  test('Should return UserNotFoundException on login', () async {
  //Arrange
  final loginRequestFixture = FixtureReader.getJsonData('modules/user/controller/fixture/login_with_email_password_request.json');
  final loginRequstData = jsonDecode(loginRequestFixture);
  final login = loginRequstData['login'];
  final password = loginRequstData['password'];
  final supplierUser = loginRequstData['supplier_user'];

  

  when(() => request.readAsString())
      .thenAnswer((_) async => loginRequestFixture);

  when(() => userService.loginWithEmailPassword(login, password, supplierUser)
          )
      .thenThrow(UserNotfoundException(message: 'Usuario não encontrado'));
  //Act
    final response = await authController.login(request);
  //Assert
  
  expect(response.statusCode, 403);
  verify(() => userService.loginWithEmailPassword(login, password, supplierUser)).called(1);
  verifyNever(() => userService.loginWithSocial(any(), any(), any(), any()));
  
  });



});

}