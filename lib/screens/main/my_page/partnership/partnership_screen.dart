import 'dart:convert';

import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/screens/main/my_page/partnership/partnership_detail_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/partnership/partnership_inquiry_screen.dart';
import 'package:bizsignal_app/widgets/empty_state.dart';
import 'package:flutter/material.dart';

class PartnershipScreen extends StatefulWidget {
  const PartnershipScreen({super.key});

  @override
  State<PartnershipScreen> createState() => _PartnershipScreenState();
}

class _PartnershipScreenState extends State<PartnershipScreen> {
  // 카테고리 필터
  String selectedCategory = '전체';
  final List<String> categories = ['전체', '창업', 'SaaS/CRM', '클라우드/AWS'];

  List<dynamic> coalitionList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchData() async {
    await ControllerBase(
      modelName: 'Coalition',
      modelId: 'coalition',
    ).findAll({}).then((result) {
      setState(() {
        coalitionList = result['result']['rows'];
      });
    });
  }

  // 필터링된 리스트 가져오기
  List<dynamic> get filteredList {
    if (selectedCategory == '전체') {
      return coalitionList;
    }
    return coalitionList.where((item) {
      final itemCategory = item['CATEGORY'] ?? '';
      return itemCategory == selectedCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredList;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          '제휴 솔루션',
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PartnershipInquiryScreen(),
                  ),
                );
              },
              child: Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '기업 제휴 문의',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray700,
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 카테고리 드롭다운
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: GestureDetector(
              onTap: _openCategoryBottomSheet,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCategory,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray900,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.gray700,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // coalitionList 카드 리스트
          Expanded(
            child:
                filtered.isEmpty
                    ? const EmptyState(title: '제휴 솔루션이 없습니다.')
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => PartnershipDetailScreen(
                                        coalitionId:
                                            item['COALITION_IDENTIFICATION_CODE'] ??
                                            item['coalition_identification_code'],
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      child: Image.network(
                                        jsonDecode(item['IMAGE'])[0] ?? '',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      item['TITLE'] ?? '',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color:
                                                            AppColors.gray900,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.chevron_right,
                                                      size: 20,
                                                      color: AppColors.gray700,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 28,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  '신청/문의',
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['BENEFIT'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.gray700,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              border: Border.all(
                                                color: AppColors.border,
                                              ),
                                            ),
                                            child: Text(
                                              item['CATEGORY'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: AppColors.gray700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _openCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...categories.map((c) {
                  final bool isSelected = c == selectedCategory;
                  return ListTile(
                    title: Text(
                      c,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isSelected ? AppColors.primary : AppColors.gray900,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    trailing:
                        isSelected
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : null,
                    onTap: () {
                      setState(() => selectedCategory = c);
                      Navigator.of(context).pop();
                    },
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
