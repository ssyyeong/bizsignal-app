import 'dart:convert';

import 'package:bizsignal_app/data/models/uesr_model.dart';
import 'package:bizsignal_app/settings/server.dart';
import 'package:http/http.dart' as http;

class AppMemberController {
  //api 경로
  String? apiUrl;
  //root 경로
  String rootRoute = '/api';

  String role = 'user';
  // 모델명
  String modelName = 'AppMember';
  // 모델 id
  String modelId = 'app_member';

  String? mergedPath;

  AppMemberController() {
    apiUrl = serverSettings.config!['apiUrl']; // config에서 apiUrl에 접근합니다.
    mergedPath =
        '$apiUrl$rootRoute/$role/$modelId'; // apiUrl과 modelName을 결합합니다.
    modelName = modelName;
  }

  ///구글 로그인
  Future<Map<String, dynamic>> googleSignIn(Map option) async {
    var url = Uri.https('$apiUrl', '$rootRoute/$role/$modelId/google_login');

    final response = await http.post(url, body: option);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }

  ///애플 로그인
  Future<Map<String, dynamic>> appleSignIn(Map option) async {
    final response = await http.post(
      Uri.https('$apiUrl', '$rootRoute/$role/$modelId/apple_login'),
      body: option,
    );
    // Uri url =
    //     Uri.http('localhost:4021', '$rootRoute/$role/$modelId/apple_login');
    // final response = await http.post(url, body: option);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }

  ///FCM 토큰 업데이트
  Future<bool> updateFcmToken(Map option) async {
    Uri url = Uri.https(
      '$apiUrl',
      '$rootRoute/$role/$modelId/update_fcm_token',
    );

    final response = await http.put(
      url,
      body: option.map((key, value) => MapEntry(key, value.toString())),
    );

    if (response.statusCode == 200) return true;
    return false;
  }

  ///기존 회원 아이디 체크
  Future<bool> doubleCheckUserName(Map option) async {
    Uri url = Uri.http(
      '10.0.2.2:4021',
      '$rootRoute/$role/$modelId/double_check_username',
      option.map((key, value) => MapEntry(key, value.toString())),
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap['result'];
    }
    throw Exception('Failed to load data');
  }

  ///회원가입
  Future<Map<String, dynamic>> signUp(Map option) async {
    Uri url = Uri.http(
      '10.0.2.2:4021',
      '$rootRoute/$role/$modelId/sign_up/local',
    );

    final response = await http.post(url, body: option);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap['result'];
    }
    throw Exception('Failed to load data');
  }

  ///로그인
  Future<Map<String, dynamic>> signIn(Map option) async {
    // Uri url = Uri.https('$apiUrl', '$rootRoute/$role/$modelId/sign_in/local');

    Uri url = Uri.http(
      '10.0.2.2:4021',
      '$rootRoute/$role/$modelId/sign_in/local',
    );

    final response = await http.post(url, body: option);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      return responseMap;
    }
    throw Exception('Failed to load data');
  }

  //회원정보 불러오기 option: {JWT: ''}
  Future<UserModel> getProfile(Map<dynamic, dynamic> option) async {
    var wrappedFindOption = {"JWT_PARSED_DATA": jsonEncode(option)};

    Uri url = Uri.http(
      '10.0.2.2:4021',
      '$rootRoute/$role/$modelId/profile',
      wrappedFindOption,
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      var userData = responseMap["result"];
      UserModel user = UserModel.fromJson(userData);
      return user;
    }
    throw Exception('Failed to load data');
  }
}
