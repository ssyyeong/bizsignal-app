import 'dart:convert';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_region_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_interest_area_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_business_item_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_purpose_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_introduction_screen.dart';
import 'package:provider/provider.dart';

class MatchingInfoScreen extends StatefulWidget {
  const MatchingInfoScreen({super.key});

  @override
  State<MatchingInfoScreen> createState() => _MatchingInfoScreenState();
}

class _MatchingInfoScreenState extends State<MatchingInfoScreen> {
  Map<String, dynamic> matchingData = {};
  bool isLoading = true;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    loadMatchingInfo();
  }

  Future<void> loadMatchingInfo() async {
    try {
      final result = await ControllerBase(
        modelName: 'ClassMatchingInfo',
        modelId: 'class_matching_info',
      ).findAll({
        'APP_MEMBER_IDENTIFICATION_CODE': context.read<UserProvider>().user.id,
      });

      if (result['result']['rows'].length > 0) {
        setState(() {
          matchingData = result['result']['rows'][0];
          hasData = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void applyMatchingInfo() async {
    // 이미 JSON 문자열로 저장된 데이터는 그대로 사용
    await ControllerBase(
          modelName: 'ClassMatchingInfo',
          modelId: 'class_matching_info',
        )
        .update({
          'CLASS_MATCHING_INFO_IDENTIFICATION_CODE':
              matchingData['CLASS_MATCHING_INFO_IDENTIFICATION_CODE'],
          'REGION': matchingData['REGION'],
          'BUSINESS_ITEM': matchingData['BUSINESS_ITEM'],
          'INTEREST_AREA': matchingData['INTEREST_AREA'],
          'PARTICIPATION_PURPOSE': matchingData['PARTICIPATION_PURPOSE'],
          'INTRODUCTION': matchingData['INTRODUCTION'],
        })
        .then((result) {
          if (hasData) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('매칭 정보 적용이 완료되었습니다.')));
            Navigator.pushNamed(context, '/my_page');
          }
          Navigator.pushNamed(context, '/matching_complete');
        })
        .catchError((error) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('매칭 정보 적용에 실패했습니다.')));
        });
  }

  List<String> parseJsonToList(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    try {
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBarWidget(title: '매칭 정보 입력', isBackButton: true),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '매칭 정보 입력', isBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            // 메인 콘텐츠
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.primary50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/icon/check_broken.svg',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '입력해주신 정보를 기반으로, ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.gray700,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '알맞은 모임을 매칭',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '해드릴게요!',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.gray700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 입력 항목 리스트
                      if (hasData) ...[
                        _buildInfoCard(
                          number: '1',
                          title: '희망 모임 지역',
                          items: parseJsonToList(matchingData['REGION']),
                        ),
                        _buildInfoCard(
                          number: '2',
                          title: '사업 분야 (업종)',
                          items: parseJsonToList(matchingData['BUSINESS_ITEM']),
                        ),
                        _buildInfoCard(
                          number: '3',
                          title: '관심사 (네트워킹 키워드)',
                          items: parseJsonToList(matchingData['INTEREST_AREA']),
                        ),
                        _buildInfoCard(
                          number: '4',
                          title: '참여 목적',
                          items: parseJsonToList(
                            matchingData['PARTICIPATION_PURPOSE'],
                          ),
                        ),
                        _buildInfoCard(
                          number: '5',
                          title: '한줄 소개',
                          isIntroduction: true,
                          introduction: matchingData['INTRODUCTION'] ?? '',
                        ),
                      ] else ...[
                        _buildMenuItem(number: '1', title: '희망 모임 지역'),
                        _buildMenuItem(number: '2', title: '사업 분야 (업종)'),
                        _buildMenuItem(number: '3', title: '관심사 (네트워킹 키워드)'),
                        _buildMenuItem(number: '4', title: '참여 목적'),
                        _buildMenuItem(number: '5', title: '한줄 소개'),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (!hasData)
              Text(
                '등록 이후 my page에서 수정이 가능합니다.',
                style: TextStyle(fontSize: 12, color: AppColors.gray600),
              ),
            PrimaryButton(
              text: hasData ? '저장' : '매칭 정보 입력하기',
              onPressed: () {
                if (hasData) {
                  applyMatchingInfo();
                } else {
                  Navigator.pushNamed(context, '/matching_region_selection');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({required String number, required String title}) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
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
                  number,
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
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String number,
    required String title,
    List<String>? items,
    bool isIntroduction = false,
    String introduction = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                        number,
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
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray900,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  // 각 항목별로 적절한 수정 화면으로 이동
                  dynamic result;
                  if (number == '1') {
                    result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MatchingRegionSelectionScreen(
                              initialSelectedRegions: Set.from(items ?? []),
                              isEditMode: true,
                            ),
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() {
                        matchingData['REGION'] = jsonEncode(
                          (result as Set<String>).toList(),
                        );
                      });
                    }
                  } else if (number == '2') {
                    result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MatchingBusinessItemSelectionScreen(
                              selectedRegions: const {},
                              initialSelectedBusinessItems: Set.from(
                                items ?? [],
                              ),
                              isEditMode: true,
                            ),
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() {
                        matchingData['BUSINESS_ITEM'] = jsonEncode(
                          (result as Set<String>).toList(),
                        );
                      });
                    }
                  } else if (number == '3') {
                    result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MatchingInterestAreaSelectionScreen(
                              selectedRegions: const {},
                              selectedBusinessItems: const {},
                              initialSelectedInterestAreas: Set.from(
                                items ?? [],
                              ),
                              isEditMode: true,
                            ),
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() {
                        matchingData['INTEREST_AREA'] = jsonEncode(
                          (result as Set<String>).toList(),
                        );
                      });
                    }
                  } else if (number == '4') {
                    result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MatchingPurposeSelectionScreen(
                              selectedRegions: const {},
                              selectedBusinessItems: const {},
                              selectedInterestAreas: const {},
                              initialSelectedPurposes: Set.from(items ?? []),
                              isEditMode: true,
                            ),
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() {
                        matchingData['PARTICIPATION_PURPOSE'] = jsonEncode(
                          (result as Set<String>).toList(),
                        );
                      });
                    }
                  } else if (number == '5') {
                    result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MatchingIntroductionScreen(
                              selectedRegions: const {},
                              selectedBusinessItems: const {},
                              selectedInterestAreas: const {},
                              selectedPurposes: const {},
                              initialIntroduction: introduction,
                              isEditMode: true,
                            ),
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() {
                        matchingData['INTRODUCTION'] = result as String;
                      });
                    }
                  }
                },
                child: Container(
                  height: 28,
                  width: 44,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.gray200),
                  ),
                  child: const Text(
                    '수정',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          if (isIntroduction)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                introduction,
                style: const TextStyle(fontSize: 11, color: AppColors.primary),
              ),
            )
          else if (items != null && items.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  items.map((item) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary500,
                        ),
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }
}
