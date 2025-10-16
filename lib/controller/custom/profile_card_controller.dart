import 'dart:convert';
import 'dart:io';

import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/settings/server.dart';
import 'package:http/http.dart' as http;

class ProfileCardController {
  //api 경로
  String? apiUrl;
  //root 경로
  String rootRoute = '/api';

  String role = 'user';
  // 모델명
  String modelName = 'ProfileCard';
  // 모델 id
  String modelId = 'profile_card';

  String? mergedPath;

  ProfileCardController() {
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

  Future<Map<String, dynamic>> profileCardUpload(Map option, File img) async {
    if (img.path != '') {
      var request = http.MultipartRequest(
        'POST',
        _buildUri('$rootRoute/common/file/upload_image'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          img.readAsBytesSync(),
          filename: img.path.split("/").last,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        option['PROFILE_IMAGE'] = json.encode(responseMap['result']);
      }
    }

    return await ControllerBase(
      modelName: 'ProfileCard',
      modelId: 'profile_card',
    ).create(option);
  }

  Future<Map<String, dynamic>> profileCardUpdate(Map option, File img) async {
    if (img.path != '') {
      var request = http.MultipartRequest(
        'POST',
        _buildUri('$rootRoute/common/file/upload_image'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          img.readAsBytesSync(),
          filename: img.path.split("/").last,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        option['PROFILE_IMAGE'] = json.encode(responseMap['result']);
      }
    }
    option['PROFILE_CARD_IDENTIFICATION_CODE'] =
        option['PROFILE_CARD_IDENTIFICATION_CODE'];

    return await ControllerBase(
      modelName: 'ProfileCard',
      modelId: 'profile_card',
    ).update(option);
  }

  Future<Map<String, dynamic>> filteringProfileCard(
    Map<dynamic, dynamic> option,
  ) async {
    Uri url = _buildUri('$rootRoute/$role/$modelId/filtering');

    final response = await http.post(url, body: option);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }
}
