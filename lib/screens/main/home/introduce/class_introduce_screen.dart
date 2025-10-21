import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ClassIntroduceScreen extends StatefulWidget {
  const ClassIntroduceScreen({super.key});

  @override
  State<ClassIntroduceScreen> createState() => _ClassIntroduceScreenState();
}

class _ClassIntroduceScreenState extends State<ClassIntroduceScreen> {
  List<String> steps = [
    'assets/images/home/class/class_step_1.svg',
    'assets/images/home/class/class_step_2.svg',
    'assets/images/home/class/class_step_3.svg',
    'assets/images/home/class/class_step_4.svg',
    'assets/images/home/class/class_step_5.svg',
    'assets/images/home/class/class_step_6.svg',
    'assets/images/home/class/class_step_7.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '모임 서비스 소개', isBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 서비스 소개 섹션
            _buildServiceIntroduction(),
            const SizedBox(height: 80),
            // 운영 방식 소개 섹션
            _buildOperatingMethod(),
            const SizedBox(height: 20),
            // 7단계 가로 스크롤 카드
            _buildStepsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceIntroduction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/home/class/class_title.svg',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fitWidth,
        ),
        const SizedBox(height: 40),
        SvgPicture.asset('assets/images/home/class/class_description.svg'),
      ],
    );
  }

  Widget _buildOperatingMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '운영 방식 소개',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '모임은 이렇게 운영돼요',
          style: TextStyle(fontSize: 13, color: AppColors.gray600),
        ),
      ],
    );
  }

  Widget _buildStepsSection() {
    return SizedBox(
      height: 180, // 카드 높이에 맞게 조정
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: steps.length,
        padding: const EdgeInsets.symmetric(horizontal: 20), // 좌우 패딩 추가
        itemBuilder: (context, index) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.5, // 화면 너비의 80%로 조정
            margin: const EdgeInsets.only(right: 16),
            child: SvgPicture.asset(
              steps[index],
              fit: BoxFit.contain, // 가로로 꽉 차도록
            ),
          );
        },
      ),
    );
  }
}
