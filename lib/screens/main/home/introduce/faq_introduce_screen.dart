import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:flutter/material.dart';

class FaqIntroduceScreen extends StatefulWidget {
  const FaqIntroduceScreen({super.key});

  @override
  State<FaqIntroduceScreen> createState() => _FaqIntroduceScreenState();
}

class _FaqIntroduceScreenState extends State<FaqIntroduceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  final int _pageSize = 5;

  Set<int> expandedItems = {};

  List<dynamic> faqCategoryList = [];
  List<dynamic> faqItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchFaqCategoryList();
    _fetchFaqItems(category: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchFaqCategoryList() async {
    await ControllerBase(
      modelName: 'FaqCategory',
      modelId: 'faq_category',
    ).findAll({}).then((result) {
      setState(() {
        faqCategoryList =
            result['result']['rows']
                .map((category) => category['CATEGORY'])
                .toList();
        faqCategoryList.insert(0, '전체');
      });
    });
  }

  void _fetchFaqItems({required int category, int page = 0}) async {
    if (category == 0) {
      await ControllerBase(
        modelName: 'Faq',
        modelId: 'faq',
      ).findAll({'LIMIT': _pageSize, 'PAGE': page}).then((result) {
        setState(() {
          faqItems = result['result']['rows'];
          _totalItems =
              result['result']['count'] ?? result['result']['rows'].length;
          _totalPages = (_totalItems / _pageSize).ceil();
        });
      });
    } else {
      await ControllerBase(modelName: 'Faq', modelId: 'faq')
          .findAll({
            'FAQ_CATEGORY_IDENTIFICATION_CODE': category,
            'LIMIT': _pageSize,
            'PAGE': page,
          })
          .then((result) {
            setState(() {
              faqItems = result['result']['rows'];
              _totalItems =
                  result['result']['count'] ?? result['result']['rows'].length;
              _totalPages = (_totalItems / _pageSize).ceil();
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'FAQ',
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
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/support');
            },
            child: Container(
              width: 80,
              height: 28,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.gray300),
              ),
              child: const Center(
                child: Text(
                  '문의하기',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 질문 프롬프트 섹션
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: const Text(
                '비즈시그널, 어떻게 이용하나요?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
            ),
            // 구분선
            Container(height: 1, color: AppColors.gray900),
            // 탭 바
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  ...faqCategoryList.map(
                    (category) => _buildTabButton(
                      category,
                      faqCategoryList.indexOf(category),
                    ),
                  ),
                ],
              ),
            ),
            // FAQ 목록
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: faqItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final faq = faqItems[index];
                final isExpanded = expandedItems.contains(index);
                return _buildFaqItem(faq, index, isExpanded);
              },
            ),
            // 하단 여백 (페이지네이션 공간 확보)
            if (_totalPages > 1) const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar:
          _totalPages > 1 && _totalItems > 5
              ? Container(
                color: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _buildPagination(),
              )
              : null,
    );
  }

  Widget _buildFaqItem(Map<String, dynamic> faq, int index, bool isExpanded) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _toggleExpansion(index),
          child: Container(
            padding: const EdgeInsets.only(top: 21, bottom: 16),
            child: Row(
              children: [
                Text(
                  '[${faq['CATEGORY']}]',
                  style: const TextStyle(fontSize: 14, color: AppColors.black),
                ),
                const SizedBox(width: 8),
                // 질문
                Expanded(
                  child: Text(
                    faq['QUESTION'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.black,
                    ),
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
        // 답변 (확장 시에만 표시)
        if (isExpanded) ...[
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.gray200,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              faq['ANSWER'],
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.gray700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _toggleExpansion(int index) {
    setState(() {
      if (expandedItems.contains(index)) {
        expandedItems.remove(index);
      } else {
        expandedItems.add(index);
      }
    });
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
    _fetchFaqItems(page: page - 1, category: _tabController.index);
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
        setState(() {
          _currentPage = 1; // 탭 변경 시 첫 페이지로 리셋
        });
        _fetchFaqItems(category: index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 11),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.black : AppColors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.gray300,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? AppColors.white : AppColors.gray700,
            ),
          ),
        ),
      ),
    );
  }
}
