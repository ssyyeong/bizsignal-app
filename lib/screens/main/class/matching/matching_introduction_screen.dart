import 'dart:convert';

import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:provider/provider.dart';

class MatchingIntroductionScreen extends StatefulWidget {
  final Set<String> selectedRegions;
  final Set<String> selectedBusinessItems;
  final Set<String> selectedInterestAreas;
  final Set<String> selectedPurposes;
  final String? initialIntroduction;
  final bool isEditMode;

  const MatchingIntroductionScreen({
    super.key,
    required this.selectedRegions,
    required this.selectedBusinessItems,
    required this.selectedInterestAreas,
    required this.selectedPurposes,
    this.initialIntroduction,
    this.isEditMode = false,
  });

  @override
  State<MatchingIntroductionScreen> createState() =>
      _MatchingIntroductionScreenState();
}

class _MatchingIntroductionScreenState
    extends State<MatchingIntroductionScreen> {
  final TextEditingController _introductionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialIntroduction != null) {
      _introductionController.text = widget.initialIntroduction!;
    }
  }

  @override
  void dispose() {
    _introductionController.dispose();
    super.dispose();
  }

  void applyMatchingInfo() async {
    await ControllerBase(
          modelName: 'ClassMatchingInfo',
          modelId: 'class_matching_info',
        )
        .create({
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
          'REGION': jsonEncode(widget.selectedRegions.toList()),
          'BUSINESS_ITEM': jsonEncode(widget.selectedBusinessItems.toList()),
          'INTEREST_AREA': jsonEncode(widget.selectedInterestAreas.toList()),
          'PARTICIPATION_PURPOSE': jsonEncode(widget.selectedPurposes.toList()),
          'INTRODUCTION': _introductionController.text,
        })
        .then((result) {
          Navigator.pushNamed(context, '/matching_complete');
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('매칭 정보 적용에 실패했습니다.')));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '한줄 소개', isBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // 진행 상태 인디케이터
              if (!widget.isEditMode) _buildProgressIndicator(),
              const SizedBox(height: 24),
              // 메인 콘텐츠
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPromptText(),
                      const SizedBox(height: 32),
                      _buildTextInputField(),
                    ],
                  ),
                ),
              ),

              // 하단 버튼
              if (widget.isEditMode)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _introductionController.clear();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              side: const BorderSide(
                                color: AppColors.gray200,
                                width: 1,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '초기화',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.gray900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: PrimaryButton(
                        text: '저장',
                        onPressed:
                            _introductionController.text.trim().isNotEmpty
                                ? () {
                                  Navigator.pop(
                                    context,
                                    _introductionController.text,
                                  );
                                }
                                : null,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )
              else
                PrimaryButton(
                  text: '입력 완료',
                  onPressed:
                      _introductionController.text.trim().isNotEmpty
                          ? () {
                            applyMatchingInfo();
                          }
                          : null,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(5, (index) {
        final step = index + 1;
        final isActive = step == 5;
        final isCompleted = step == 1 || step == 2 || step == 3 || step == 4;

        return Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isActive || isCompleted
                        ? AppColors.primary500
                        : AppColors.gray100,
              ),
              child: Center(
                child:
                    isCompleted
                        ? SvgPicture.asset(
                          'assets/images/icon/check_orange.svg',
                          width: 28,
                          height: 28,
                        )
                        : Text(
                          '$step',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color:
                                isActive ? AppColors.white : AppColors.gray600,
                          ),
                        ),
              ),
            ),
            if (index < 4) const SizedBox(width: 8), // 인디케이터 사이 간격
          ],
        );
      }),
    );
  }

  Widget _buildPromptText() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: '모임 매칭 후, 전송되는 프로필에\n',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          TextSpan(
            text: '노출할 ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          TextSpan(
            text: '간단 소개',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary500,
            ),
          ),
          const TextSpan(
            text: '를 입력 해보세요',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInputField() {
    return Container(
      height: 430,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200, width: 1),
      ),
      child: TextField(
        controller: _introductionController,
        onChanged: (value) {
          setState(() {}); // 버튼 활성화 상태 업데이트
        },
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          hintText: '모임 매칭 후, 전송되는 프로필에 노출할 간단 소개를 입력 해보세요',
          hintStyle: TextStyle(fontSize: 13, color: AppColors.gray400),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: const TextStyle(fontSize: 13, color: AppColors.gray900),
      ),
    );
  }
}
