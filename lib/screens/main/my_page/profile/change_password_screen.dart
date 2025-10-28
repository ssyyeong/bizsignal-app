import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordValid = false;
  bool _isPasswordMatch = false;
  String _newPasswordError = '';
  String _confirmPasswordError = '';

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_validateNewPassword);
    _confirmPasswordController.addListener(_validatePasswordMatch);
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateNewPassword() {
    setState(() {
      String password = _newPasswordController.text;
      if (password.isEmpty) {
        _isNewPasswordValid = false;
        _newPasswordError = '';
      } else if (password.length < 8 ||
          !RegExp(
            r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).*$',
          ).hasMatch(password)) {
        _isNewPasswordValid = false;
        _newPasswordError = '비밀번호 형식이 올바르지 않습니다.';
      } else {
        _isNewPasswordValid = true;
        _newPasswordError = '';
      }
      _validatePasswordMatch();
    });
  }

  void _validatePasswordMatch() {
    setState(() {
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmPasswordController.text;

      if (confirmPassword.isEmpty) {
        _isPasswordMatch = false;
        _confirmPasswordError = '';
      } else if (newPassword != confirmPassword) {
        _isPasswordMatch = false;
        _confirmPasswordError = '비밀번호가 일치 하지 않습니다.';
      } else {
        _isPasswordMatch = true;
        _confirmPasswordError = '';
      }
    });
  }

  void _changePassword() async {
    if (_isNewPasswordValid && _isPasswordMatch) {
      await ControllerBase(modelName: 'AppMember', modelId: 'app_member')
          .update({
            'APP_MEMBER_IDENTIFICATION_CODE':
                context.read<UserProvider>().user.id,
            'PASSWORD': _newPasswordController.text,
          })
          .then((result) {
            ToastWidget.showInfo(context, message: '비밀번호가 변경되었습니다.');
            Navigator.pop(context);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '비밀번호 변경', isBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 안내 텍스트
              const Text(
                '신규 비밀번호를 입력해주세요.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray700,
                ),
              ),
              const SizedBox(height: 25),

              // 비밀번호 입력 필드
              Row(
                children: [
                  const Text(
                    '비밀번호',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/images/icon/required.svg',
                    width: 12,
                    height: 12,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '숫자/영문/기호 포함 8자 이상로 입력해주세요.',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              if (_newPasswordError.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _newPasswordError,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.alertWarning,
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // 비밀번호 확인 입력 필드
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호를 한번 더 입력해주세요.',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.gray200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
              if (_confirmPasswordError.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _confirmPasswordError,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.alertWarning,
                  ),
                ),
              ],

              const Spacer(),

              // 완료 버튼
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // 비밀번호 확인 로직
                    if (_newPasswordController.text.isNotEmpty) {
                      _changePassword();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _newPasswordController.text.isNotEmpty
                            ? AppColors.black
                            : const Color(0xFF979797),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '완료',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
