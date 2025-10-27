import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  List<dynamic> ownedBenefits = [];
  List<dynamic> expiredBenefits = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
    _fetchBenefits();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchBenefits() async {
    await ControllerBase(modelName: 'Benefit', modelId: 'benefit')
        .findAll({
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          setState(() {
            ownedBenefits.clear();
            expiredBenefits.clear();

            result['result']['rows'].forEach((benefit) {
              if ((benefit['EXPIRATION_DATE'] != null &&
                      DateTime.parse(
                        benefit['EXPIRATION_DATE'],
                      ).isBefore(DateTime.now())) ||
                  benefit['USED_YN'] == 'Y') {
                expiredBenefits.add(benefit);
              } else {
                ownedBenefits.add(benefit);
              }
            });
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          '혜택 관리',
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
              tabs: const [Tab(text: '보유 혜택'), Tab(text: '만료 혜택')],
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
    return Column(
      children: [
        // 보유 혜택 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            itemCount: ownedBenefits.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final benefit = ownedBenefits[index];
              return _buildBenefitCard(benefit, false);
            },
          ),
        ),
        // 페이지네이션
        _buildPagination(),
      ],
    );
  }

  Widget _buildExpiredBenefitsTab() {
    return Column(
      children: [
        // 만료 혜택 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            itemCount: expiredBenefits.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final benefit = expiredBenefits[index];
              return _buildBenefitCard(benefit, true);
            },
          ),
        ),
        // 페이지네이션
        _buildPagination(),
      ],
    );
  }

  Widget _buildBenefitCard(Map<String, dynamic> benefit, bool isExpired) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리
          Text(
            benefit['CATEGORY'],
            style: const TextStyle(fontSize: 12, color: AppColors.gray800),
          ),
          const SizedBox(height: 8),
          // 혜택 제목
          Text(
            '[${benefit['CATEGORY']}] ${benefit['NAME']}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isExpired ? AppColors.gray600 : AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          // 만료일 또는 상태
          Text(
            isExpired
                ? benefit['USED_YN'] == 'Y'
                    ? '${DateFormat('yyyy.MM.dd').format(DateTime.parse(benefit['UPDATED_AT']))} 사용완료'
                    : '${DateFormat('yyyy.MM.dd').format(DateTime.parse(benefit['EXPIRATION_DATE']))} 기간만료'
                : '${DateFormat('yyyy.MM.dd').format(DateTime.parse(benefit['EXPIRATION_DATE']))}까지',
            style: const TextStyle(fontSize: 12, color: AppColors.black),
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
