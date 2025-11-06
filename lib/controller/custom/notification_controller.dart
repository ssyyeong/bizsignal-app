import 'dart:convert';

import 'package:bizsignal_app/data/models/uesr_model.dart';
import 'package:bizsignal_app/settings/server.dart';
import 'package:http/http.dart' as http;

class NotificationController {
  //api 경로
  String? apiUrl;
  //root 경로
  String rootRoute = '/api';

  String role = 'common';
  // 모델명
  String modelName = 'Notification';
  // 모델 id
  String modelId = 'notification';

  String? mergedPath;

  NotificationController() {
    apiUrl = serverSettings.config!['apiUrl']; // config에서 apiUrl에 접근합니다.
    mergedPath =
        '$apiUrl$rootRoute/$role/$modelId'; // apiUrl과 modelName을 결합합니다.
    modelName = modelName;
  }

  // 환경에 따라 http/https 선택
  Uri _buildUri(String path, [Map<String, String>? queryParameters]) {
    final isDevelopment =
        serverSettings.config!['apiUrl']!.contains('10.0.2.2') ||
        serverSettings.config!['apiUrl']!.contains('localhost');

    if (isDevelopment) {
      return Uri.http(apiUrl!, path, queryParameters);
    } else {
      return Uri.https(apiUrl!, path, queryParameters);
    }
  }

  //알림 모두 읽음 처리
  Future<bool> markAllAsRead(Map option) async {
    Uri url = _buildUri('$rootRoute/$role/$modelId/set_all_read');

    final response = await http.put(
      url,
      body: option.map((key, value) => MapEntry(key, value.toString())),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap['result'];
    }
    throw Exception('Failed to load data');
  }
}
