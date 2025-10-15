import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';

import 'package:bizsignal_app/constants/app_colors.dart';

class PassScreen extends StatefulWidget {
  const PassScreen({super.key});

  @override
  State<PassScreen> createState() => _PassScreenState();
}

class _PassScreenState extends State<PassScreen> {
  Map<dynamic, dynamic> entitlementData = {};
  List<dynamic> paymentHistoryList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await ControllerBase(modelName: 'Entitlement', modelId: 'entitlement')
        .findAll({
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          if (result['result']['rows'].isNotEmpty) {
            setState(() {
              entitlementData = result['result']['rows'][0];
            });
            _fetchPaymentHistory();
          }
        });
  }

  void _fetchPaymentHistory() async {
    await ControllerBase(
          modelName: 'PaymentHistory',
          modelId: 'payment_history',
        )
        .findAll({
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          setState(() {
            paymentHistoryList = result['result']['rows'];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '이용패스 관리', isBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            // 메인 콘텐츠
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // 정보 배너
                    Container(
                      width: double.infinity,
                      height: 32,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                            '현재 ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray700,
                            ),
                          ),
                          Text(
                            '이용 중인 패스와 사용 내역',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary500,
                            ),
                          ),
                          Text(
                            '을 확인할 수 있어요.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.gray700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 패스 상태에 따른 콘텐츠
                    _buildPassContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassContent() {
    bool hasEntitlement = entitlementData.isNotEmpty;

    if (hasEntitlement) {
      // entitlementData가 있을 때: 이용패스 정보 표시
      return _buildPassInfo();
    } else {
      // entitlementData가 없을 때: 패스 없음 표시
      return Column(
        children: [
          _buildNoPassContent(),
          // 구분선 (전체 너비)
          Container(
            height: 8,
            color: AppColors.gray200,
            margin: const EdgeInsets.only(bottom: 24),
          ),
          // 이용/결제 내역 섹션
          _buildPaymentHistory(),
        ],
      );
    }
  }

  Widget _buildNoPassContent() {
    return Column(
      children: [
        // 패스없음 태그
        Container(
          height: 22,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.gray500,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '패스없음',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
            ),
          ),
        ),
        // 메인 콘텐츠
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/icon/ticket.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '이용중인 패스가 없습니다.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // 설명 텍스트
              Text(
                '비즈시그널 패스를 통해 의미있는 연결을 경험하세요!',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.gray600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // 비즈시그널 패스샵 버튼
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/pass_shop');
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.gray200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '비즈시그널 패스샵',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이용/결제 내역',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 40),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/icon/info_circle.svg',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '이용 내역이 없습니다.',
                    style: TextStyle(fontSize: 13, color: AppColors.gray500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassInfo() {
    // entitlementData가 있을 때의 UI (향후 구현)
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          Text(
            '이용패스 정보',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '현재 이용 중인 패스 정보가 여기에 표시됩니다.',
            style: TextStyle(fontSize: 14, color: AppColors.gray600),
          ),
        ],
      ),
    );
  }
}
