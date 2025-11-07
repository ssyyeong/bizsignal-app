import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:flutter/material.dart';
import 'package:bizsignal_app/widgets/empty_state.dart';
import 'package:bizsignal_app/widgets/review_card_widget.dart';
import 'package:bizsignal_app/screens/main/my_page/review/class_review_write_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/review/class_review_detail_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/review/meet_review_write_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/review/meet_review_detail_screen.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 1;
  final int _totalPages = 5;

  List<dynamic> classReviews = [];
  List<dynamic> meetReviews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    // 테스트 데이터 설정
    _initTestData();
    // _fetchClassReviews();
    // _fetchMeetReviews();
  }

  void _initTestData() {
    // 테스트 데이터
    classReviews = [
      {
        'TITLE': '강남역 비즈 모임',
        'PARTICIPANTS': 4,
        'DATE': '2025-06-12',
        'TAGS': ['사업 전략', '교육'],
        'STATUS': '모임 종료',
        'ATTENDANCE': '참석완료',
        'REVIEW_TEXT': '모임 일정이 더 다양했으면 좋겠습니다!', // 후기 작성됨
        'HAS_REVIEW': true,
      },
      {
        'TITLE': '강남역 비즈 모임',
        'PARTICIPANTS': 4,
        'DATE': '2025-06-12',
        'TAGS': ['사업 전략', '교육'],
        'STATUS': '모임 종료',
        'ATTENDANCE': '참석완료',
        'REVIEW_TEXT': null, // 후기 미작성
        'HAS_REVIEW': false,
      },
    ];

    meetReviews = [
      {
        'NAME': '김소윤',
        'COMPANY': '키뮤트',
        'DATE': '2025-06-13',
        'TAGS': ['투자/자금유치'],
        'STATUS': '만남 종료',
        'ATTENDANCE': '참석완료',
        'REVIEW_TEXT': '좋은 만남이었습니다!',
        'HAS_REVIEW': true,
      },
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _fetchClassReviews() async {
    await ControllerBase(
      modelName: 'ClassReview',
      modelId: 'class_review',
    ).findAll({}).then((result) {
      setState(() {
        classReviews = result['result']['rows'];
      });
    });
  }

  // ignore: unused_element
  void _fetchMeetReviews() async {
    await ControllerBase(
      modelName: 'MeetingReview',
      modelId: 'meeting_review',
    ).findAll({}).then((result) {
      setState(() {
        meetReviews = result['result']['rows'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          '후기',
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
      body: Column(
        children: [
          // 탭 바
          Container(
            color: AppColors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.black,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.gray900,
              unselectedLabelColor: AppColors.gray600,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              isScrollable: false,
              dividerColor: Colors.transparent,
              indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: const [Tab(text: '모임'), Tab(text: '만남')],
            ),
          ),
          // 탭 컨텐츠
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildOwnedBenefitsTab(), _buildExpiredBenefitsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnedBenefitsTab() {
    if (classReviews.isEmpty) {
      return const Center(
        child: EmptyState(
          title: '리뷰 목록이 없습니다.',
          description: '모임 신청을 하고 후기를 남겨보세요.',
          icon: Icons.rate_review_outlined,
        ),
      );
    }
    return Column(
      children: [
        // 보유 혜택 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            itemCount: classReviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final review = classReviews[index];
              return _buildReviewCard(review);
            },
          ),
        ),
        // 페이지네이션
        _buildPagination(),
      ],
    );
  }

  Widget _buildExpiredBenefitsTab() {
    if (meetReviews.isEmpty) {
      return const Center(
        child: EmptyState(
          title: '만남 리뷰가 없습니다.',
          description: '만남 신청을 하고 후기를 남겨보세요.',
          icon: Icons.chat_bubble_outline,
        ),
      );
    }
    return Column(
      children: [
        // 만료 혜택 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            itemCount: meetReviews.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final review = meetReviews[index];
              return _buildReviewCard(review);
            },
          ),
        ),
        // 페이지네이션
        _buildPagination(),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    final isClassTab = _tabController.index == 0;
    final hasReview =
        review['HAS_REVIEW'] == true ||
        (review['REVIEW_TEXT'] != null &&
            review['REVIEW_TEXT'].toString().isNotEmpty);

    return ReviewCardWidget(
      review: review,
      isClassType: isClassTab,
      showButton: true,
      hasReview: hasReview,
      onButtonPressed: () {
        if (hasReview) {
          // 상세 화면으로 이동
          if (isClassTab) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ClassReviewDetailScreen(
                      reviewData: _convertToClassReviewData(review),
                    ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => MeetReviewDetailScreen(
                      reviewData: _convertToMeetReviewData(review),
                    ),
              ),
            );
          }
        } else {
          // 작성 화면으로 이동
          if (isClassTab) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ClassReviewWriteScreen(
                      classData: _convertToClassData(review),
                    ),
              ),
            ).then((_) {
              // 작성 후 목록 새로고침
              _initTestData();
              setState(() {});
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => MeetReviewWriteScreen(
                      meetData: _convertToMeetData(review),
                    ),
              ),
            ).then((_) {
              // 작성 후 목록 새로고침
              _initTestData();
              setState(() {});
            });
          }
        }
      },
    );
  }

  Map<String, dynamic> _convertToClassData(Map<String, dynamic> review) {
    return {
      'title': review['TITLE'] ?? review['title'] ?? '',
      'participants': review['PARTICIPANTS'] ?? review['participants'] ?? 0,
      'date': review['DATE'] ?? review['date'] ?? '',
      'tags': review['TAGS'] ?? review['tags'] ?? [],
      'status': review['STATUS'] ?? review['status'] ?? '모임 종료',
      'attendance': review['ATTENDANCE'] ?? review['attendance'] ?? '참석완료',
    };
  }

  Map<String, dynamic> _convertToMeetData(Map<String, dynamic> review) {
    return {
      'name': review['NAME'] ?? review['name'] ?? '',
      'company': review['COMPANY'] ?? review['company'] ?? '',
      'date': review['DATE'] ?? review['date'] ?? '',
      'tags': review['TAGS'] ?? review['tags'] ?? [],
      'status': review['STATUS'] ?? review['status'] ?? '만남 종료',
      'attendance': review['ATTENDANCE'] ?? review['attendance'] ?? '참석완료',
    };
  }

  Map<String, dynamic> _convertToClassReviewData(Map<String, dynamic> review) {
    return {
      'meeting': _convertToClassData(review),
      'answers': {
        'attendance':
            review['ATTENDANCE_ANSWER'] ?? review['attendanceAnswer'] ?? 0,
        'topicRelevance':
            review['TOPIC_RELEVANCE_ANSWER'] ??
            review['topicRelevanceAnswer'] ??
            0,
        'businessHelp':
            review['BUSINESS_HELP_ANSWER'] ?? review['businessHelpAnswer'] ?? 0,
        'nextMeeting':
            review['NEXT_MEETING_ANSWER'] ?? review['nextMeetingAnswer'] ?? 0,
        'reason': review['REASON'] ?? review['reason'],
      },
      'reviewText': review['REVIEW_TEXT'] ?? review['reviewText'] ?? '',
    };
  }

  Map<String, dynamic> _convertToMeetReviewData(Map<String, dynamic> review) {
    return {
      'meet': _convertToMeetData(review),
      'answers': {
        'attendance':
            review['ATTENDANCE_ANSWER'] ?? review['attendanceAnswer'] ?? 0,
        'topicRelevance':
            review['TOPIC_RELEVANCE_ANSWER'] ??
            review['topicRelevanceAnswer'] ??
            0,
        'businessHelp':
            review['BUSINESS_HELP_ANSWER'] ?? review['businessHelpAnswer'] ?? 0,
        'nextMeeting':
            review['NEXT_MEETING_ANSWER'] ?? review['nextMeetingAnswer'] ?? 0,
        'reason': review['REASON'] ?? review['reason'],
      },
      'reviewText': review['REVIEW_TEXT'] ?? review['reviewText'] ?? '',
    };
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 이전 버튼
          GestureDetector(
            onTap:
                _currentPage > 1 ? () => _changePage(_currentPage - 1) : null,
            child: Icon(Icons.chevron_left, color: AppColors.gray700, size: 20),
          ),
          const SizedBox(width: 8),
          // 페이지 번호들
          ...List.generate(_totalPages, (index) {
            final pageNumber = index + 1;
            final isSelected = pageNumber == _currentPage;

            return GestureDetector(
              onTap: () => _changePage(pageNumber),
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.gray100 : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    pageNumber.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 8),
          // 다음 버튼
          GestureDetector(
            onTap:
                _currentPage < _totalPages
                    ? () => _changePage(_currentPage + 1)
                    : null,
            child: Icon(
              Icons.chevron_right,
              color: AppColors.gray700,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
    // 페이지 변경 시 데이터 새로고침 로직 추가
  }
}
