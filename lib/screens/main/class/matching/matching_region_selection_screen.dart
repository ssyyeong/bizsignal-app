import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_business_item_selection_screen.dart';

class MatchingRegionSelectionScreen extends StatefulWidget {
  final Set<String>? initialSelectedRegions;
  final bool isEditMode;

  const MatchingRegionSelectionScreen({
    super.key,
    this.initialSelectedRegions,
    this.isEditMode = false,
  });

  @override
  State<MatchingRegionSelectionScreen> createState() =>
      _MatchingRegionSelectionScreenState();
}

class _MatchingRegionSelectionScreenState
    extends State<MatchingRegionSelectionScreen> {
  late Set<String> selectedRegions;

  final List<String> regions = ['강남', '홍대', '판교', '종로', '성수', '기타'];

  @override
  void initState() {
    super.initState();
    selectedRegions = widget.initialSelectedRegions ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '희망 모임 지역', isBackButton: true),
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
                                selectedRegions = {};
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
                            child: Text(
                              '초기화',
                              style: const TextStyle(
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
                            selectedRegions.isNotEmpty
                                ? () {
                                  Navigator.pop(context, selectedRegions);
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
                      selectedRegions.isNotEmpty
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        MatchingBusinessItemSelectionScreen(
                                          selectedRegions: selectedRegions,
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
        final isActive = step == 1;

        return Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary500 : AppColors.gray100,
              ),
              child: Center(
                child: Text(
                  '$step',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isActive ? AppColors.white : AppColors.gray600,
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
            text: '주로 활동하시는 거점 ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          TextSpan(
            text: '지역을\n',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary500,
            ),
          ),
          const TextSpan(
            text: '선택해주세요.',
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
      itemCount: regions.length,
      itemBuilder: (context, index) {
        final region = regions[index];
        final isSelected = selectedRegions.contains(region);

        return _buildRegionCard(region, isSelected);
      },
    );
  }

  Widget _buildRegionCard(String region, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedRegions.remove(region);
          } else {
            selectedRegions.add(region);
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
                region,
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
