import 'dart:convert';

import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartnershipDetailScreen extends StatefulWidget {
  final dynamic coalitionId;

  const PartnershipDetailScreen({super.key, required this.coalitionId});

  @override
  State<PartnershipDetailScreen> createState() =>
      _PartnershipDetailScreenState();
}

class _PartnershipDetailScreenState extends State<PartnershipDetailScreen> {
  Map<String, dynamic> coalitionData = {};
  bool isLoading = true;
  bool isApplied = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _checkApply();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchData() async {
    try {
      await ControllerBase(modelName: 'Coalition', modelId: 'coalition')
          .findOne({'COALITION_IDENTIFICATION_CODE': widget.coalitionId})
          .then((result) {
            setState(() {
              coalitionData = result['result'];
              isLoading = false;
            });
          });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _checkApply() async {
    await ControllerBase(
          modelName: 'CoalitionApplication',
          modelId: 'coalition_application',
        )
        .findAll({
          'COALITION_IDENTIFICATION_CODE': widget.coalitionId,
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          if (result['result'].isNotEmpty) {
            setState(() {
              isApplied = true;
            });
          }
        });
  }

  void applyPartnership() async {
    await ControllerBase(
          modelName: 'CoalitionApplication',
          modelId: 'coalition_application',
        )
        .create({
          'COALITION_IDENTIFICATION_CODE': widget.coalitionId,
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '회원 정보로 해당 제휴솔루션\n 신청/문의가 접수 완료 되었습니다.',

                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray900,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '확인 후 담당자가 연락 드리겠습니다.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gray400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '확인',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
              child: Icon(
                Icons.chevron_left,
                size: 24,
                color: AppColors.gray900,
              ),
            ),
          ),
          backgroundColor: AppColors.white,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final imageList =
        coalitionData['IMAGE'] != null
            ? jsonDecode(coalitionData['IMAGE'])
            : <String>[];

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          coalitionData['TITLE'] ?? '제휴 솔루션',
          style: const TextStyle(
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
              onTap: () {},
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            // 솔루션 오버뷰 카드
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child:
                      imageList.isNotEmpty
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageList[0],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox();
                              },
                            ),
                          )
                          : const SizedBox(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coalitionData['TITLE'] ?? '',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        coalitionData['BENEFIT'] ?? '',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if ((coalitionData['CATEGORY'] ?? '')
                          .toString()
                          .isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            coalitionData['CATEGORY'] ?? '',
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
            const SizedBox(height: 21),
            // 솔루션 상세 정보 섹션
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '솔루션 상세 정보',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 11),
                Text(
                  coalitionData['DESCRIPTION'] ?? '',
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (isApplied) {
                  return;
                }
                // 신청/문의 접수 로직
                applyPartnership();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isApplied ? AppColors.gray300 : AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isApplied ? '신청/문의 접수 완료' : '신청/문의 접수',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isApplied ? AppColors.gray700 : AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
