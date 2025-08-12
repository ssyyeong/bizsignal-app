import 'package:bizsignal_app/screens/main/chat/chat_screen.dart';
import 'package:bizsignal_app/screens/main/class/class_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'package:bizsignal_app/constants/app_colors.dart';

import 'package:bizsignal_app/screens/main/meet/meet_detail_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/my_page_screen.dart';
import 'package:bizsignal_app/screens/main/meet/meet_application_screen.dart';
import 'package:bizsignal_app/screens/main/meet/meet_payment_screen.dart';
import 'package:bizsignal_app/screens/main/meet/profile_card_screen.dart';

import 'package:bizsignal_app/screens/main/home/home_screen.dart';
import 'package:bizsignal_app/screens/main/meet/meet_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainState();
}

class _MainState extends State<MainScreen> with WidgetsBindingObserver {
  final _homeKey = GlobalKey<NavigatorState>();
  final _meetKey = GlobalKey<NavigatorState>();
  final _gatheringKey = GlobalKey<NavigatorState>();
  final _chatKey = GlobalKey<NavigatorState>();
  final _myKey = GlobalKey<NavigatorState>();

  int _selectedIndex = 0;

  // 시스템 뒤로가기: 탭 스택에서 pop 가능하면 pop, 아니면 앱 레벨에서 pop
  Future<bool> _onWillPop() async {
    final currentNavigator =
        [
          _homeKey,
          _meetKey,
          _gatheringKey,
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
            _gatheringKey,
            _chatKey,
            _myKey,
          ][index].currentState!;
      nav.popUntil((route) => route.isFirst);
    } else {
      setState(() => _selectedIndex = index);
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
              _buildGatheringStack(),
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
    return Container(
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
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
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

  // ===== 각 탭 스택 =====

  Widget _buildHomeStack() {
    return Navigator(
      key: _homeKey,
      onGenerateRoute: (settings) {
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
                  // 예: 리스트 아이템 탭 시 상세로 이동하기 위한 콜백
                  onOpenDetail: (String profileCardId) {
                    _meetKey.currentState!.pushNamed(
                      '/detail',
                      arguments: profileCardId,
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
          final id = settings.arguments?.toString() ?? '';
          return MaterialPageRoute(
            settings: const RouteSettings(name: '/meet/detail'),
            builder: (_) => MeetDetailScreen(profileCardId: id),
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

  Widget _buildGatheringStack() {
    return Navigator(
      key: _gatheringKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/gathering'),
          builder: (_) => const ClassScreen(),
        );
      },
    );
  }

  Widget _buildChatStack() {
    return Navigator(
      key: _chatKey,
      onGenerateRoute: (settings) {
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
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/my_page'),
          builder: (_) => const MyPageScreen(),
        );
      },
    );
  }
}
