import 'package:bizsignal_app/data/models/uesr_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bizsignal_app/controller/custom/app_member_controller.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel();
  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<UserModel> getUser(fcm) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString('userId') ?? '';
    if (userId != '') {
      // FCM 토큰이 제공된 경우에만 저장
      if (fcm != null && fcm.isNotEmpty) {
        prefs.setString('fcmToken', fcm);
      }

      Map<dynamic, dynamic> option = {'APP_MEMBER_IDENTIFICATION_CODE': userId};
      _user = await AppMemberController().getProfile(option);

      //로그아웃 시 모든 데이터 초기화
    } else {
      _user = UserModel();
    }

    // UI 업데이트를 위해 notifyListeners 호출
    notifyListeners();
    return _user;
  }
}
