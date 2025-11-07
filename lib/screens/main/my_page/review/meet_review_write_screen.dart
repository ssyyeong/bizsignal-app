import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/screens/main/my_page/review/meet_review_detail_screen.dart';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:bizsignal_app/widgets/review_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeetReviewWriteScreen extends StatefulWidget {
  final Map<String, dynamic>? meetData;

  const MeetReviewWriteScreen({super.key, this.meetData});

  @override
  State<MeetReviewWriteScreen> createState() => _MeetReviewWriteScreenState();
}

class _MeetReviewWriteScreenState extends State<MeetReviewWriteScreen> {
  // 질문 답변 상태
  int? _attendanceAnswer; // 0: 참석했어요, 1: 참석하지 못했어요
  int? _topicRelevanceAnswer; // 0: 진행되었어요, 1: 보통이었어요, 2: 그렇지 않았어요
  int? _businessHelpAnswer; // 0: 도움되었어요, 1: 보통이었어요, 2: 그렇지 않았어요
  int? _nextMeetingAnswer; // 0: 기대해요, 1: 보통이었어요, 2: 그렇지 않았어요

  // 텍스트 입력
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          '만남 후기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.gray900,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Padding(
            padding: EdgeInsets.only(left: 16, top: 13, bottom: 13),
            child: Icon(Icons.chevron_left, size: 24, color: AppColors.gray900),
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 안내 배너
            _buildInfoBanner(),
            const SizedBox(height: 16),
            // 만남 정보 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ReviewCardWidget(
                review: _convertToReviewData(),
                isClassType: false,
                showButton: false,
              ),
            ),
            const SizedBox(height: 24),
            // 질문 섹션
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 질문 1: 만남에 참석하셨나요?
                  _buildQuestion(
                    '만남에 참석 하셨나요?',
                    ['참석 했어요.', '참석하지 못했어요.'],
                    _attendanceAnswer,
                    (index) => setState(() => _attendanceAnswer = index),
                  ),
                  const SizedBox(height: 24),
                  // 질문 2: 주제에 맞는 이야기로 진행되었나요?
                  _buildQuestion(
                    '주제에 맞는 이야기로 진행되었나요?',
                    ['진행 되었어요.', '보통 이였어요.', '그렇지 않았어요.'],
                    _topicRelevanceAnswer,
                    (index) => setState(() => _topicRelevanceAnswer = index),
                  ),
                  const SizedBox(height: 24),
                  // 질문 3: 비즈니스에 도움이 되었나요?
                  _buildQuestion(
                    '이번 비즈만남이 비즈니스에 도움이 되었나요?',
                    ['도움 되었어요.', '보통 이였어요.', '그렇지 않았어요.'],
                    _businessHelpAnswer,
                    (index) => setState(() => _businessHelpAnswer = index),
                  ),
                  const SizedBox(height: 24),
                  // 질문 4: 다음 만남을 기대하나요?
                  _buildQuestion(
                    '이번 만남 멤버로 다음 모임/만남을 기대하나요?',
                    ['기대해요.', '보통 이였어요.', '그렇지 않았어요.'],
                    _nextMeetingAnswer,
                    (index) => setState(() => _nextMeetingAnswer = index),
                  ),
                  // 조건부 입력 필드 (그렇지 않았어요 선택 시)
                  if (_nextMeetingAnswer == 2) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _reasonController,
                      decoration: InputDecoration(
                        hintText: '그렇지않은 이유를 작성해주세요.',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.gray50,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 24),
                  // 후기 작성 섹션
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
                  TextField(
                    controller: _reviewController,
                    maxLines: 8,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: PrimaryButton(text: '후기 저장', onPressed: _saveReview),
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
            '만남 후기는 ',
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

  Map<String, dynamic> _convertToReviewData() {
    final meetData =
        widget.meetData ??
        {
          'name': '김소윤',
          'company': '키뮤트',
          'date': '2025-06-13',
          'tags': ['투자/자금유치'],
          'status': '만남 종료',
          'attendance': '참석완료',
        };

    return {
      'NAME': meetData['name'],
      'COMPANY': meetData['company'],
      'DATE': meetData['date'],
      'TAGS': meetData['tags'],
      'STATUS': meetData['status'],
      'ATTENDANCE': meetData['attendance'],
    };
  }

  Widget _buildQuestion(
    String question,
    List<String> options,
    int? selectedIndex,
    ValueChanged<int> onSelected,
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(options.length, (index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  options[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.gray700,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 24),
      ],
    );
  }

  void _saveReview() async {
    // TODO: API 호출하여 후기 저장
    // 예시: ControllerBase를 사용하여 저장
    // await ControllerBase(modelName: 'Review', modelId: 'review').create({...});

    // 저장 후 상세 화면으로 이동
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) => MeetReviewDetailScreen(
                reviewData: {
                  'meet': widget.meetData ?? {},
                  'answers': {
                    'attendance': _attendanceAnswer ?? 0,
                    'topicRelevance': _topicRelevanceAnswer ?? 0,
                    'businessHelp': _businessHelpAnswer ?? 0,
                    'nextMeeting': _nextMeetingAnswer ?? 0,
                    'reason': _reasonController.text,
                  },
                  'reviewText': _reviewController.text,
                },
              ),
        ),
      );
    }
  }
}
