import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReviewCardWidget extends StatelessWidget {
  final Map<String, dynamic> review;
  final bool isClassType; // true: 모임, false: 만남
  final bool showButton; // 버튼 표시 여부
  final bool hasReview; // 후기 작성 여부
  final VoidCallback? onButtonPressed; // 버튼 클릭 콜백

  const ReviewCardWidget({
    super.key,
    required this.review,
    required this.isClassType,
    this.showButton = false,
    this.hasReview = false,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isClassType
                            ? (review['TITLE'] ?? review['title'] ?? '')
                            : '${review['NAME'] ?? review['name'] ?? ''}${review['COMPANY'] != null || review['company'] != null ? '(${review['COMPANY'] ?? review['company']})' : ''}님',
                        style: const TextStyle(
                          fontSize: 18,
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
                              width: 12,
                              height: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isClassType
                                  ? '${review['PARTICIPANTS'] ?? review['participants'] ?? 0}'
                                  : '1:1',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        '날짜',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${review['DATE'] ?? review['date'] ?? ''}(${_getDayOfWeek(review['DATE'] ?? review['date'] ?? '')})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: _buildTagList(review['TAGS'] ?? review['tags']),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  review['STATUS'] ?? review['status'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gray500,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    review['ATTENDANCE'] ?? review['attendance'] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showButton) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 28,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      hasReview ? AppColors.white : AppColors.primary,
                  foregroundColor:
                      hasReview ? AppColors.black : AppColors.white,
                  side: BorderSide(
                    color: hasReview ? AppColors.black : Colors.transparent,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  elevation: 0,
                ),
                child: Text(
                  hasReview ? '후기 상세' : '후기 작성',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: hasReview ? AppColors.black : AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildTagList(dynamic tags) {
    if (tags == null) return [];
    if (tags is! List) return [];

    return tags.map<Widget>((tag) => _buildTag(tag.toString())).toList();
  }

  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: AppColors.gray700),
      ),
    );
  }

  String _getDayOfWeek(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final dayNames = ['월', '화', '수', '목', '금', '토', '일'];
      return dayNames[date.weekday - 1];
    } catch (e) {
      return '';
    }
  }
}

