import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 1;
  final int _totalPages = 5;

  List<dynamic> notices = [];
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchNotices();
    _fetchQuestions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchNotices() async {
    await ControllerBase(
      modelName: 'NoticeBoardContent',
      modelId: 'notice_board_content',
    ).findAll({}).then((result) {
      setState(() {
        notices = result['result']['rows'];
      });
    });
  }

  void _fetchQuestions() async {
    await ControllerBase(
      modelName: 'QnaBoardQuestion',
      modelId: 'qna_board_question',
    ).findAll({}).then((result) {
      setState(() {
        questions = result['result']['rows'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '고객센터', isBackButton: true),
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
              tabs: const [Tab(text: '공지사항'), Tab(text: '1:1 문의')],
            ),
          ),
          // 탭 컨텐츠
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildNoticeTab(), _buildInquiryTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeTab() {
    return Column(
      children: [
        // 공지사항 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            itemCount: notices.length,
            separatorBuilder:
                (context, index) =>
                    Divider(color: AppColors.gray200, height: 1),
            itemBuilder: (context, index) {
              final notice = notices[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '[' + notice['CATEGORY']! + ']',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          notice['TITLE']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.gray400,
                      size: 20,
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/notice_detail',
                    arguments:
                        notice['NOTICE_BOARD_CONTENT_IDENTIFICATION_CODE'],
                  );
                },
              );
            },
          ),
        ),
        // 페이지네이션
        _buildPagination(),
      ],
    );
  }

  Widget _buildInquiryTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent, size: 64, color: AppColors.gray300),
          const SizedBox(height: 16),
          Text(
            '1:1 문의 기능이 준비 중입니다.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '문의사항이 있으시면 고객센터로 연락해 주세요.',
            style: TextStyle(fontSize: 14, color: AppColors.gray500),
          ),
        ],
      ),
    );
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
