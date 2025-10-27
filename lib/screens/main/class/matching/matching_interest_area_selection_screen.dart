import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_purpose_selection_screen.dart';

class MatchingInterestAreaSelectionScreen extends StatefulWidget {
  final Set<String> selectedRegions;
  final Set<String> selectedBusinessItems;
  final Set<String>? initialSelectedInterestAreas;
  final bool isEditMode;

  const MatchingInterestAreaSelectionScreen({
    super.key,
    required this.selectedRegions,
    required this.selectedBusinessItems,
    this.initialSelectedInterestAreas,
    this.isEditMode = false,
  });

  @override
  State<MatchingInterestAreaSelectionScreen> createState() =>
      _MatchingInterestAreaSelectionScreenState();
}

class Category {
  final String name;
  final List<String> items;

  Category({required this.name, required this.items});
}

class _MatchingInterestAreaSelectionScreenState
    extends State<MatchingInterestAreaSelectionScreen> {
  late Set<String> selectedInterestAreas;

  final List<Category> categories = [
    Category(
      name: '사업전략',
      items: ['투자유치', '시장전략', 'BM 수립', '글로벌 진출', 'IR 피드백'],
    ),
    Category(
      name: '제품/기술',
      items: ['서비스 기획', '개발조직 운영', 'UX/UI', 'SAAS 구조 설계'],
    ),
    Category(name: '재무/지표', items: ['재무모델링', '밸류에이션', '손익분석', '회계 세팅']),
    Category(name: '인사/조직', items: ['팀빌딩', '채용전략', '스톡옵션 설계', '조직문화 자문']),
  ];

  @override
  void initState() {
    super.initState();
    selectedInterestAreas = widget.initialSelectedInterestAreas ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '관심사 (네트워킹 키워드)', isBackButton: true),
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
                      _buildCategoriesList(),
                      const SizedBox(height: 20),
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
                                selectedInterestAreas = {};
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
                            selectedInterestAreas.isNotEmpty
                                ? () {
                                  Navigator.pop(context, selectedInterestAreas);
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
                      selectedInterestAreas.isNotEmpty
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MatchingPurposeSelectionScreen(
                                      selectedRegions: widget.selectedRegions,
                                      selectedBusinessItems:
                                          widget.selectedBusinessItems,
                                      selectedInterestAreas:
                                          selectedInterestAreas,
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
        final isActive = step == 3;
        final isCompleted = step == 1 || step == 2;

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
            text: '함께 이야기 나누고 싶은 ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          TextSpan(
            text: '주제',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary500,
            ),
          ),
          const TextSpan(
            text: '를\n선택해주세요.',
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

  Widget _buildCategoriesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      itemBuilder: (context, categoryIndex) {
        final category = categories[categoryIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 카테고리 제목
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray700,
                ),
              ),
            ),
            // 카테고리 항목들
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  category.items.map((item) {
                    final isSelected = selectedInterestAreas.contains(item);
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedInterestAreas.remove(item);
                          } else {
                            selectedInterestAreas.add(item);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color:
                                isSelected
                                    ? AppColors.primary500
                                    : AppColors.gray200,
                          ),
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? AppColors.primary500
                                    : AppColors.gray600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            if (categoryIndex < categories.length - 1)
              const SizedBox(height: 28),
          ],
        );
      },
    );
  }
}
