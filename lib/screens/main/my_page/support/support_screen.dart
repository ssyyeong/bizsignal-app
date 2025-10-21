import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
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
  Set<int> expandedQuestions = {}; // 확장된 문의 ID들

  // 문의하기 모달 관련 상태
  bool _showInquiryModal = false;
  String _selectedInquiryType = '선택';
  List<dynamic> inquiryTypes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _fetchNotices();
    _fetchQuestions();
    _fetchInquiryTypes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _contentController.dispose();
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

  void _fetchInquiryTypes() async {
    await ControllerBase(
      modelName: 'QnaBoardCategory',
      modelId: 'qna_board_category',
    ).findAll({}).then((result) {
      setState(() {
        inquiryTypes = result['result']['rows'];
      });
    });
  }

  void _submitInquiry() async {
    final inquiryType = inquiryTypes.firstWhere(
      (e) => e['CATEGORY'] == _selectedInquiryType,
    );
    final inquiryCode = inquiryType['QNA_BOARD_CATEGORY_IDENTIFICATION_CODE'];
    await ControllerBase(
          modelName: 'QnaBoardQuestion',
          modelId: 'qna_board_question',
        )
        .create({
          'QNA_BOARD_CATEGORY_IDENTIFICATION_CODE': inquiryCode,
          'TITLE': _titleController.text,
          'CONTENT': _contentController.text,
        })
        .then((result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('문의가 접수되었습니다.'),
              backgroundColor: AppColors.primary,
            ),
          );
          _fetchQuestions();
          setState(() {
            _showInquiryModal = false;
            _titleController.clear();
            _contentController.clear();
            _selectedInquiryType = '선택';
          });
        });
  }

  bool _isFormValid() {
    return _selectedInquiryType != '선택' &&
        _titleController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          '고객센터',
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
        actions: [
          // 1:1 문의 탭일 때만 문의하기 버튼 표시
          if (_tabController.index == 1)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showInquiryModal = true;
                });
              },
              child: Container(
                width: 80,
                height: 28,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF4D4D4D)),
                ),
                child: Center(
                  child: Text(
                    '문의하기',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4D4D4D),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
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
          // 문의하기 모달
          if (_showInquiryModal) _buildInquiryModal(),
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
                    Expanded(
                      child: Row(
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
                          Expanded(
                            child: Text(
                              notice['TITLE']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.gray900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
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
    return Column(
      children: [
        // 문의 목록
        Expanded(
          child:
              questions.isEmpty
                  ? _buildEmptyInquiryState()
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 30,
                    ),
                    itemCount: questions.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final questionId =
                          question['QNA_BOARD_QUESTION_IDENTIFICATION_CODE'] ??
                          index;
                      final isExpanded = expandedQuestions.contains(questionId);

                      return _buildInquiryItem(
                        question,
                        questionId,
                        isExpanded,
                      );
                    },
                  ),
        ),
        // 페이지네이션
        _buildPagination(),
      ],
    );
  }

  Widget _buildEmptyInquiryState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.support_agent, size: 64, color: AppColors.gray300),
          const SizedBox(height: 16),
          Text(
            '문의 내역이 없습니다.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '문의사항이 있으시면 문의하기 버튼을 눌러주세요.',
            style: TextStyle(fontSize: 14, color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryItem(
    Map<String, dynamic> question,
    int questionId,
    bool isExpanded,
  ) {
    final isAnswered = question['QnaBoardAnswers'].length > 0;

    return Container(
      decoration: BoxDecoration(color: AppColors.white),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _toggleQuestionExpansion(questionId),
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Row(
                children: [
                  // 상태 태그
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isAnswered ? AppColors.primary : AppColors.gray500,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isAnswered ? '답변 완료' : '답변 전',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 제목
                  Expanded(
                    child: Text(
                      '[${question['CATEGORY'] ?? '카테고리'}] ${question['TITLE'] ?? '질문의 제목이 노출됩니다.'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.gray900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 확장/축소 아이콘
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.gray400,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          // 문의 내용 (확장 시에만 표시)
          if (isExpanded) ...[
            Divider(color: AppColors.gray200, height: 1),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 문의 날짜
                  Text(
                    _formatDate(question['CREATED_AT'] ?? '2025.07.26 12:20'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.gray500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 문의 내용
                  Text(
                    question['CONTENT'] ?? question['CONTENT'] ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 답변 섹션 (답변 완료인 경우)
                  if (isAnswered) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question['QnaBoardAnswers'][0]['CONTENT'] ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(
                                  question['QnaBoardAnswers'][0]['CREATED_AT'] ??
                                      '',
                                ),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF4D4D4D),
                                ),
                              ),
                              Text(
                                '관리자',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF4D4D4D),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _toggleQuestionExpansion(int questionId) {
    setState(() {
      if (expandedQuestions.contains(questionId)) {
        expandedQuestions.remove(questionId);
      } else {
        expandedQuestions.add(questionId);
      }
    });
  }

  String _formatDate(String dateString) {
    // 간단한 날짜 포맷팅 (실제로는 더 정교한 파싱이 필요할 수 있음)
    if (dateString.contains('T')) {
      return dateString.split('T')[0].replaceAll('-', '.');
    }
    return dateString;
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

  Widget _buildInquiryModal() {
    return Container(
      color: Colors.black.withOpacity(0.5), // 배경 어둡게
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 모달 헤더
                Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showInquiryModal = false;
                            _titleController.clear();
                            _contentController.clear();
                            _selectedInquiryType = '선택';
                          });
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.close,
                            color: AppColors.black,
                            size: 24,
                          ),
                        ),
                      ),
                      const Text(
                        '문의하기',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 9),
                    ],
                  ),
                ),
                // 모달 내용
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 문의유형
                    const Text(
                      '문의유형',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 13),
                    GestureDetector(
                      onTap: () {
                        _showInquiryTypeBottomSheet();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gray200),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedInquiryType,
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    _selectedInquiryType == '선택'
                                        ? AppColors.gray400
                                        : AppColors.black,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.gray400,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 13),
                    // 문의내용
                    const Text(
                      '문의내용',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 제목 입력
                    TextField(
                      controller: _titleController,
                      onChanged: (value) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: '제목을 입력해주세요.',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray300),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // 내용 입력
                    TextField(
                      controller: _contentController,
                      onChanged: (value) => setState(() {}),
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: '문의내용을 입력해주세요.\n확인 후 관리자가 답변 드립니다.',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray400,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray300),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 9),
                    // Tip 섹션
                    const Text(
                      'Tip. 시스템 오류 등의 기술적 문제를 겪으셨다면?\n 휴대폰 기종, 문제발생일, 상세내용을 함께 기입해주시면 정확한 안내에\n 도움이 됩니다.',
                      style: TextStyle(fontSize: 10, color: AppColors.black),
                    ),
                    const SizedBox(height: 24),
                    // 문의하기 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed:
                            _isFormValid()
                                ? () {
                                  _submitInquiry();
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isFormValid()
                                  ? AppColors.black
                                  : AppColors.gray400,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '문의하기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInquiryTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ...inquiryTypes.map(
                (type) => ListTile(
                  title: Text(
                    type['CATEGORY'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.gray900,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedInquiryType = type['CATEGORY'] ?? '';
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
