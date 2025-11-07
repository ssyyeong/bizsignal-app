import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/review_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClassReviewDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? reviewData;

  const ClassReviewDetailScreen({super.key, this.reviewData});

  @override
  Widget build(BuildContext context) {
    // 예시 데이터 (실제로는 reviewData 사용)
    final review =
        reviewData ??
        {
          'meeting': {
            'title': '강남역 비즈 모임',
            'participants': 4,
            'date': '2025-06-12',
            'tags': ['사업 전략', '교육'],
            'status': '모임 종료',
            'attendance': '참석완료',
          },
          'answers': {
            'attendance': 0, // 참석 했어요
            'topicRelevance': 0, // 진행 되었어요
            'businessHelp': 0, // 도움 되었어요
            'nextMeeting': 2, // 그렇지 않았어요
            'reason': '모임 일정이 더 다양했으면 좋겠습니다!',
          },
          'reviewText': '모임 일정이 더 다양했으면 좋겠습니다!',
        };

    final classMeeting = review['meeting'] as Map<String, dynamic>? ?? {};
    final answers = review['answers'] as Map<String, dynamic>? ?? {};

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '모임 후기', isBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 안내 배너
            _buildInfoBanner(),
            const SizedBox(height: 16),
            // 모임 정보 카드
            ReviewCardWidget(
              review: _convertToReviewData(classMeeting),
              isClassType: true,
              showButton: false,
            ),
            const SizedBox(height: 24),
            // 질문 및 답변 섹션
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 질문 1: 모임에 참석하셨나요?
                _buildQuestionWithAnswer('모임에 참석 하셨나요?', [
                  '참석 했어요.',
                  '참석하지 못했어요.',
                ], answers['attendance'] as int? ?? 0),
                // 질문 2: 주제에 맞는 이야기로 진행되었나요?
                _buildQuestionWithAnswer('주제에 맞는 이야기로 진행되었나요?', [
                  '진행 되었어요.',
                  '보통 이였어요.',
                  '그렇지 않았어요.',
                ], answers['topicRelevance'] as int? ?? 0),
                // 질문 3: 비즈니스에 도움이 되었나요?
                _buildQuestionWithAnswer('이번 비즈모임이 비즈니스에 도움이 되었나요?', [
                  '도움 되었어요.',
                  '보통 이였어요.',
                  '그렇지 않았어요.',
                ], answers['businessHelp'] as int? ?? 0),
                // 질문 4: 다음 모임을 기대하나요?
                _buildQuestionWithAnswer(
                  '이번 비즈모임 멤버로 다음 모임/만남을 기대하나요?',
                  ['기대해요.', '보통 이였어요.', '그렇지 않았어요.'],
                  answers['nextMeeting'] as int? ?? 0,
                ),
                // 조건부 답변 표시 (그렇지 않았어요 선택 시)
                if (answers['nextMeeting'] == 2 &&
                    answers['reason'] != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.gray50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      answers['reason'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray900,
                      ),
                    ),
                  ),
                ],
                // 후기 텍스트 섹션
                const Text(
                  '실제 모임 참여 후기를 작성해주세요!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '(운영에 참고하여 서비스를 개선하겠습니다.)',
                  style: TextStyle(fontSize: 12, color: AppColors.gray600),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    review['reviewText'] as String? ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.black,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '후기 목록',
                style: TextStyle(fontSize: 16, color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/icon/check_broken.svg',
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '모임 후기는 ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray700,
            ),
          ),
          Text(
            '작성자와 내부 담당자',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary500,
            ),
          ),
          Text(
            '만 확인할 수 있습니다.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.gray700,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _convertToReviewData(Map<String, dynamic> classMeeting) {
    return {
      'TITLE': classMeeting['title'],
      'PARTICIPANTS': classMeeting['participants'],
      'DATE': classMeeting['date'],
      'TAGS': classMeeting['tags'],
      'STATUS': classMeeting['status'],
      'ATTENDANCE': classMeeting['attendance'],
    };
  }

  Widget _buildQuestionWithAnswer(
    String question,
    List<String> options,
    int selectedIndex,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 16),
        IntrinsicWidth(
          child: Container(
            height: 36,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.primary, width: 1.5),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              options[selectedIndex],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 24),
      ],
    );
  }
}
