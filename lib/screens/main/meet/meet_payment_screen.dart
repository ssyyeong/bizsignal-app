import 'package:bizsignal_app/widgets/toast_widget.dart';
import 'package:intl/intl.dart';

import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/alert_modal_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MeetPaymentScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  final String receiverId;
  final String greeting;
  const MeetPaymentScreen({
    super.key,
    required this.profileData,
    required this.receiverId,
    required this.greeting,
  });

  @override
  State<MeetPaymentScreen> createState() => _MeetPaymentScreenState();
}

class _MeetPaymentScreenState extends State<MeetPaymentScreen> {
  String paymentMethod = '신용카드';
  bool isAgree = false;

  @override
  void initState() {
    super.initState();
  }

  void payment() {
    if (!isAgree) {
      // 구매 동의가 안된 경우
      ToastWidget.showError(context, message: '구매에 동의해주세요.');
      return;
    }

    // 결제 완료 후 모달 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertModalFactory.mentoringMeetingComplete(
            context: context,
            onConfirm: () {
              Navigator.of(context).pop(); // 모달 닫기
              Navigator.of(context).pop(); // 결제 화면 닫기
              // 여기에 결제 완료 후 처리 로직 추가
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: '결제 하기', isBackButton: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.gray200, height: 25),
                  const SizedBox(height: 12),
                  // 멘토링 티켓 정보
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '멘토링 티켓(기본형)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        NumberFormat(
                          '#,###',
                        ).format(widget.profileData['TICKE_PRICE'] ?? 0),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '서비스 상세정보',
                        style: TextStyle(fontSize: 12, color: AppColors.black),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: AppColors.gray200, height: 25),
                  const SizedBox(height: 12),
                  // 이용기간
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '이용기간',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                      const Text(
                        '신청 시 차감',
                        style: TextStyle(fontSize: 12, color: AppColors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Divider(color: AppColors.gray200, height: 25),
                  const SizedBox(height: 12),

                  // 결제 수단
                  const Text(
                    '결제 수단',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPaymentMethodButton(
                          '신용카드',
                          isSelected: paymentMethod == '신용카드',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildPaymentMethodButton(
                          '계좌이체',
                          isSelected: paymentMethod == '계좌이체',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          // 구매 동의
          GestureDetector(
            onTap: () {
              setState(() {
                isAgree = !isAgree;
              });
            },
            child: Container(
              height: 44,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isAgree ? AppColors.primary50 : AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  isAgree
                      ? SvgPicture.asset(
                        'assets/images/icon/check_orange.svg',
                        width: 20,
                        height: 20,
                      )
                      : SvgPicture.asset(
                        'assets/images/icon/check_gray.svg',
                        width: 20,
                      ),
                  const SizedBox(width: 8),
                  Text(
                    '구매에 동의합니다.',
                    style: TextStyle(
                      color: isAgree ? AppColors.gray900 : AppColors.gray600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 만남 신청 버튼 - 하단 고정
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  payment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '결제 하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodButton(String text, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          paymentMethod = text;
        });
      },
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? AppColors.primary : AppColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
