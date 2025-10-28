import 'dart:convert';

import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/screens/main/meet/meet_detail_screen.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:bizsignal_app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class ClassDetailScreen extends StatefulWidget {
  final String? classId;

  const ClassDetailScreen({super.key, this.classId});

  @override
  State<ClassDetailScreen> createState() => _ClassDetailScreenState();
}

class _ClassDetailScreenState extends State<ClassDetailScreen> {
  Map<String, dynamic>? classData;
  bool btnVisible = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko', null);
    fetchMeetingDetail();
  }

  void fetchMeetingDetail() async {
    if (widget.classId != null) {
      await ControllerBase(
        modelName: 'Class',
        modelId: 'class',
      ).findOne({'CLASS_IDENTIFICATION_CODE': widget.classId}).then((result) {
        setState(() {
          classData = result['result'];
          if (classData?['AppMember']?['APP_MEMBER_IDENTIFICATION_CODE'] ==
                  context.read<UserProvider>().user.id ||
              classData?['ClassApplies']?.any(
                    (apply) =>
                        apply['APP_MEMBER_IDENTIFICATION_CODE'] ==
                        context.read<UserProvider>().user.id,
                  ) ==
                  true) {
            btnVisible = true;
          }
        });
      });
    }
  }

  void applyClass() async {
    await ControllerBase(modelName: 'ClassApply', modelId: 'class_apply')
        .create({
          'CLASS_IDENTIFICATION_CODE': widget.classId,
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          _showMeetingMatchingDialog();
        })
        .catchError((error) {
          ToastWidget.showError(context, message: '모임 신청에 실패했습니다.');
          print(error);
        });
  }

  void _showMeetingMatchingDialog() {
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
                  '매칭이 성사되면,\n자동으로 단체 채팅방이 개설됩니다.\n 좋은 만남으로 이어지길 기대할게요!',
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
                    _showToastAndNavigate(context);
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

  void _showToastAndNavigate(BuildContext context) {
    // Toast 표시
    ToastWidget.showInfo(context, message: '참석 신청이 완료되었습니다!');

    // 2초 후 class 페이지로 이동
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.of(context).pushNamed('/class');
    });
  }

  @override
  Widget build(BuildContext context) {
    if (classData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '모임 상세', isBackButton: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                  // 제목 및 참석자 수
                  Row(
                    children: [
                      Text(
                        '${classData!['REGION']} ${classData!['INTEREST_AREA']} 모임',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/icon/people_white.svg',
                              width: 16,
                              height: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${classData!['ClassApplies']?.length + 1 ?? 0}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // 모임 정보
                      _buildInfoRow(
                        '날짜',
                        DateFormat(
                          'yyyy-MM-dd(E)',
                          'ko',
                        ).format(DateTime.parse(classData!['DATE'])),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('시간', _formatTime(classData!['TIME'])),
                      const SizedBox(height: 8),
                      _buildInfoRow('장소', classData!['LOCATION'] ?? '미정'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.gray200, thickness: 8),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 모임 소개글
                      _buildSectionTitle('모임 소개글'),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gray50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          classData!['INTRODUCTION'] ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.gray700,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // 모임 키워드
                      _buildSectionTitle('모임 키워드'),
                      const SizedBox(height: 16),
                      _buildKeywordTag(classData!['INTEREST_AREA']),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.gray200, thickness: 8),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 멤버 소개
                      _buildSectionTitle('멤버 소개'),
                      const SizedBox(height: 16),
                      if (classData!['AppMember'] != null)
                        _buildMemberCard(classData!['AppMember'], true),
                      if (classData!['ClassApplies'] != null)
                        ...(classData!['ClassApplies'] as List).map(
                          (apply) => _buildMemberCard(apply, false),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                // 비즈모임 정책
                // Row(
                //   children: [
                //     SvgPicture.asset(
                //       'assets/images/icon/info_circle.svg',
                //       width: 20,
                //       height: 20,
                //       colorFilter: const ColorFilter.mode(
                //         AppColors.gray900,
                //         BlendMode.srcIn,
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     const Text(
                //       '비즈모임 정책',
                //       style: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.w700,
                //         color: AppColors.gray900,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),
                // ...List.generate(
                //   6,
                //   (index) => Padding(
                //     padding: const EdgeInsets.only(bottom: 12),
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Container(
                //           width: 24,
                //           height: 24,
                //           alignment: Alignment.center,
                //           decoration: BoxDecoration(
                //             color: AppColors.gray100,
                //             borderRadius: BorderRadius.circular(6),
                //           ),
                //           child: Text(
                //             '${index + 1}',
                //             style: const TextStyle(
                //               fontSize: 12,
                //               fontWeight: FontWeight.w700,
                //               color: AppColors.gray700,
                //             ),
                //           ),
                //         ),
                //         const SizedBox(width: 12),
                //         const Expanded(
                //           child: Text(
                //             '운영 정책 내용이 들어갑니다.',
                //             style: TextStyle(
                //               fontSize: 13,
                //               color: AppColors.gray600,
                //               height: 1.4,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 120),
              ],
            ),
          ),

          // 하단 동의 버튼
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child:
                btnVisible
                    ? PrimaryButton(
                      text: '모임 정책을 확인하였고, 이에 동의합니다.',
                      onPressed: () {
                        applyClass();
                      },
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return '미정';
    }

    try {
      // 시간 문자열을 DateTime으로 파싱 (예: "19:30" 또는 "2025-06-12 19:30:00")
      DateTime time;
      if (timeString.contains(' ')) {
        time = DateTime.parse(timeString);
      } else {
        // 시간만 있는 경우 (예: "19:30")
        final parts = timeString.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        time = DateTime(2024, 1, 1, hour, minute);
      }

      return DateFormat('a h:mm', 'ko').format(time);
    } catch (e) {
      return '미정';
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.gray900,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.gray600),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildKeywordTag(String keyword) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        keyword,
        style: const TextStyle(fontSize: 13, color: AppColors.gray700),
      ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member, bool isHost) {
    final name = member['FULL_NAME'] ?? member['AppMember']?['FULL_NAME'] ?? '';
    final company =
        member['COMPANY_NAME'] ?? member['AppMember']?['COMPANY_NAME'] ?? '';
    final isAttending = member['IS_ATTENDING'] ?? 'Y';

    final memberId =
        member['ProfileCards'] != null &&
                (member['ProfileCards'] as List).isNotEmpty &&
                member['ProfileCards'][0]['PROFILE_CARD_IDENTIFICATION_CODE'] !=
                    null
            ? member['ProfileCards'][0]['PROFILE_CARD_IDENTIFICATION_CODE']
            : member['ProfileCards'] != null &&
                (member['ProfileCards'] as List).isNotEmpty &&
                member['ProfileCards'][0]['APP_MEMBER_IDENTIFICATION_CODE'] !=
                    null
            ? member['ProfileCards'][0]['APP_MEMBER_IDENTIFICATION_CODE']
            : '';

    return GestureDetector(
      onTap: () {
        if (memberId != '') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MeetDetailScreen(
                    profileCardId: memberId.toString(),
                    isMeeting: false,
                  ),
            ),
          );
        } else {
          ToastWidget.showError(context, message: '프로필 카드가 없습니다.');
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // 프로필 이미지
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  member['ProfileCards'] != null &&
                          (member['ProfileCards'] as List).isNotEmpty &&
                          member['ProfileCards'][0]['PROFILE_IMAGE'] != null
                      ? Image.network(
                        (jsonDecode(member['ProfileCards'][0]['PROFILE_IMAGE'])
                            as List<dynamic>)[0],
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      )
                      : Icon(Icons.person, size: 32, color: AppColors.gray500),
            ),
            const SizedBox(width: 12),

            // 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          '이름',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.gray600,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.gray700,
                            ),
                          ),
                          if (isHost) ...[
                            const SizedBox(width: 4),
                            SvgPicture.asset(
                              'assets/images/icon/crown.svg',
                              width: 12,
                              height: 12,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          '회사명',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.gray600,
                          ),
                        ),
                      ),
                      Text(
                        company,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.gray700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 세로선
            Container(width: 1, height: 60, color: AppColors.gray200),
            const SizedBox(width: 16),

            // 참석 여부
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '참석여부',
                  style: TextStyle(fontSize: 12, color: AppColors.gray600),
                ),
                const SizedBox(height: 4),
                if (isHost || isAttending == 'Y')
                  SvgPicture.asset(
                    'assets/images/icon/check_orange.svg',
                    width: 16,
                    height: 16,
                  )
                else if (isAttending == 'N')
                  SvgPicture.asset(
                    'assets/images/icon/minus.svg',
                    width: 16,
                    height: 16,
                  )
                else
                  SvgPicture.asset(
                    'assets/images/icon/check_gray.svg',
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
}
