import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class Category {
  final String name;
  final List<String> items;

  Category({required this.name, required this.items});
}

class ClassKeywordsSelectionScreen extends StatefulWidget {
  final String? initialSelectedKeyword;

  const ClassKeywordsSelectionScreen({super.key, this.initialSelectedKeyword});

  @override
  State<ClassKeywordsSelectionScreen> createState() =>
      _ClassKeywordsSelectionScreenState();
}

class _ClassKeywordsSelectionScreenState
    extends State<ClassKeywordsSelectionScreen> {
  String? selectedKeyword;

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
    selectedKeyword = widget.initialSelectedKeyword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '모임 키워드', isBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
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
              const SizedBox(height: 16),
              PrimaryButton(
                text: '선택 완료',
                onPressed:
                    selectedKeyword != null
                        ? () {
                          Navigator.pop(context, selectedKeyword);
                        }
                        : null,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptText() {
    return const Text(
      '모임 키워드를 선택해주세요',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.gray900,
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
                    final isSelected = selectedKeyword == item;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedKeyword = item;
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
                          borderRadius: BorderRadius.circular(999),
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
