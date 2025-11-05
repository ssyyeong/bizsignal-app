import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  Map<dynamic, dynamic> entitlementData = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await ControllerBase(modelName: 'Entitlement', modelId: 'entitlement')
        .findAll({
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          if (result['result']['rows'].isNotEmpty) {
            setState(() {
              entitlementData = result['result']['rows'][0];
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'MY',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 26),

                    // 사용자 프로필 정보
                    _buildUserProfile(),
                    const SizedBox(height: 24),

                    // 이용패스 상태
                    _buildUsagePass(),
                    const SizedBox(height: 24),

                    // 비즈니스 제휴 솔루션 배너
                    _buildBusinessPartnershipBanner(),
                    const SizedBox(height: 24),
                    Divider(color: AppColors.gray200, height: 1),
                    const SizedBox(height: 24),
                    // 서비스 바로가기 그리드
                    _buildServiceShortcuts(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // 로그아웃 버튼 - 하단 고정
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              decoration: const BoxDecoration(color: Colors.white),
              child: _buildLogoutButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Row(
      children: [
        // 프로필 이미지
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.gray200,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                context.read<UserProvider>().user.profileImage != null
                    ? Image.network(
                      context.read<UserProvider>().user.profileImage ?? '',
                    )
                    : Image.asset(
                      'assets/images/my_page/profile.svg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.gray200,
                          child: const Icon(
                            Icons.person,
                            size: 28,
                            color: AppColors.gray400,
                          ),
                        );
                      },
                    ),
          ),
        ),
        const SizedBox(width: 16),
        // 사용자 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.read<UserProvider>().user.fullName ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.read<UserProvider>().user.companyName ?? '',
                style: TextStyle(fontSize: 13, color: AppColors.gray700),
              ),
            ],
          ),
        ),
        // 회원정보 수정 버튼
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/check_password');
          },
          child: Container(
            height: 28,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.gray200),
            ),
            child: const Text(
              '회원정보 수정',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.gray900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsagePass() {
    // entitlementData가 있는지 확인
    bool hasEntitlement = entitlementData.isNotEmpty;

    if (hasEntitlement) {
      // entitlementData가 있을 때: 이용패스 정보 표시
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/pass');
        },

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '비즈시그널 이용패스',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900,
                      ),
                    ),
                    Text(
                      ' 1개월',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                Container(
                  height: 8,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.7, // 70% 진행률
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  '25.07.01 ~ 25.07.31',
                  style: TextStyle(fontSize: 12, color: AppColors.gray600),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // entitlementData가 없을 때: 보유 패스 없음 표시
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/pass');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/icon/ticket.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '보유 패스/이용권 없음',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900,
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  'assets/images/icon/arrow_right.svg',
                  width: 20,
                  height: 20,
                  color: AppColors.gray900,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '비즈시그널 패스를 통해 의미있는 연결을 경험하세요!',
              style: TextStyle(fontSize: 12, color: AppColors.gray600),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildBusinessPartnershipBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/partnership');
      },
      child: SvgPicture.asset(
        'assets/images/my_page/solution.svg',
        width: double.infinity,
        height: 80,
      ),
    );
  }

  Widget _buildServiceShortcuts() {
    final services = <Map<String, dynamic>>[
      {
        'icon': 'assets/images/my_page/calendar.svg',
        'label': '비즈 캘린더',
        'route': '/calendar',
      },
      {
        'icon': 'assets/images/my_page/profile.svg',
        'label': '프로필 카드 관리',
        'route': '/profile_card',
      },
      {
        'icon': 'assets/images/my_page/info.svg',
        'label': '매칭 정보 관리',
        'route': '/matching_info',
      },
      {
        'icon': 'assets/images/my_page/voucher.svg',
        'label': '혜택관리',
        'route': '/benefit',
      },
      {
        'icon': 'assets/images/my_page/review.svg',
        'label': '후기',
        'route': '/review',
      },
      {
        'icon': 'assets/images/my_page/headset.svg',
        'label': '고객 센터',
        'route': '/support',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.8,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.pushNamed(context, service['route'] as String);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft, // ✅ 좌측 정렬
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SvgPicture.asset(
                      service['icon'] as String,
                      width: 24, // 이미지처럼 작게
                      height: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        service['label'] as String,
                        style: const TextStyle(
                          fontSize: 14, // 살짝 작게
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          if (!context.mounted) return;

          context.read<UserProvider>().getUser(null);

          // ✅ 루트 네비게이터로 푸시 (탭 네비게이터가 아님)
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppColors.gray200),
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          '로그아웃',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray900,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
