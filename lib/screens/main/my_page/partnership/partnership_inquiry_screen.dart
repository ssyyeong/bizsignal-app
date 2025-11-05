import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/widgets/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PartnershipInquiryScreen extends StatefulWidget {
  const PartnershipInquiryScreen({super.key});

  @override
  State<PartnershipInquiryScreen> createState() =>
      _PartnershipInquiryScreenState();
}

class _PartnershipInquiryScreenState extends State<PartnershipInquiryScreen> {
  final List<String> categories = ['전체', '창업', 'SaaS/CRM', '클라우드/AWS'];
  String? selectedCategory;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phone1Controller = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();
  final TextEditingController phone3Controller = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    emailController.text = user.userName ?? '';
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    phone3Controller.dispose();
    contentController.dispose();
    super.dispose();
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
                ...categories.map((category) {
                  final bool isSelected = category == selectedCategory;
                  return ListTile(
                    title: Text(
                      category,
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
                      setState(() => selectedCategory = category);
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

  void submitInquiry() async {
    if (selectedCategory == null ||
        emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        phone1Controller.text.isEmpty ||
        phone2Controller.text.isEmpty ||
        phone3Controller.text.isEmpty ||
        contentController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('모든 필수 항목을 입력해주세요.')));
      return;
    }

    try {
      await ControllerBase(
            modelName: 'PartnershipInquiry',
            modelId: 'partnership_inquiry',
          )
          .create({
            'CATEGORY': selectedCategory,
            'EMAIL': emailController.text,
            'MANAGER': nameController.text,
            'PHONE_NUMBER':
                '${phone1Controller.text}${phone2Controller.text}${phone3Controller.text}',
            'DESCRIPTION': contentController.text,
          })
          .then((result) {
            ToastWidget.showSuccess(context, message: '문의가 접수되었습니다.');
            Navigator.of(context).pop();
          });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('문의 접수에 실패했습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          '기업 제휴 문의',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // 솔루션 구분
            _buildLabel('솔루션 구분', isRequired: true),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: _openCategoryBottomSheet,
              child: Container(
                height: 33,
                padding: const EdgeInsets.symmetric(horizontal: 9),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.black),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          selectedCategory ?? '선택',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.gray700,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 9),
            // 이메일
            _buildLabel('이메일', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              style: const TextStyle(fontSize: 13, color: AppColors.gray900),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 9),
            // 담당자명
            _buildLabel('담당자명', isRequired: true),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              maxLength: 10,
              style: const TextStyle(fontSize: 13, color: AppColors.gray900),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                hintText: '10자 이내로 입력해주세요.',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.gray400,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 9),
            // 연락처
            _buildLabel('연락처', isRequired: true),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: phone1Controller,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.gray900,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 15, color: AppColors.gray900),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: phone2Controller,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray900,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 14, color: AppColors.gray700),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: phone3Controller,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray900,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: contentController,
              maxLines: 6,
              style: const TextStyle(fontSize: 12, color: AppColors.gray900),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                hintText: '기업 제휴 문의 내용을 상세히 입력해주세요.\n확인 후 담당자가 연락 드리겠습니다.',
                hintStyle: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray400,
                  height: 1.5,
                ),
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
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
              onPressed: submitInquiry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                elevation: 0,
                disabledBackgroundColor: AppColors.gray300,
                disabledForegroundColor: AppColors.gray700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '문의 하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.gray900,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          SvgPicture.asset('assets/images/icon/required.svg'),
        ],
      ],
    );
  }
}
