import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';

class ClassMeetingCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tags;
  final int currentParticipants;
  final int maxParticipants;
  final bool isRecruiting;

  const ClassMeetingCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    required this.currentParticipants,
    required this.maxParticipants,
    required this.isRecruiting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상태 및 제목
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (isRecruiting)
                    SvgPicture.asset(
                      'assets/images/icon/indicator.svg',
                      width: 14,
                      height: 14,
                    ),
                  const SizedBox(width: 6),
                  Text(
                    isRecruiting ? '모집중' : '모집종료',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color:
                          isRecruiting ? AppColors.primary : AppColors.gray500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  isRecruiting
                      ? SvgPicture.asset(
                        'assets/images/icon/people_orange.svg',
                        width: 16,
                        height: 16,
                      )
                      : SvgPicture.asset(
                        'assets/images/icon/people_gray.svg',
                        width: 16,
                        height: 16,
                      ),
                  const SizedBox(width: 4),
                  Text(
                    '$currentParticipants',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color:
                          isRecruiting ? AppColors.primary : AppColors.gray600,
                    ),
                  ),
                  Text(
                    '/$maxParticipants',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 제목
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isRecruiting ? AppColors.gray900 : AppColors.gray600,
            ),
          ),
          const SizedBox(height: 2),
          // 설명
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: isRecruiting ? AppColors.gray700 : AppColors.gray500,
            ),
          ),
          const SizedBox(height: 12),
          // 태그 및 신청하기 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children:
                    tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isRecruiting
                                    ? AppColors.gray700
                                    : AppColors.gray500,
                          ),
                        ),
                      );
                    }).toList(),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: 신청하기 기능 구현
                },
                child: Container(
                  width: 80,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isRecruiting ? AppColors.primary : AppColors.gray300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '신청하기',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
