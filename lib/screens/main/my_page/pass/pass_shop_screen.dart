import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';

import 'package:bizsignal_app/constants/app_colors.dart';

class PassShopScreen extends StatefulWidget {
  const PassShopScreen({super.key});

  @override
  State<PassShopScreen> createState() => _PassShopScreenState();
}

class _PassShopScreenState extends State<PassShopScreen> {
  List<dynamic> passVoucherList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await ControllerBase(modelName: 'PassVoucher', modelId: 'pass_voucher')
        .findAll({
          'APP_MEMBER_IDENTIFICATION_CODE':
              context.read<UserProvider>().user.id,
        })
        .then((result) {
          setState(() {
            passVoucherList = result['result']['rows'];
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBarWidget(
        title: '비즈시그널 패스샵',
        isBackButton: true,
        backgroundColor: AppColors.gray100,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 정보 배너
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.gray200,
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
                        '원하는 이용 기간에 맞춰 ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray700,
                        ),
                      ),
                      Text(
                        '모임과 만남을 자유롭게 이용',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary500,
                        ),
                      ),
                      Text(
                        '하세요.',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          '자유롭게 선택',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '하고 이용해요!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      'assets/images/my_page/gift.svg',
                      width: 32,
                      height: 32,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // 이용패스 관리 링크
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        '이용패스 관리',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        'assets/images/icon/arrow_right.svg',
                        width: 16,
                        height: 16,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 이용 패스 섹션 헤더
                Text(
                  '이용 패스',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray700,
                  ),
                ),
                const SizedBox(height: 16),

                // 패스 옵션 리스트
                if (passVoucherList.isNotEmpty)
                  ...passVoucherList.asMap().entries.map((entry) {
                    int index = entry.key;
                    dynamic voucher = entry.value;
                    return Column(
                      children: [
                        _buildPassOptionCard(
                          '${voucher['MONTHS']}개월',
                          '${voucher['PRICE']?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} 원',
                          voucher['DISCOUNT_RATE'] != null &&
                                  voucher['DISCOUNT_RATE'] > 0
                              ? '${voucher['DISCOUNT_RATE']}%'
                              : null,
                        ),
                        if (index < passVoucherList.length - 1)
                          const SizedBox(height: 12),
                      ],
                    );
                  })
                else
                  // 기본 패스 옵션 (데이터가 없을 때)
                  Column(
                    children: [
                      _buildPassOptionCard('1개월', '100,000 원', null),
                      const SizedBox(height: 12),
                      _buildPassOptionCard('3개월', '200,000 원', '30%'),
                      const SizedBox(height: 12),
                      _buildPassOptionCard('6개월', '350,000 원', '42%'),
                      const SizedBox(height: 12),
                      _buildPassOptionCard('12개월', '600,000 원', '50%'),
                    ],
                  ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPassOptionCard(String duration, String price, String? discount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                duration,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
              if (discount != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    discount,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '모임/만남 무제한 이용',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
