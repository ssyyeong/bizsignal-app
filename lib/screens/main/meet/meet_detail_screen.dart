import 'dart:convert';

import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/screens/main/meet/meet_application_screen.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeetDetailScreen extends StatefulWidget {
  final String profileCardId;
  const MeetDetailScreen({super.key, required this.profileCardId});

  @override
  State<MeetDetailScreen> createState() => _MeetDetailScreenState();
}

class _MeetDetailScreenState extends State<MeetDetailScreen> {
  Map<String, dynamic> profileData = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await ControllerBase(modelName: 'ProfileCard', modelId: 'profile_card')
        .findOneByKey({
          'PROFILE_CARD_IDENTIFICATION_CODE': widget.profileCardId,
        })
        .then((result) {
          setState(() {
            profileData = result['result'];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: '프로필 카드', isBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 프로필 정보 섹션
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 프로필 이미지
                      Stack(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    profileData['OFFICIAL_MENTOR_YN'] == 'Y'
                                        ? Colors.transparent
                                        : AppColors.gray300,
                                width: 2,
                              ),
                              gradient:
                                  profileData['OFFICIAL_MENTOR_YN'] == 'Y'
                                      ? const LinearGradient(
                                        colors: [
                                          Color(0xFFFF6928),
                                          Color(0xFFED28FF),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                      : null,
                              color:
                                  profileData['OFFICIAL_MENTOR_YN'] == 'Y'
                                      ? null
                                      : AppColors.gray300,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.gray200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child:
                                    profileData['PROFILE_IMAGE'] != null
                                        ? Image.network(
                                          (jsonDecode(
                                                profileData['PROFILE_IMAGE'],
                                              )
                                              as List<dynamic>)[0],
                                          fit: BoxFit.cover,
                                        )
                                        : Container(
                                          color: AppColors.gray200,
                                          child: const Icon(
                                            Icons.person,
                                            color: AppColors.gray400,
                                            size: 24,
                                          ),
                                        ),
                              ),
                            ),
                          ),

                          // 공식 멘토 배지
                          if (profileData['OFFICIAL_MENTOR_YN'] == 'Y')
                            Positioned(
                              top: 4,
                              left: 4,
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: SvgPicture.asset(
                                  'assets/images/icon/badge.svg',
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      // 이름과 소개
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  profileData['AppMember']?['FULL_NAME'] ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.gray900,
                                  ),
                                ),
                                if (profileData['OFFICIAL_MENTOR_YN'] ==
                                    'Y') ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.gray50,
                                      border: Border.all(
                                        color: AppColors.gray200,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ShaderMask(
                                      shaderCallback:
                                          (bounds) => const LinearGradient(
                                            colors: [
                                              Color(0xFFED28FF),
                                              Color(0xFFFF6928),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            transform: GradientRotation(
                                              99 * 3.14159 / 180,
                                            ), // 99도 회전
                                          ).createShader(bounds),
                                      child: const Text(
                                        '공식 멘토',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          height: 1.5, // line-height: 150%
                                          color:
                                              Colors
                                                  .white, // shaderMask가 적용되려면 흰색이어야 함
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              profileData['INTRODUCTION'] ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // 비즈시그널 공식 멘토 안내
                  if (profileData['OFFICIAL_MENTOR_YN'] == 'Y') ...[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.gray200, width: 1),
                      ),
                      child: const Center(
                        child: Text(
                          '비즈시그널 공식 비즈니스 멘토 입니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.gray600,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  // 만남 대화 주제 섹션
                  const Text(
                    '만남 대화 주제',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children:
                        profileData['KEYWORD_LIST'] != null
                            ? (jsonDecode(profileData['KEYWORD_LIST'])
                                    as List<dynamic>)
                                .map((keyword) => _buildTag(keyword.toString()))
                                .toList()
                            : [],
                  ),

                  const SizedBox(height: 32),

                  // 기업 정보 섹션
                  const Text(
                    '기업 정보',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          '기업명',
                          profileData['AppMember']?['COMPANY_NAME'] ?? '기업명 없음',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          '사업 아이템',
                          profileData['AppMember']?['BUSINESS_ITEM'] ??
                              '사업 아이템 없음',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          '활동 지역',
                          '${profileData['AppMember']?['REGION'] ?? ''} ${profileData['AppMember']?['REGION2'] ?? ''}'
                                  .trim()
                                  .isEmpty
                              ? '활동 지역 없음'
                              : '${profileData['AppMember']?['REGION'] ?? ''} ${profileData['AppMember']?['REGION2'] ?? ''}'
                                  .trim(),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          '사업 분야',
                          profileData['AppMember']?['COMPANY_INDUSTRY'] ??
                              '사업 분야 없음',
                        ),
                      ],
                    ),
                  ),

                  if (profileData['OFFICIAL_MENTOR_YN'] == 'Y') ...[
                    const SizedBox(height: 32),

                    // 신청 안내 섹션
                    const Text(
                      '신청 안내',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '멘토링 티켓',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${profileData['TICKE_PRICE'] ?? 0}',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.gray900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // 만남 신청 버튼 - 하단 고정
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40), // 하단 여백 증가
            decoration: const BoxDecoration(color: Colors.white),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // 만남 신청 로직
                  debugPrint(
                    'MeetDetailScreen - profileCardId: ${profileData['PROFILE_CARD_IDENTIFICATION_CODE']}',
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MeetApplicationScreen(
                            profileCardId:
                                profileData['PROFILE_CARD_IDENTIFICATION_CODE'] ??
                                0,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '만남 신청',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: AppColors.gray700),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.gray600,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: AppColors.gray700),
        ),
      ],
    );
  }
}
