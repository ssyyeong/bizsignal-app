import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:bizsignal_app/widgets/primary_button.dart';
import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ClassIntroductionScreen extends StatefulWidget {
  final String? initialIntroduction;

  const ClassIntroductionScreen({super.key, this.initialIntroduction});

  @override
  State<ClassIntroductionScreen> createState() =>
      _ClassIntroductionScreenState();
}

class _ClassIntroductionScreenState extends State<ClassIntroductionScreen> {
  final TextEditingController _introductionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialIntroduction != null) {
      _introductionController.text = widget.initialIntroduction!;
    }
  }

  @override
  void dispose() {
    _introductionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(title: '한줄 소개', isBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // 메인 콘텐츠
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPromptText(),
                      const SizedBox(height: 32),
                      _buildTextInputField(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: '입력 완료',
                onPressed:
                    _introductionController.text.isNotEmpty
                        ? () {
                          Navigator.pop(context, _introductionController.text);
                        }
                        : null,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromptText() {
    return const Text(
      '한줄 소개를 입력해주세요',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.gray900,
      ),
    );
  }

  Widget _buildTextInputField() {
    return Container(
      height: 430,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _introductionController,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
          hintText: '예) 함께 성장하며 네트워킹할 수 있는 모임입니다.',
          hintStyle: TextStyle(color: AppColors.gray600, fontSize: 14),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        onChanged: (_) {
          setState(() {});
        },
      ),
    );
  }
}
