import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';

class TermsAgreementBottomSheet extends StatefulWidget {
  final VoidCallback? onAgreeAll;
  final VoidCallback? onClose;

  const TermsAgreementBottomSheet({super.key, this.onAgreeAll, this.onClose});

  @override
  State<TermsAgreementBottomSheet> createState() =>
      _TermsAgreementBottomSheetState();
}

class _TermsAgreementBottomSheetState extends State<TermsAgreementBottomSheet> {
  bool _serviceTermsAgreed = false;
  bool _privacyPolicyAgreed = false;
  bool _locationServiceAgreed = false;
  bool _marketingAgreed = false;

  bool get allAgreed =>
      _serviceTermsAgreed && _privacyPolicyAgreed && _locationServiceAgreed;

  void _toggleServiceTerms() {
    setState(() {
      _serviceTermsAgreed = !_serviceTermsAgreed;
    });
  }

  void _togglePrivacyPolicy() {
    setState(() {
      _privacyPolicyAgreed = !_privacyPolicyAgreed;
    });
  }

  void _toggleLocationService() {
    setState(() {
      _locationServiceAgreed = !_locationServiceAgreed;
    });
  }

  void _toggleMarketing() {
    setState(() {
      _marketingAgreed = !_marketingAgreed;
    });
  }

  void _agreeToAll() {
    setState(() {
      _serviceTermsAgreed = true;
      _privacyPolicyAgreed = true;
      _locationServiceAgreed = true;
      _marketingAgreed = true;
    });
    widget.onAgreeAll?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 핸들 바
          const SizedBox(height: 32),
          // 제목
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '약관에 동의해주세요.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 설명 텍스트
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '고객님의 개인정보와 서비스 이용 권리,\n잘 지켜드릴게요.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.gray600,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 약관 목록
          Column(
            children: [
              // 서비스 이용 약관
              _buildTermsItem(
                title: '서비스 이용 약관(필수)',
                isChecked: _serviceTermsAgreed,
                onTap: _toggleServiceTerms,
              ),
              const SizedBox(height: 16),

              // 개인정보 처리방침
              _buildTermsItem(
                title: '개인정보 처리방침(필수)',
                isChecked: _privacyPolicyAgreed,
                onTap: _togglePrivacyPolicy,
              ),
              const SizedBox(height: 16),

              // 위치기반 서비스 이용약관
              _buildTermsItem(
                title: '위치기반 서비스 이용약관(필수)',
                isChecked: _locationServiceAgreed,
                onTap: _toggleLocationService,
              ),
              const SizedBox(height: 16),

              // 마케팅 정보 수신 동의
              _buildTermsItem(
                title: '마케팅 정보 수신 동의(선택)',
                isChecked: _marketingAgreed,
                onTap: _toggleMarketing,
              ),
            ],
          ),
          const SizedBox(height: 32),

          // 모두동의 버튼
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _agreeToAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '모두동의',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTermsItem({
    required String title,
    required bool isChecked,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          isChecked
              ? SvgPicture.asset(
                'assets/images/icon/check_orange.svg',
                width: 16,
                height: 16,
              )
              : SvgPicture.asset(
                'assets/images/icon/check_gray.svg',
                width: 16,
                height: 16,
              ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.gray700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
