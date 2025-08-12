import 'dart:convert';

import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/screens/main/meet/meet_payment_screen.dart';
import 'package:bizsignal_app/screens/main/main_screen.dart';
import 'package:bizsignal_app/widgets/alert_modal_widget.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class MeetApplicationScreen extends StatefulWidget {
  final int profileCardId;
  const MeetApplicationScreen({super.key, required this.profileCardId});

  @override
  State<MeetApplicationScreen> createState() => _MeetApplicationScreenState();
}

class _MeetApplicationScreenState extends State<MeetApplicationScreen> {
  Map<String, dynamic> profileData = {};
  bool isOfficialMentor = false;
  TextEditingController greetingController = TextEditingController();

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
            isOfficialMentor = profileData['OFFICIAL_MENTOR_YN'] == 'Y';
          });
        });
  }

  void applyMeet() {
    // Map<String, dynamic> data = {
    //   'REQUESTER_MEMBER_IDENTIFICATION_CODE':
    //       profileData['AppMember']?['APP_MEMBER_IDENTIFICATION_CODE'] ??
    //       profileData['AppMember']?['APP_MEMBER_IDENTIFICATION_CODE'] ??
    //       0,
    //   'RECEIVER_MEMBER_IDENTIFICATION_CODE': 1,
    //   'MESSAGE': greetingController.text,
    //   'ACCEPT_YN': 'WAIT',
    //   'CHANNEL': 'FREE',
    // };

    // ControllerBase(
    //   modelName: 'MeetingRequest',
    //   modelId: 'meeting_request',
    // ).create(data).then((result) {
    //   print(result);
    //   if (result['result'] != null) {
    //     // 결제 완료 후 모달 표시
    //     if (mounted) {}
    //   }
    // });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertModalFactory.meetingApplicationComplete(
            context: context,
            onConfirm: () {
              Navigator.of(context).pop(); // 모달 닫기
              // 만남 탭으로 이동 (MainScreen의 _onItemTapped 방식 사용)
              // 만남 탭으로 이동하면서 MainScreen 유지
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MainScreen()),
                (route) => false,
              );
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: '만남 신청', isBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
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
                                      isOfficialMentor
                                          ? Colors.transparent
                                          : AppColors.gray300,
                                  width: 2,
                                ),
                                gradient:
                                    isOfficialMentor
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
                                    isOfficialMentor ? null : AppColors.gray300,
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
                            if (isOfficialMentor)
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
                                    profileData['AppMember']?['FULL_NAME'] ??
                                        '',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.gray900,
                                    ),
                                  ),
                                  if (isOfficialMentor) ...[
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
                  ),

                  // 비즈시그널 공식 멘토 안내 (공식 멘토일 때만)
                  if (isOfficialMentor) ...[
                    Container(
                      width: MediaQuery.of(context).size.width + 100,
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 20,
                      ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                        .map(
                                          (keyword) =>
                                              _buildTag(keyword.toString()),
                                        )
                                        .toList()
                                    : [],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // 신청 안내 섹션 (공식 멘토일 때만)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                      ),
                    ),
                  ],

                  // 구분선과 인사말 섹션 (모든 경우에 표시)
                  SizedBox(height: 25),
                  const Divider(color: AppColors.gray200, thickness: 8),
                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 인사말 섹션 제목
                        Text(
                          isOfficialMentor ? '멘토링 신청 인사말' : '만남 신청 인사말',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 인사말 안내 텍스트
                        Text(
                          isOfficialMentor
                              ? '공식 멘토에게 나의 프로필카드를 전송합니다.\n만남 신청 인사말을 작성해 주세요.\n짧은 한 줄 메시지로 만남을 신청해보세요!'
                              : '신청대상 멤버에게 나의 프로필카드를 전송합니다.\n만남 신청 인사말을 작성해 주세요.\n짧은 한 줄 메시지로 만남을 신청해보세요!',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray700,
                          ),
                        ),

                        const SizedBox(height: 16),
                        // 인사말 입력 필드
                        Container(
                          width: double.infinity,
                          height: 127,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.gray50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: greetingController,
                            onChanged: (value) {
                              setState(() {
                                greetingController.text = value;
                              });
                            },
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: '예) 투자 관련 이야기를 나눠보고 싶어요!',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: AppColors.gray500,
                              ),
                              fillColor: AppColors.gray50,
                              filled: true,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          //신청하기 or 결제 하기 버튼 - 하단 고정
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40), // 하단 여백 증가
            decoration: const BoxDecoration(color: Colors.white),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  if (isOfficialMentor) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => MeetPaymentScreen(
                              profileData: profileData,
                              receiverId:
                                  (profileData['AppMember']?['APP_MEMBER_IDENTIFICATION_CODE'] ??
                                          profileData['PROFILE_CARD_IDENTIFICATION_CODE'] ??
                                          0)
                                      .toString(),
                              greeting: greetingController.text,
                            ),
                      ),
                    );
                  } else {
                    applyMeet();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isOfficialMentor ? '결제 하기' : '신청하기',
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
}
