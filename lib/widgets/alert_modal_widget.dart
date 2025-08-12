import 'package:flutter/material.dart';
import 'package:bizsignal_app/constants/app_colors.dart';

class AlertModalWidget extends StatelessWidget {
  final String title;
  final List<String> bodyTexts;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final AlertModalType type;

  const AlertModalWidget({
    super.key,
    required this.title,
    required this.bodyTexts,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.type = AlertModalType.single,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
              ),
              textAlign: TextAlign.start,
            ),

            const SizedBox(height: 16),

            // 본문 텍스트들
            ...bodyTexts.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray600,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 버튼들
            if (type == AlertModalType.single) ...[
              // 단일 버튼
              SizedBox(
                width: double.infinity,
                height: 36,
                child: ElevatedButton(
                  onPressed:
                      onPrimaryPressed ?? () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    primaryButtonText ?? '확인',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ] else if (type == AlertModalType.double) ...[
              // 이중 버튼 (가로 배치)
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed:
                            onPrimaryPressed ??
                            () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          primaryButtonText ?? '확인',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed:
                            onSecondaryPressed ??
                            () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gray500,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          secondaryButtonText ?? '취소',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum AlertModalType {
  single, // 단일 버튼 (확인)
  double, // 이중 버튼 (주요 액션 + 취소)
}

// 사용 예시를 위한 팩토리 메서드들
class AlertModalFactory {
  // 만남 신청 완료 모달
  static AlertModalWidget meetingApplicationComplete({
    required BuildContext context,
    VoidCallback? onConfirm,
  }) {
    return AlertModalWidget(
      title: '만남 신청이 완료되었습니다.',
      bodyTexts: ['상대가 수락하면, 자동으로 채팅방이 개설됩니다.', '좋은 만남으로 이어지길 기대할게요!'],
      primaryButtonText: '확인',
      onPrimaryPressed: onConfirm ?? () => Navigator.of(context).pop(),
      type: AlertModalType.single,
    );
  }

  // 멘토링 만남 신청 완료 모달
  static AlertModalWidget mentoringMeetingComplete({
    required BuildContext context,
    VoidCallback? onConfirm,
  }) {
    return AlertModalWidget(
      title: '멘토링 만남 신청이 완료되었습니다.',
      bodyTexts: ['멘토 확인 후, 채팅방이 개설됩니다.', '좋은 만남으로 이어지길 기대할게요!'],
      primaryButtonText: '확인',
      onPrimaryPressed: onConfirm ?? () => Navigator.of(context).pop(),
      type: AlertModalType.single,
    );
  }

  // 이용패스 필요 모달
  static AlertModalWidget usagePassRequired({
    required BuildContext context,
    VoidCallback? onGoToShop,
    VoidCallback? onCancel,
  }) {
    return AlertModalWidget(
      title: '비즈시그널 이용패스가 필요해요!',
      bodyTexts: [
        '이 서비스는 이용패스 가입 후 이용하실 수 있습니다.',
        '지금 이용패스를 구매하고모임·만남 서비스를 무제한으로 경험해보세요!',
      ],
      primaryButtonText: '이용패스샵 바로가기',
      secondaryButtonText: '취소',
      onPrimaryPressed: onGoToShop ?? () => Navigator.of(context).pop(),
      onSecondaryPressed: onCancel ?? () => Navigator.of(context).pop(),
      type: AlertModalType.double,
    );
  }
}
