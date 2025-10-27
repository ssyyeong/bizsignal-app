import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_interest_area_selection_screen.dart';

class MatchingBusinessItemSelectionScreen extends StatefulWidget {
  final Set<String> selectedRegions;
  final Set<String>? initialSelectedBusinessItems;
  final bool isEditMode;

  const MatchingBusinessItemSelectionScreen({
    super.key,
    required this.selectedRegions,
    this.initialSelectedBusinessItems,
    this.isEditMode = false,
  });

  @override
  State<MatchingBusinessItemSelectionScreen> createState() =>
      _MatchingBusinessItemSelectionScreenState();
}

class _MatchingBusinessItemSelectionScreenState
    extends State<MatchingBusinessItemSelectionScreen> {
  late Set<String> selectedBusinessItems;

  final List<String> businessItems = [
    'IT',
    '커머스',
    '교육',
    '콘텐츠',
    'F&B',
    '헬스케어',
    '제조',
  ];

  @override
  void initState() {
    super.initState();
    selectedBusinessItems = widget.initialSelectedBusinessItems ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '사업 분야 (업종)', isBackButton: true),
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
                      _buildRegionGrid(),
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
                                selectedBusinessItems = {};
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
                            selectedBusinessItems.isNotEmpty
                                ? () {
                                  Navigator.pop(context, selectedBusinessItems);
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
                      selectedBusinessItems.isNotEmpty
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        MatchingInterestAreaSelectionScreen(
                                          selectedRegions:
                                              widget.selectedRegions,
                                          selectedBusinessItems:
                                              selectedBusinessItems,
                                        ),
                              ),
                            );
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
        final isActive = step == 2;
        final isCompleted = step == 1;

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
            text: '귀하의 주요 ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          TextSpan(
            text: '사업 분야',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary500,
            ),
          ),
          const TextSpan(
            text: '를\n알려주세요.',
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

  Widget _buildRegionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 172 / 60,
      ),
      itemCount: businessItems.length,
      itemBuilder: (context, index) {
        final businessItem = businessItems[index];
        final isSelected = selectedBusinessItems.contains(businessItem);

        return _buildBusinessItemCard(businessItem, isSelected);
      },
    );
  }

  Widget _buildBusinessItemCard(String businessItem, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedBusinessItems.remove(businessItem);
          } else {
            selectedBusinessItems.add(businessItem);
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
                businessItem,
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
