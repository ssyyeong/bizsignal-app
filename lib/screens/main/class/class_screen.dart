import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/widgets/class_meeting_card_widget.dart';

class ClassScreen extends StatefulWidget {
  final int? initialTabIndex;

  const ClassScreen({super.key, this.initialTabIndex});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showOnlyFourOrMore = false;

  // 샘플 데이터
  final List<Map<String, dynamic>> _meetings = [
    {
      'title': '강남역 비즈 모임',
      'description': '교육분야 사업전략을 같이 고민해보고싶습니다.',
      'tags': ['사업 전략', '교육', '강남'],
      'currentParticipants': 3,
      'maxParticipants': 6,
      'isRecruiting': true,
    },
    {
      'title': '홍대역 비즈 모임',
      'description': '교육분야 사업전략을 같이 고민해보고싶습니다.',
      'tags': ['제품/기술', '헬스케어', '홍대'],
      'currentParticipants': 2,
      'maxParticipants': 6,
      'isRecruiting': true,
    },
    {
      'title': '홍대역 비즈 모임',
      'description': '교육분야 사업전략을 같이 고민해보고싶습니다.',
      'tags': ['제품/기술', '헬스케어', '홍대'],
      'currentParticipants': 2,
      'maxParticipants': 6,
      'isRecruiting': true,
    },
    {
      'title': '판교 비즈 모임',
      'description': '교육분야 사업전략을 같이 고민해보고싶습니다.',
      'tags': ['인사/조직', 'IT', '판교'],
      'currentParticipants': 6,
      'maxParticipants': 6,
      'isRecruiting': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.initialTabIndex ?? 0;
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialIndex.clamp(0, 2),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getNextThursday() {
    final now = DateTime.now();
    final daysUntilThursday = (DateTime.thursday - now.weekday) % 7;
    final daysToAdd = daysUntilThursday == 0 ? 7 : daysUntilThursday;
    final nextThursday = now.add(Duration(days: daysToAdd));
    return '${nextThursday.month}월 ${nextThursday.day}일 목요일 저녁';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // 고정 헤더 (스크롤해도 항상 보임)
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverHeaderDelegate(
                minHeight: 50,
                maxHeight: 50,
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '모임',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray900,
                        ),
                      ),
                      Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/images/icon/bell_simple.svg',
                          ),
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 배너
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/icon/calendar_color.svg',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getNextThursday(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '이번 주 모임 신청 기간입니다. \n목요일부터 수요일까지 신청하실 수 있어요!',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 21),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/matching_complete');
                        },
                        child: Container(
                          width: 61,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '모임 개설',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // 탭
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.gray900,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
                  labelColor: AppColors.gray900,
                  unselectedLabelColor: AppColors.gray600,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  onTap: (index) {},
                  tabs: const [
                    Tab(text: '희망 지역별'),
                    Tab(text: '관심사별'),
                    Tab(text: '사업 분야별'),
                  ],
                ),
              ),
            ),
            // 필터 체크박스
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showOnlyFourOrMore = !_showOnlyFourOrMore;
                        });
                      },
                      child: SvgPicture.asset(
                        _showOnlyFourOrMore
                            ? 'assets/images/icon/check_orange.svg'
                            : 'assets/images/icon/check_gray.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '4인 이상 모집 모임만 보기',
                      style: TextStyle(fontSize: 13, color: AppColors.gray700),
                    ),
                  ],
                ),
              ),
            ),
            // 모임 카드 리스트
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final meeting = _meetings[index];
                  return ClassMeetingCard(
                    title: meeting['title'] as String,
                    description: meeting['description'] as String,
                    tags: meeting['tags'] as List<String>,
                    currentParticipants: meeting['currentParticipants'] as int,
                    maxParticipants: meeting['maxParticipants'] as int,
                    isRecruiting: meeting['isRecruiting'] as bool,
                  );
                }, childCount: _meetings.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SliverAppBar 대신 커스텀 헤더를 위한 delegate
class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.white, child: child);
  }

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

// SliverAppBar 대신 커스텀 탭바를 위한 delegate
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
