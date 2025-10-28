import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/screens/main/class/class_screen.dart';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:bizsignal_app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/screens/main/class/class_create/class_region_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/class_create/class_business_field_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/class_create/class_keywords_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/class_create/class_introduction_screen.dart';
import 'package:provider/provider.dart';

class ClassCreateScreen extends StatefulWidget {
  const ClassCreateScreen({super.key});

  @override
  State<ClassCreateScreen> createState() => _ClassCreateScreenState();
}

class _ClassCreateScreenState extends State<ClassCreateScreen> {
  String? selectedCapacity;
  String? selectedDate;
  String? selectedTime;
  String? selectedPlace;
  String? selectedRegion;
  String? selectedBusinessField;
  String? selectedKeywords;
  String? introduction;

  @override
  void initState() {
    super.initState();
    _setInitialValues();
  }

  void _setInitialValues() {
    // 이번 주 목요일 계산
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1=월, 4=목
    final daysUntilThursday = (4 - currentWeekday) % 7;
    final thisWeekThursday = now.add(Duration(days: daysUntilThursday));

    setState(() {
      selectedDate =
          '${thisWeekThursday.year}-${thisWeekThursday.month.toString().padLeft(2, '0')}-${thisWeekThursday.day.toString().padLeft(2, '0')}(목)';
      selectedTime = '확정 후 지정';
      selectedPlace = '확정 후 지정';
    });
  }

  void createClass() async {
    await ControllerBase(modelName: 'Class', modelId: 'class')
        .create({
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
          'PERSON_COUNT':
              selectedCapacity == '4인'
                  ? 4
                  : selectedCapacity == '5인'
                  ? 5
                  : selectedCapacity == '6인'
                  ? 6
                  : 4,
          'DATE': selectedDate,
          'REGION': selectedRegion,
          'BUSINESS_ITEM': selectedBusinessField,
          'INTEREST_AREA': selectedKeywords,
          'INTRODUCTION': introduction,
        })
        .then((result) {
          _showToast();
          Future.delayed(
            const Duration(milliseconds: 100),
            () => _showDialog(),
          );
        })
        .catchError((error) {
          ToastWidget.showError(context, message: '모임 개설에 실패했습니다');
        });
  }

  void _showToast() {
    ToastWidget.showInfo(context, message: '모임 개설이 완료되었습니다!');
  }

