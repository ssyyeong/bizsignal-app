import 'package:bizsignal_app/screens/main/my_page/support/notice_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:bizsignal_app/constants/app_colors.dart';

import 'package:bizsignal_app/screens/main/home/home_screen.dart';
import 'package:bizsignal_app/screens/main/home/introduce/class_introduce_screen.dart';
import 'package:bizsignal_app/screens/main/home/introduce/meet_introduce_screen.dart';
import 'package:bizsignal_app/screens/main/home/introduce/faq_introduce_screen.dart';

import 'package:bizsignal_app/screens/main/chat/chat_screen.dart';

import 'package:bizsignal_app/screens/main/class/class_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_info_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_region_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_business_item_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_interest_area_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_purpose_selection_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_introduction_screen.dart';
import 'package:bizsignal_app/screens/main/class/matching/matching_complete_screen.dart';
import 'package:bizsignal_app/screens/main/class/class_create_screen.dart';
import 'package:bizsignal_app/screens/main/class/class_detail_screen.dart';

import 'package:bizsignal_app/screens/main/meet/meet_screen.dart';
import 'package:bizsignal_app/screens/main/meet/meet_detail_screen.dart';
import 'package:bizsignal_app/screens/main/meet/meet_application_screen.dart';
import 'package:bizsignal_app/screens/main/meet/meet_payment_screen.dart';
import 'package:bizsignal_app/screens/main/meet/profile_card_screen.dart';

import 'package:bizsignal_app/screens/main/my_page/my_page_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/profile/check_password_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/pass/pass_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/pass/pass_shop_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/profile/change_password_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/profile/member_info_modify_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/support/support_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/benefit/benefit_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/partnership/partnership_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/partnership/partnership_detail_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/calendar/calendar_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/review/review_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/partnership/partnership_inquiry_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/review/class_review_detail_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/review/class_review_write_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/review/meet_review_detail_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/review/meet_review_write_screen.dart';

import 'package:bizsignal_app/screens/main/notification/notification_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainState();
}

class _MainState extends State<MainScreen> with WidgetsBindingObserver {
  final _homeKey = GlobalKey<NavigatorState>();
  final _meetKey = GlobalKey<NavigatorState>();
  final _classKey = GlobalKey<NavigatorState>();
  final _chatKey = GlobalKey<NavigatorState>();
  final _myKey = GlobalKey<NavigatorState>();

  int _selectedIndex = 0;

  // 시스템 뒤로가기: 탭 스택에서 pop 가능하면 pop, 아니면 앱 레벨에서 pop
  Future<bool> _onWillPop() async {
    final currentNavigator =
        [
          _homeKey,
          _meetKey,
          _classKey,
          _chatKey,
          _myKey,
        ][_selectedIndex].currentState!;
    if (currentNavigator.canPop()) {
      currentNavigator.pop();
      return false;
    }
    return true;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      // 같은 탭 다시 누르면 루트로 스택 비우기
      final nav =
          [
            _homeKey,
            _meetKey,
            _classKey,
            _chatKey,
            _myKey,
          ][index].currentState!;
      if (nav.canPop()) {
        nav.popUntil((route) => route.isFirst);
      }
    } else {
      if (mounted) {
        setState(() => _selectedIndex = index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeStack(),
              _buildMeetStack(), // ✅ /meet, /meet/detail/:id, /meet/application ...
              _buildClassStack(),
              _buildChatStack(),
              _buildMyStack(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildBottomBar() {
    return RepaintBoundary(
      child: Container(
        height: 62,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            _buildNavItem(0, '홈', 'assets/images/navigator/home.svg'),
            _buildNavItem(1, '만남', 'assets/images/navigator/meet.svg'),
            _buildNavItem(2, '모임', 'assets/images/navigator/class.svg'),
            _buildNavItem(3, '채팅', 'assets/images/navigator/chat.svg'),
            _buildNavItem(4, '마이페이지', 'assets/images/navigator/my_page.svg'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.gray900 : AppColors.gray500,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppColors.gray900 : AppColors.gray500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeStack() {
    return Navigator(
      key: _homeKey,
      onGenerateRoute: (settings) {
        if (settings.name == '/class') {
          // 탭 변경하고 Navigate
          Future.microtask(() {
            setState(() => _selectedIndex = 2); // 모임 탭으로 변경
            _classKey.currentState?.pushReplacementNamed(
              '/class',
              arguments: settings.arguments,
            );
          });

          final tabIndex = settings.arguments as int?;
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => ClassScreen(initialTabIndex: tabIndex),
          );
        }

        if (settings.name == '/class_introduce') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ClassIntroduceScreen(),
          );
        }
        if (settings.name == '/meet_introduce') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MeetIntroduceScreen(),
          );
        }

        if (settings.name == '/faq_introduce') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const FaqIntroduceScreen(),
          );
        }

        if (settings.name == '/support') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/support'),
            builder: (_) => const SupportScreen(),
          );
        }

        if (settings.name == '/class') {
          // 탭을 모임으로 변경
          Future.microtask(() {
            setState(() => _selectedIndex = 2); // 모임 탭으로 변경
            _classKey.currentState?.pushNamed('/class');
          });
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ClassScreen(),
          );
        }
        if (settings.name == '/matching_info') {
          // 탭을 모임으로 변경
          Future.microtask(() {
            setState(() => _selectedIndex = 2); // 모임 탭으로 변경
            _classKey.currentState?.pushNamed('/matching_info');
          });

          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MatchingInfoScreen(),
          );
        }

