import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/constants/app_colors.dart';

class MatchingCompleteScreen extends StatefulWidget {
  const MatchingCompleteScreen({super.key});

  @override
  State<MatchingCompleteScreen> createState() => _MatchingCompleteScreenState();
}

class _MatchingCompleteScreenState extends State<MatchingCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '', isBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 완료 아이콘
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary500,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/icon/check_orange.svg',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // 제목
                      const Text(
                        '매칭 입력 완료!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 설명
                      const Text(
                        '입력하신 항목을 기반으로\n모임을 제안 해드립니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 하단 영역
              Column(
                children: [
                  // 안내 텍스트
                  const Text(
                    '해당 정보는, 마이페이지에서 변경이 가능합니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: '모임 리스트 보러가기',
                    onPressed: () {
                      Navigator.pushNamed(context, '/class');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