  void _showDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            contentPadding: const EdgeInsets.all(20),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '모임 매칭 결과는',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '최대 화요일',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      TextSpan(
                        text: '까지 안내드릴 예정이에요.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '4명 이상 매칭이 성사되면,\n자동으로 단체 채팅방이 개설됩니다.\n 좋은 만남으로 이어지길 기대할게요!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 모달 닫기
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const ClassScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBarWidget(
        title: '모임 개설',
        isBackButton: true,
        backgroundColor: AppColors.gray100,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),
                // 타이틀 섹션
                _buildTitleSection(),
                const SizedBox(height: 28),
                // 기본 정보 섹션
                _buildBasicInfoSection(),
                const SizedBox(height: 12),
                // 상세 정보 섹션
                _buildDetailInfoSection(),
                const SizedBox(height: 80),
                // 저장 버튼
                _buildSaveButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        SvgPicture.asset('assets/images/icon/class.svg', width: 48, height: 48),
        const SizedBox(height: 16),
        const Text(
          '내가 개설자가 되어,',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.gray800,
          ),
        ),
        const Text(
          '모임을 개설 할 수 있습니다!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.gray800,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          '매주 목요일 00:00 ~ 화요일 18:00까지',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.gray600,
          ),
        ),
        const Text(
          '다음 주 목요일 저녁 모임 개설 가능',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.gray600,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBasicField('모집인원', selectedCapacity, () {
          _showCapacityPicker();
        }),
        const SizedBox(height: 12),
        _buildBasicFieldReadOnly('날짜', selectedDate),
        const SizedBox(height: 12),
        _buildBasicFieldReadOnly('시간', selectedTime),
        const SizedBox(height: 12),
        _buildBasicFieldReadOnly('장소', selectedPlace),
      ],
    );
  }

  Widget _buildBasicField(String label, String? value, VoidCallback onTap) {
    final isPlaceholder =
        value == null ||
        (value == '확정 후 지정' && (label == '시간' || label == '장소'));

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
              ),
            ),
            Row(
              children: [
                Text(
                  value ?? (isPlaceholder ? '선택' : '확정 후 지정'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color:
                        isPlaceholder
                            ? AppColors.gray600
                            : AppColors.primary500,
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/images/icon/arrow_down.svg',
                  width: 16,
                  height: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicFieldReadOnly(String label, String? value) {
    final isConfirmedLater = value == '확정 후 지정';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color:
                  isConfirmedLater ? AppColors.gray600 : AppColors.primary500,
            ),
          ),
        ],
      ),
    );
  }

  void _showCapacityPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '모집인원 선택',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(4, (index) {
                final capacity = '${index + 4}인';
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCapacity = capacity;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          capacity,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray900,
                          ),
                        ),
                        if (selectedCapacity == capacity)
                          SvgPicture.asset(
                            'assets/images/icon/check_orange.svg',
                            width: 20,
                            height: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailInfoSection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.white,
      ),
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 10),
          _buildSelectableField(1, '모임 지역', ''),
          _buildSelectableField(2, '사업 분야 (업종)', ''),
          _buildSelectableField(3, '모임 키워드', ''),
          _buildEditableField(4, '한줄 소개', ''),
        ],
      ),
    );
  }

  Widget _buildSelectableField(int number, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.gray900,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _navigateToSelectionScreen(label);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              side: const BorderSide(color: AppColors.border),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              elevation: 0,
            ),
            child: Text(
              _getButtonText(label),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.gray900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(String label) {
    if (label == '모임 지역') {
      return selectedRegion != null && selectedRegion!.isNotEmpty
          ? '선택 완료'
          : '선택';
    }
    if (label == '사업 분야 (업종)') {
      return selectedBusinessField != null && selectedBusinessField!.isNotEmpty
          ? '선택 완료'
          : '선택';
    }
    if (label == '모임 키워드') {
      return selectedKeywords != null && selectedKeywords!.isNotEmpty
          ? '선택 완료'
          : '선택';
    }
    return '선택';
  }

  Widget _buildEditableField(int number, String label, String value) {
    final displayValue = introduction ?? '입력';
    final isEmpty = displayValue == '입력';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.gray900,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    number.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(
                  displayValue,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isEmpty ? AppColors.gray600 : AppColors.primary500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ClassIntroductionScreen(
                            initialIntroduction: introduction,
                          ),
                    ),
                  );
                  if (result != null && mounted) {
                    setState(() {
                      introduction = result as String;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '입력',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return PrimaryButton(
      text: '저장',
      onPressed: () {
        createClass();
      },
    );
  }

  void _navigateToSelectionScreen(String label) async {
    if (label == '모임 지역') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ClassRegionSelectionScreen(
                initialSelectedRegion: selectedRegion,
              ),
        ),
      );
      if (result != null && mounted) {
        setState(() {
          selectedRegion = result as String?;
        });
      }
    } else if (label == '사업 분야 (업종)') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ClassBusinessFieldSelectionScreen(
                initialSelectedBusinessField: selectedBusinessField,
              ),
        ),
      );
      if (result != null && mounted) {
        setState(() {
          selectedBusinessField = result as String?;
        });
      }
    } else if (label == '모임 키워드') {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ClassKeywordsSelectionScreen(
                initialSelectedKeyword: selectedKeywords,
              ),
        ),
      );
      if (result != null && mounted) {
        setState(() {
          selectedKeywords = result as String?;
        });
      }
    }
  }
}
