import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/empty_state.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int selectedMainTab = 0; // 0: 모임, 1: 만남
  int selectedFilterTab = 0; // 0: 전체, 1: 안 읽음, 2: 읽음

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          '채팅',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/notification');
              },
              child: Stack(
                children: [
                  SvgPicture.asset('assets/images/icon/bell_simple.svg'),
                  Positioned(
                    top: 2,
                    right: 2,
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
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 메인 탭 (모임/만남)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedMainTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                selectedMainTab == 0
                                    ? AppColors.gray900
                                    : AppColors.gray200,
                            width: selectedMainTab == 0 ? 2 : 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '모임',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              selectedMainTab == 0
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                          color:
                              selectedMainTab == 0
                                  ? AppColors.gray900
                                  : AppColors.gray600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedMainTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                selectedMainTab == 1
                                    ? AppColors.gray900
                                    : AppColors.gray200,
                            width: selectedMainTab == 1 ? 2 : 1,
                          ),
                        ),
                      ),
                      child: Text(
                        '만남',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              selectedMainTab == 1
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                          color:
                              selectedMainTab == 1
                                  ? AppColors.gray900
                                  : AppColors.gray600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          // 필터 탭 (전체/안 읽음/읽음)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildFilterTab('전체', 0),
                const SizedBox(width: 8),
                _buildFilterTab('안 읽음', 1),
                const SizedBox(width: 8),
                _buildFilterTab('읽음', 2),
              ],
            ),
          ),

          // 채팅 목록
          Expanded(
            child:
                _getChatItems().isEmpty
                    ? EmptyState(
                      title:
                          selectedMainTab == 0 ? '모임 채팅이 없습니다' : '만남 채팅이 없습니다',
                      description: '새로운 채팅이 시작되면\n여기에 표시됩니다',
                      icon: Icons.chat_bubble_outline,
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _getChatItems().length,
                      itemBuilder: (context, index) {
                        final item = _getChatItems()[index];
                        return _buildChatItem(item);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String text, int index) {
    final isSelected = selectedFilterTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedFilterTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.gray900 : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: isSelected ? null : Border.all(color: AppColors.gray200),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? AppColors.white : AppColors.gray700,
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(ChatItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        children: [
          // 프로필 아이콘
          Stack(
            children: [
              SvgPicture.asset(
                'assets/images/icon/people_chat.svg',
                width: 40,
                height: 40,
              ),
              if (item.hasUnread)
                Positioned(
                  right: 6,
                  top: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 18),
          // 메인 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${item.title}(${item.participantCount}명)',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray800,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      item.time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.gray600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.message,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),

          // 상태 및 버튼
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                item.status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color:
                      item.isPending ? AppColors.primary300 : AppColors.gray600,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color:
                      item.isPending ? AppColors.primary300 : AppColors.gray500,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.buttonText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<ChatItem> _getChatItems() {
    // TODO: 실제 채팅 데이터로 교체
    return [];
  }
}

class ChatItem {
  final String title;
  final int participantCount;
  final String time;
  final String message;
  final String status;
  final String buttonText;
  final bool isPending;
  final bool hasUnread;

  ChatItem({
    required this.title,
    required this.participantCount,
    required this.time,
    required this.message,
    required this.status,
    required this.buttonText,
    required this.isPending,
    required this.hasUnread,
  });
}
