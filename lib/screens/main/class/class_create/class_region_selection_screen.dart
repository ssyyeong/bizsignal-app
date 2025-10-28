import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClassRegionSelectionScreen extends StatefulWidget {
  final String? initialSelectedRegion;

  const ClassRegionSelectionScreen({super.key, this.initialSelectedRegion});

  @override
  State<ClassRegionSelectionScreen> createState() =>
      _ClassRegionSelectionScreenState();
}

class _ClassRegionSelectionScreenState
    extends State<ClassRegionSelectionScreen> {
  String? selectedRegion;
  bool showCustomInput = false;
  final TextEditingController customController = TextEditingController();

  final List<String> regions = ['강남', '홍대', '판교', '종로', '성수', '기타'];

  @override
  void initState() {
    super.initState();
    selectedRegion = widget.initialSelectedRegion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '모임 지역', isBackButton: true),
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
                      _buildRegionGrid(),
                      if (showCustomInput) ...[
                        const SizedBox(height: 16),
                        _buildCustomInputField(),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: '선택 완료',
                onPressed: () {
                  String? result;
                  if (showCustomInput && customController.text.isNotEmpty) {
                    result = customController.text;
                  } else if (selectedRegion != null) {
                    result = selectedRegion;
                  }
                  Navigator.pop(context, result);
                },
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
      '모임 지역을 선택해주세요',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.gray900,
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
        final isSelected = selectedRegion == region;

        return _buildRegionCard(region, isSelected);
      },
    );
  }

  Widget _buildRegionCard(String region, bool isSelected) {
    return InkWell(
      onTap: () {
        if (region == '기타') {
          // 기타를 선택하면 텍스트 입력 필드 표시하고 다른 선택 해제
          setState(() {
            selectedRegion = null;
            showCustomInput = true;
          });
        } else {
          // 다른 지역 선택 시 기타 입력 필드 숨기고 해당 지역 선택
          setState(() {
            selectedRegion = region;
            showCustomInput = false;
            customController.clear();
          });
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color:
              (isSelected || (region == '기타' && showCustomInput))
                  ? AppColors.primary50
                  : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                (isSelected || (region == '기타' && showCustomInput))
                    ? AppColors.primary500
                    : AppColors.gray200,
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
            (isSelected || (region == '기타' && showCustomInput))
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

  Widget _buildCustomInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '지역 입력',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: customController,
            decoration: const InputDecoration(
              hintText: '지역을 입력해주세요',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
