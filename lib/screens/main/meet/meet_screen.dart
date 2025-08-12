import 'dart:convert';
import 'package:bizsignal_app/controller/custom/profile_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/app_colors.dart';
import '../../../widgets/profile_card_widget.dart';

class MeetScreen extends StatefulWidget {
  const MeetScreen({
    super.key,
    // ✅ MainScreen에서 주입할 콜백들
    required this.onOpenDetail, // /meet/detail/:id
    required this.onOpenApplication, // /meet/application
    required this.onOpenProfileCard, // /meet/profile_card
  });

  final void Function(String profileCardId) onOpenDetail;
  final void Function(int profileCardId) onOpenApplication;
  final VoidCallback onOpenProfileCard;

  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  bool showOnlyOfficialMentors = false;
  bool receiveMeetingRequests = true;
  String selectedFilter = '전체';
  bool isFilterDropdownOpen = false;

  List<dynamic> profileData = [];

  final List<String> filterOptions = [
    '전체',
    '투자/자금 유치',
    '마케팅/프로모션',
    '정부지원사업',
    '해외진출/수출입',
    '세무/법무/회계',
    'R&D (IT&S/W)',
    '경영/사업 전략',
    '프라이빗 멘토링',
    '부동산/공간',
    '오픈이노베이션/MOU',
  ];

  @override
  void initState() {
    super.initState();
    filtering();
  }

  void filtering() async {
    Map<String, dynamic> data = {};
    if (showOnlyOfficialMentors) {
      data["OFFICIAL_MENTOR_YN"] = "Y";
    }
    if (selectedFilter != '전체') {
      data["KEYWORD_LIST"] = selectedFilter;
    }
    await ProfileCardController().filteringProfileCard(data).then((result) {
      setState(() {
        profileData =
            result['result']['rows']
                .where(
                  (element) =>
                      element['AppMember']['APP_MEMBER_IDENTIFICATION_CODE'] !=
                      0,
                )
                .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 18),
                  _buildFilterSection(),
                ],
              ),
            ),
            Expanded(child: _buildProfileList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '만남',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        SvgPicture.asset('assets/images/icon/bell_simple.svg'),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showFilterModal(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedFilter,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.gray900,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.gray900),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap:
                      () => {
                        setState(
                          () =>
                              showOnlyOfficialMentors =
                                  !showOnlyOfficialMentors,
                        ),
                        filtering(),
                      },
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            showOnlyOfficialMentors
                                ? AppColors.primary
                                : AppColors.gray400,
                        width: 2,
                      ),
                      color:
                          showOnlyOfficialMentors
                              ? AppColors.primary
                              : AppColors.gray400,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '공식 멘토 프로필만 보기',
                  style: TextStyle(fontSize: 14, color: AppColors.gray700),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: receiveMeetingRequests,
                    onChanged:
                        (v) => setState(() => receiveMeetingRequests = v),
                    activeTrackColor: AppColors.primary500,
                  ),
                ),
                const Text(
                  '만남 신청 받기',
                  style: TextStyle(fontSize: 12, color: AppColors.black),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (_) => Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 16),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: filterOptions.length,
                    itemBuilder: (_, i) {
                      final option = filterOptions[i];
                      final selected = selectedFilter == option;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedFilter = option);
                          filtering();
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                option,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      selected
                                          ? AppColors.primary
                                          : AppColors.gray700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (selected)
                                Icon(
                                  Icons.check,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
    );
  }

  Widget _buildProfileList() {
    return ListView.builder(
      itemCount: profileData.length,
      itemBuilder: (context, index) {
        final profile = profileData[index];
        final idStr = profile['PROFILE_CARD_IDENTIFICATION_CODE'].toString();
        final idInt = int.tryParse(idStr) ?? 0;

        return ProfileCard(
          name: profile['AppMember']['FULL_NAME'],
          companyName: profile['AppMember']['COMPANY_NAME'],
          profileImage: jsonDecode(profile['PROFILE_IMAGE'])[0],
          introduction: profile['INTRODUCTION'],
          keywordList: jsonDecode(profile['KEYWORD_LIST']),
          isOfficialMentor: profile['OFFICIAL_MENTOR_YN'] == 'Y',
          // ✅ 상세 이동: 콜백 사용 (탭-Navigator로 push)
          goToProfileDetail: () => widget.onOpenDetail(idStr),
        );
      },
    );
  }
}
