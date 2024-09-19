import 'dart:convert';

import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@LazySingleton()
class PushNotificationFacade {
  final ILogger log;

  PushNotificationFacade({
    required this.log,
  });

  Future<void> sendMessage({
    required List<String?> devaices,
    required String title,
    required String body,
    required Map<String, dynamic> pyload,
  }) async {
    try {
      final request = {
        'notification': {
          'body': body,
          'title': title,
        },
        'priority': 'high',
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          'pyload': pyload,
        }
      };
      String? firibaseKey = env['FIREBASE_PUSH_KEY'] ?? env['irebasePushKey'];

      if (firibaseKey == null) {
        log.error('Chave do firebase não configurada');
        return;
      }
      for (var device in devaices) {
        if (device != null) {
          request['to'] = device;
          log.info('Enviando notificação para o dispositivo $device');
          final result = await http.post(
              Uri.parse('https://fcm.googleapis.com/fcm/send'),
              body: jsonEncode(request),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'key=$firibaseKey',
              });
          final resposeData = jsonDecode(result.body);

          if (resposeData['failure'] == 1) {
            log.error(
                'Erro ao enviar notificação para o dispositivo $device erro:${resposeData['results']?[0]}');
          } else {
            log.info(
                'Notificação enviada com sucesso para o dispositivo $device ');
          }
        }
      }
    } catch (e, s) {
      log.error('Erro ao enviar notificação', e, s);
    }
  }
}
