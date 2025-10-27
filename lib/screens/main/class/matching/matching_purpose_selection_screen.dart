import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_introduction_screen.dart';

class MatchingPurposeSelectionScreen extends StatefulWidget {
  final Set<String> selectedRegions;
  final Set<String> selectedBusinessItems;
  final Set<String> selectedInterestAreas;
  final Set<String>? initialSelectedPurposes;
  final bool isEditMode;

  const MatchingPurposeSelectionScreen({
    super.key,
    required this.selectedRegions,
    required this.selectedBusinessItems,
    required this.selectedInterestAreas,
    this.initialSelectedPurposes,
    this.isEditMode = false,
  });

  @override
  State<MatchingPurposeSelectionScreen> createState() =>
      _MatchingPurposeSelectionScreenState();
}

class _MatchingPurposeSelectionScreenState
    extends State<MatchingPurposeSelectionScreen> {
  late Set<String> selectedPurposes;

  final List<String> purposes = ['네트워킹 중심', '사업 제휴', '정보 교류', '동료 찾기'];

  @override
  void initState() {
    super.initState();
    selectedPurposes = widget.initialSelectedPurposes ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '참여 목적', isBackButton: true),
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
                      _buildPurposeGrid(),
                    ],
                  ),
                ),
              ),
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
                                selectedPurposes = {};
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
                            selectedPurposes.isNotEmpty
                                ? () {
                                  Navigator.pop(context, selectedPurposes);
                                }
                                : null,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )
              else
                PrimaryButton(
                  text: '다음',
                  onPressed:
                      selectedPurposes.isNotEmpty
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MatchingIntroductionScreen(
                                      selectedRegions: widget.selectedRegions,
                                      selectedBusinessItems:
                                          widget.selectedBusinessItems,
                                      selectedInterestAreas:
                                          widget.selectedInterestAreas,
                                      selectedPurposes: selectedPurposes,
                                    ),
                              ),
                            );
                          }
                          : null,
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
        final isActive = step == 4;
        final isCompleted = step == 1 || step == 2 || step == 3;

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
            text: '어떤 ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          TextSpan(
            text: '목적의',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary500,
            ),
          ),
          const TextSpan(
            text: ' 만남을\n기대하시나요?',
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

  Widget _buildPurposeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 172 / 60,
      ),
      itemCount: purposes.length,
      itemBuilder: (context, index) {
        final purpose = purposes[index];
        final isSelected = selectedPurposes.contains(purpose);

        return _buildPurposeCard(purpose, isSelected);
      },
    );
  }

  Widget _buildPurposeCard(String purpose, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedPurposes.remove(purpose);
          } else {
            selectedPurposes.add(purpose);
          }
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary500 : AppColors.gray200,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                purpose,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? AppColors.primary500 : AppColors.gray600,
                ),
              ),
            ),

            // 아이콘 표시
            isSelected
                ? SvgPicture.asset(
                  'assets/images/icon/check_orange.svg',
                  width: 16,
                  height: 16,
                )
                : SvgPicture.asset(
                  'assets/images/icon/plus.svg',
                  width: 16,
                  height: 16,
                ),
          ],
        ),
      ),
    );
  }
}
