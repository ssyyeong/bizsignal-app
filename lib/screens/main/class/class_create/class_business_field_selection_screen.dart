import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClassBusinessFieldSelectionScreen extends StatefulWidget {
  final String? initialSelectedBusinessField;

  const ClassBusinessFieldSelectionScreen({
    super.key,
    this.initialSelectedBusinessField,
  });

  @override
  State<ClassBusinessFieldSelectionScreen> createState() =>
      _ClassBusinessFieldSelectionScreenState();
}

class _ClassBusinessFieldSelectionScreenState
    extends State<ClassBusinessFieldSelectionScreen> {
  String? selectedBusinessField;

  final List<String> businessFields = [
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
    selectedBusinessField = widget.initialSelectedBusinessField;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '사업 분야', isBackButton: true),
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
                      _buildBusinessFieldGrid(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: '선택 완료',
                onPressed:
                    selectedBusinessField != null
                        ? () {
                          Navigator.pop(context, selectedBusinessField);
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
      '사업 분야를 선택해주세요',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.gray900,
      ),
    );
  }

  Widget _buildBusinessFieldGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 172 / 60,
      ),
      itemCount: businessFields.length,
      itemBuilder: (context, index) {
        final businessField = businessFields[index];
        final isSelected = selectedBusinessField == businessField;

        return _buildBusinessFieldCard(businessField, isSelected);
      },
    );
  }

  Widget _buildBusinessFieldCard(String businessField, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedBusinessField = businessField;
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
                businessField,
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
