import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/empty_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final notificationList = <dynamic>[]; // TODO: 실제 알림 데이터로 교체

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '알림', isBackButton: true),
      body: SafeArea(
        child:
            notificationList.isEmpty
                ? EmptyState(
                  title: '알림이 없습니다',
                  description: '새로운 알림이 도착하면\n여기에 표시됩니다',
                  icon: Icons.notifications_none_outlined,
                )
                : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: notificationList.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationItem(notificationList[index]);
                  },
                ),
      ),
    );
  }

  Widget _buildNotificationItem(dynamic notification) {
    // TODO: 실제 알림 데이터 구조에 맞게 수정
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.gray200, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 알림 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.gray600,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // 알림 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '알림 제목',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '알림 내용이 여기에 표시됩니다.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '2025.01.15 14:30',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