        // 알림 페이지(/notification)
        if (settings.name == '/notification') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/notification'),
            builder: (_) => const NotificationScreen(),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const HomeScreen(),
        );
      },
    );
  }

  Widget _buildMeetStack() {
    return Navigator(
      key: _meetKey,
      onGenerateRoute: (settings) {
        // 기본 루트(/meet)
        if (settings.name == null || settings.name == '/') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/meet'),
            builder:
                (_) => MeetScreen(
                  onOpenDetail: (String profileCardId) {
                    _meetKey.currentState!.pushNamed(
                      '/detail',
                      arguments: {
                        'profileCardId': profileCardId,
                        'isMeeting': true,
                      },
                    );
                  },
                  onOpenApplication: (int profileCardId) {
                    _meetKey.currentState!.pushNamed(
                      '/application',
                      arguments: profileCardId,
                    );
                  },
                  onOpenProfileCard: () {
                    _meetKey.currentState!.pushNamed('/profile_card');
                  },
                ),
          );
        }

        // 상세(/meet/detail/:id)
        if (settings.name == '/detail') {
          final args = settings.arguments;
          String id = '';
          bool isMeeting = true;

          if (args is Map<String, dynamic>) {
            id = args['profileCardId']?.toString() ?? '';
            isMeeting = args['isMeeting'] ?? true;
          } else {
            id = args?.toString() ?? '';
          }

          return MaterialPageRoute(
            settings: const RouteSettings(name: '/meet/detail'),
            builder:
                (_) =>
                    MeetDetailScreen(profileCardId: id, isMeeting: isMeeting),
          );
        }

        // 신청(/meet/application)
        if (settings.name == '/application') {
          final profileCardId = settings.arguments as int;
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/meet/application'),
            builder: (_) => MeetApplicationScreen(profileCardId: profileCardId),
          );
        }

        // 결제(/meet/payment)
        if (settings.name == '/payment') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/meet/payment'),
            builder:
                (_) => MeetPaymentScreen(
                  profileData: args,
                  receiverId: args['receiverId']?.toString() ?? '',
                  greeting: args['greeting']?.toString() ?? '',
                ),
          );
        }

        // 프로필 카드(/meet/profile_card)
        if (settings.name == '/profile_card') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/meet/profile_card'),
            builder: (_) => const ProfileCardScreen(),
          );
        }

        // 알림 페이지(/notification)
        if (settings.name == '/notification') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/notification'),
            builder: (_) => const NotificationScreen(),
          );
        }

        // fallback
        return MaterialPageRoute(
          builder:
              (_) => MeetScreen(
                onOpenDetail: (String profileCardId) {},
                onOpenApplication: (int profileCardId) {},
                onOpenProfileCard: () {},
              ),
        );
      },
    );
  }

  Widget _buildClassStack() {
    return Navigator(
      key: _classKey,
      onGenerateRoute: (settings) {
        if (settings.name == '/matching_info') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MatchingInfoScreen(),
          );
        }

        if (settings.name == '/matching_region_selection') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MatchingRegionSelectionScreen(),
          );
        }

        if (settings.name == '/matching_business_item_selection') {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) => MatchingBusinessItemSelectionScreen(
                  selectedRegions: settings.arguments as Set<String>,
                ),
          );
        }

        if (settings.name == '/matching_interest_area_selection') {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) => MatchingInterestAreaSelectionScreen(
                  selectedRegions: settings.arguments as Set<String>,
                  selectedBusinessItems: settings.arguments as Set<String>,
                ),
          );
        }

        if (settings.name == '/matching_purpose_selection') {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) => MatchingPurposeSelectionScreen(
                  selectedRegions: settings.arguments as Set<String>,
                  selectedBusinessItems: settings.arguments as Set<String>,
                  selectedInterestAreas: settings.arguments as Set<String>,
                ),
          );
        }
        if (settings.name == '/matching_introduction') {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) => MatchingIntroductionScreen(
                  selectedRegions: settings.arguments as Set<String>,
                  selectedBusinessItems: settings.arguments as Set<String>,
                  selectedInterestAreas: settings.arguments as Set<String>,
                  selectedPurposes: settings.arguments as Set<String>,
                ),
          );
        }
        if (settings.name == '/matching_complete') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MatchingCompleteScreen(),
          );
        }

        if (settings.name == '/class_create') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const ClassCreateScreen(),
          );
        }

        if (settings.name == '/class_detail') {
          return MaterialPageRoute(
            settings: settings,
            builder:
                (_) =>
                    ClassDetailScreen(classId: settings.arguments as String?),
          );
        }

        // 알림 페이지(/notification)
        if (settings.name == '/notification') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/notification'),
            builder: (_) => const NotificationScreen(),
          );
        }

        // 탭 인덱스를 arguments에서 가져오기
        final tabIndex = settings.arguments as int?;

        return MaterialPageRoute(
          settings: const RouteSettings(name: '/class'),
          builder: (_) => ClassScreen(initialTabIndex: tabIndex),
        );
      },
    );
  }

  Widget _buildChatStack() {
    return Navigator(
      key: _chatKey,
      onGenerateRoute: (settings) {
        // 알림 페이지(/notification)
        if (settings.name == '/notification') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/notification'),
            builder: (_) => const NotificationScreen(),
          );
        }

        return MaterialPageRoute(
          settings: const RouteSettings(name: '/chat'),
          builder: (_) => const ChatScreen(),
        );
      },
    );
  }

  Widget _buildMyStack() {
    return Navigator(
      key: _myKey,
      onGenerateRoute: (settings) {
        // 기본 루트(/my_page)
        if (settings.name == null || settings.name == '/') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page'),
            builder: (_) => const MyPageScreen(),
          );
        }

        // 비밀번호 확인(/my_page/check_password)
        if (settings.name == '/check_password') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/check_password'),
            builder: (_) => const CheckPasswordScreen(),
          );
        }
        // 비밀번호 변경(/my_page/change_password)
        if (settings.name == '/change_password') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/change_password'),
            builder: (_) => const ChangePasswordScreen(),
          );
        }

        // 회원정보 수정(/my_page/member_info_modify)
        if (settings.name == '/member_info_modify') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/member_info_modify'),
            builder: (_) => const MemberInfoModifyScreen(),
          );
        }

        // 이용패스(/my_page/pass)
        if (settings.name == '/pass') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/pass'),
            builder: (_) => const PassScreen(),
          );
        }

        // 비즈시그널 패스샵(/my_page/pass_shop)
        if (settings.name == '/pass_shop') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/pass_shop'),
            builder: (_) => const PassShopScreen(),
          );
        }

        // 파트너십(/my_page/partnership)
        if (settings.name == '/partnership') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/partnership'),
            builder: (_) => const PartnershipScreen(),
          );
        }

        if (settings.name == '/partnership_detail') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/partnership_detail'),
            builder:
                (_) => PartnershipDetailScreen(
                  coalitionId: settings.arguments as String,
                ),
          );
        }

        if (settings.name == '/partnership_inquiry') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/partnership_inquiry'),
            builder: (_) => const PartnershipInquiryScreen(),
          );
        }

        // 프로필 카드(/my_page/profile_card)
        if (settings.name == '/profile_card') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/profile_card'),
            builder: (_) => const ProfileCardScreen(),
          );
        }

        // 혜택 관리(/my_page/benefit)
        if (settings.name == '/benefit') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/benefit'),
            builder: (_) => const BenefitScreen(),
          );
        }

        // 비즈 캘린더(/my_page/calendar)
        if (settings.name == '/calendar') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/calendar'),
            builder: (_) => const CalendarScreen(),
          );
        }

        // 후기(/my_page/review)
        if (settings.name == '/review') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/review'),
            builder: (_) => const ReviewScreen(),
          );
        }

        //모임 후기 작성
        if (settings.name == '/class_review_write') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/class_review_write'),
            builder: (_) => const ClassReviewWriteScreen(),
          );
        }

        //만남 후기 작성
        if (settings.name == '/meet_review_write') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/meet_review_write'),
            builder: (_) => const MeetReviewWriteScreen(),
          );
        }

        //모임 후기 상세
        if (settings.name == '/class_review_detail') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/class_review_detail'),
            builder: (_) => const ClassReviewDetailScreen(),
          );
        }

        //만남 후기 상세
        if (settings.name == '/meet_review_detail') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/meet_review_detail'),
            builder: (_) => const MeetReviewDetailScreen(),
          );
        }

        // 고객센터(/support)
        if (settings.name == '/support') {
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/my_page/support'),
            builder: (_) => const SupportScreen(),
          );
        }

        // 고객센터 공지사항 상세(/support/notice_detail)
        if (settings.name == '/notice_detail') {
          final noticeBoardContentId = settings.arguments as int;
          return MaterialPageRoute(
            settings: const RouteSettings(
              name: '/my_page/support/notice_detail',
            ),
            builder:
                (_) => NoticeDetailScreen(
                  noticeBoardContentId: noticeBoardContentId,
                ),
          );
        }

        if (settings.name == '/matching_info') {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => const MatchingInfoScreen(),
          );
        }

        // fallback
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/my_page'),
          builder: (_) => const MyPageScreen(),
        );
      },
    );
  }
}
