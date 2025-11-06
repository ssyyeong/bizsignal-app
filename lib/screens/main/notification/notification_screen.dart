import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/controller/custom/notification_controller.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../widgets/empty_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<dynamic> notificationList = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  void _fetchNotifications() async {
    await ControllerBase(
      modelName: 'Notification',
      modelId: 'notification',
    ).findAll({}).then((result) {
      setState(() {
        notificationList = result['result']['rows'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          '알림',
          style: TextStyle(
            color: AppColors.gray900,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 13, bottom: 13),
            child: SvgPicture.asset(
              'assets/images/icon/arrow_back.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
        leadingWidth: 48,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              '모두 읽음',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child:
            notificationList.isEmpty
                ? EmptyState(
                  title: '알림이 없습니다',
                  description: '새로운 알림이 도착하면\n여기에 표시됩니다',
                  icon: Icons.notifications_none_outlined,
                )
                : ListView.builder(
                  itemCount: notificationList.length,
                  itemBuilder: (context, index) {
                    return _buildNotificationItem(notificationList[index]);
                  },
                ),
      ),
    );
  }

  void _markAllAsRead() async {
    await NotificationController()
        .markAllAsRead({
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          if (result) {
            _fetchNotifications();
            ToastWidget.showSuccess(context, message: '모든 알림을 읽음으로 표시했습니다');
          }
        });
  }

  Widget _buildNotificationItem(dynamic notification) {
    final isUnread =
        notification['READ_YN'] == 'N' || notification['READ_YN'] == null;

    // 배경색 결정: 안 읽음은 주황색 배경, 읽음은 흰색 배경
    final backgroundColor =
        isUnread
            ? AppColors.primary.withOpacity(0.05) // 주황색 배경 (약간 투명)
            : AppColors.white;

    // 제목, 내용, 시간 추출 (실제 필드명에 맞게 수정 필요)
    final title = notification['TITLE'];
    final content = notification['CONTENT'];
    final createdAt = notification['CREATED_AT'];

    // 시간 포맷팅
    String timeText = '';
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt.toString());
        final now = DateTime.now();
        final difference = now.difference(date);

        if (difference.inDays > 0) {
          timeText = '${difference.inDays}일 전';
        } else if (difference.inHours > 0) {
          timeText = '${difference.inHours}시간 전';
        } else if (difference.inMinutes > 0) {
          timeText = '${difference.inMinutes}분 전';
        } else {
          timeText = '방금 전';
        }
      } catch (e) {
        timeText = createdAt.toString();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 알림 아이콘
          SvgPicture.asset(
            isUnread
                ? 'assets/images/icon/bell_orange.svg'
                : 'assets/images/icon/bell_simple.svg',
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 12),
          // 알림 내용
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isUnread ? AppColors.primary : AppColors.gray600,
                      ),
                    ),
                    if (timeText.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        timeText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray600,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: TextStyle(fontSize: 13, color: AppColors.gray800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
