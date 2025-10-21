import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/screens/main/meet/profile_card_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _getNextThursday() {
    final now = DateTime.now();
    final daysUntilThursday = (DateTime.thursday - now.weekday) % 7;
    final nextThursday = now.add(Duration(days: daysUntilThursday));
    return '${nextThursday.month}월 ${nextThursday.day}일';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 헤더
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo/logo_black.svg',
                      width: 100,
                      height: 15,
                    ),
                    SvgPicture.asset('assets/images/icon/bell_simple.svg'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // 맞춤 제안 모임 섹션
              _buildCustomizedMeetingSection(),
              const SizedBox(height: 16),

              // 1:1 만남 섹션
              _buildOneOnOneMeetingSection(context),
              const SizedBox(height: 24),

              // 비즈시그널 채널 섹션
              _buildBizsignalChannelSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomizedMeetingSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '맞춤 제안 ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
                TextSpan(
                  text: '모임',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/icon/calendar.svg',
                width: 14,
                height: 14,
              ),
              const SizedBox(width: 4),
              Text(
                '이번 주 | ${_getNextThursday()} 목요일 저녁',
                style: TextStyle(fontSize: 12, color: AppColors.gray700),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildCategoryItem(
                  icon: 'assets/images/icon/map.svg',
                  title: '희망 지역별',
                ),
              ),
              Expanded(
                child: _buildCategoryItem(
                  icon: 'assets/images/icon/like.svg',
                  title: '관심사별',
                ),
              ),
              Expanded(
                child: _buildCategoryItem(
                  icon: 'assets/images/icon/document.svg',
                  title: '사업 분야별',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({required String icon, required String title}) {
    return Column(
      children: [
        SvgPicture.asset(icon, width: 32, height: 32),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.gray800,
          ),
        ),
      ],
    );
  }

  Widget _buildOneOnOneMeetingSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '1:1 ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900,
                      ),
                    ),
                    TextSpan(
                      text: '만남',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary500,
                      ),
                    ),
                  ],
                ),
              ),
              SvgPicture.asset(
                'assets/images/icon/arrow_right.svg',
                width: 24,
                height: 24,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                'assets/images/icon/message.svg',
                width: 14,
                height: 14,
              ),
              const SizedBox(width: 4),
              const Text(
                '깊은 대화를 통한 인사이트, 커피챗',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildProfileCardItem(hasProfileCard: false, context: context),
          const SizedBox(height: 12),
          _buildProfileCardItem(hasProfileCard: true, context: context),
        ],
      ),
    );
  }

  Widget _buildProfileCardItem({
    required bool hasProfileCard,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          SvgPicture.asset(
            hasProfileCard
                ? 'assets/images/icon/list.svg'
                : 'assets/images/icon/card.svg',
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasProfileCard ? '만남 리스트 보러가기' : '프로필카드 작성',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasProfileCard ? '이미 작성한 프로필카드가 있다면?' : '프로필카드를 설정하지 않았다면?',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileCardScreen(),
                ),
              );
            },
            child: Container(
              width: 44,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.gray200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                hasProfileCard ? '보기' : '작성',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBizsignalChannelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '비즈시그널 채널',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 4),

        Row(
          children: [
            SvgPicture.asset(
              'assets/images/icon/story.svg',
              width: 14,
              height: 14,
            ),
            const SizedBox(width: 4),
            const Text(
              '우리들의 스토리',
              style: TextStyle(fontSize: 14, color: AppColors.gray600),
            ),
          ],
        ),

        const SizedBox(height: 12),
        _buildChannelItem(
          icon: 'assets/images/icon/channel_class.svg',
          title: '매주 목요일 저녁, ${_getNextThursday()} \n사람들과의 오프라인 모임',
          route: '/class_introduce',
        ),
        const SizedBox(height: 8),
        _buildChannelItem(
          icon: 'assets/images/icon/channel_meet.svg',
          title: '깊은 대화가 필요한 순간, \n1:1 만남',
          route: '/meet_introduce',
        ),
        const SizedBox(height: 8),
        _buildChannelItem(
          icon: 'assets/images/icon/channel_use.svg',
          title: '비즈시그널, \n어떻게 이용하나요?',
          route: '/faq_introduce',
        ),
      ],
    );
  }

  Widget _buildChannelItem({
    required String icon,
    required String title,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 28, height: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray800,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/images/icon/arrow_right.svg',
              width: 24,
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
