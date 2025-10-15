import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/controller/base/controller_base.dart';
import 'package:bizsignal_app/controller/custom/app_member_controller.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:bizsignal_app/screens/auth/login_screen.dart';
import 'package:bizsignal_app/screens/main/my_page/my_page_screen.dart';
import 'package:bizsignal_app/widgets/common_text_field.dart';
import 'package:bizsignal_app/widgets/common_toggle_button.dart';
import 'package:bizsignal_app/widgets/terms_agreement_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/app_bar_widget.dart';
import '../../../../data/region_data.dart';

class MemberInfoModifyScreen extends StatefulWidget {
  const MemberInfoModifyScreen({super.key});

  @override
  State<MemberInfoModifyScreen> createState() => _MemberInfoModifyScreenState();
}

class _MemberInfoModifyScreenState extends State<MemberInfoModifyScreen> {
  final _formKey = GlobalKey<FormState>();

  final _ceoController = TextEditingController();
  final _companyController = TextEditingController();
  final _itemController = TextEditingController();
  final _departmentController = TextEditingController();
  // 휴대전화 입력
  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _phone3Controller = TextEditingController();
  //설립일자
  final TextEditingController _dateController = TextEditingController();

  int _selectedTypeIndex = 0; // 0: 기업, 1: 기관
  String? region; // 활동 지역(광역시/도)
  String? region2; // 활동 지역(시/군/구)
  int _establishIndex = 0; // 0: 설립, 1: 미설립
  bool _agree = false;

  final List<String> _types = ['기업', '기관'];

  @override
  void initState() {
    super.initState();
    _ceoController.text = context.read<UserProvider>().user.fullName ?? '';
    _companyController.text =
        context.read<UserProvider>().user.companyName ?? '';
    _itemController.text = context.read<UserProvider>().user.businessItem ?? '';
    _phone1Controller.text =
        context.read<UserProvider>().user.phoneNumber?.substring(0, 3) ?? '';
    _phone2Controller.text =
        context.read<UserProvider>().user.phoneNumber?.substring(3, 7) ?? '';
    _phone3Controller.text =
        context.read<UserProvider>().user.phoneNumber?.substring(7, 11) ?? '';
    _dateController.text =
        context.read<UserProvider>().user.corporationDate ?? '';
    _selectedTypeIndex =
        context.read<UserProvider>().user.memberType == 'COMPANY' ? 0 : 1;
    _establishIndex =
        context.read<UserProvider>().user.corporationYn == 'Y' ? 0 : 1;
    region = context.read<UserProvider>().user.region ?? '';
    region2 = context.read<UserProvider>().user.region2 ?? '';
    _agree = context.read<UserProvider>().user.termsYn == 'Y';
  }

  @override
  void dispose() {
    _ceoController.dispose();
    _companyController.dispose();
    _itemController.dispose();
    super.dispose();
  }

  void _showTermsAgreementBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: TermsAgreementBottomSheet(
              onAgreeAll: () {
                setState(() {
                  _agree = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: '설립일 선택',
      fieldLabelText: '설립일',
      fieldHintText: '연-월-일',
      initialEntryMode: DatePickerEntryMode.calendar,
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // 회원정보 수정
  memberInfoModify() {
    Map<dynamic, dynamic> option = {
      'MEMBER_TYPE': _selectedTypeIndex == 0 ? 'COMPANY' : 'ORGANIZATION',
      'FULL_NAME': _ceoController.text,
      'PHONE_NUMBER':
          '${_phone1Controller.text}${_phone2Controller.text}${_phone3Controller.text}',
      'COMPANY_NAME': _companyController.text,
      'DEPARTMENT': _departmentController.text,
      'BUSINESS_ITEM': _itemController.text,
      'REGION': region,
      'REGION2': region2,
      'CORPORATION_YN': _establishIndex == 0 ? 'Y' : 'N', // 법인 설립 여부
      'CORPORATION_DATE': _dateController.text, // 설립날짜
      'TERMS_YN': 'Y',
    };

    //회원가입 진행
    ControllerBase(modelName: 'AppMember', modelId: 'app_member')
        .update(option)
        .then(
          (value) => {
            if (mounted)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('회원정보 수정이 완료되었습니다.')),
                ),
                //마이페이지 화면으로 이동
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyPageScreen()),
                ),
              },
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: '회원정보 수정', isBackButton: true),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '회원정보',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.gray700,
                  ),
                ),
                const SizedBox(height: 20),
                // 회원유형 토글버튼
                Row(
                  children: [
                    const Text(
                      '유형',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      'assets/images/icon/required.svg',
                      width: 12,
                      height: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CommonToggleButton(
                  options: _types,
                  selectedIndex: _selectedTypeIndex,
                  onChanged: (index) {
                    setState(() {
                      _selectedTypeIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // 이메일
                const Text(
                  '이메일',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.gray900,
                  ),
                ),

                const SizedBox(height: 8),
                CommonTextField(
                  controller: TextEditingController(
                    text: context.read<UserProvider>().user.userName,
                  ),
                  enabled: false,
                ),
                const SizedBox(height: 18),

                // 비밀번호
                const Text(
                  '비밀번호',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/change_password');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFF1E1E1E)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '비밀번호 변경',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 대표자명 or 회원명
                Row(
                  children: [
                    Text(
                      _selectedTypeIndex == 0 ? '대표자명' : '회원명',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      'assets/images/icon/required.svg',
                      width: 12,
                      height: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: _ceoController,
                  hintText:
                      _selectedTypeIndex == 0
                          ? '10자 이내로 입력해주세요.'
                          : '50자 이내로 입력해주세요.',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _selectedTypeIndex == 0
                          ? '대표자명을 입력해주세요'
                          : '회원명을 입력해주세요';
                    }
                    if (value.length > (_selectedTypeIndex == 0 ? 10 : 50)) {
                      return _selectedTypeIndex == 0
                          ? '10자 이내로 입력해주세요'
                          : '50자 이내로 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                // 휴대전화 입력
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '휴대전화',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: Color(0xFFFF6928),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // 첫번째 칸
                        Expanded(
                          child: TextField(
                            controller: _phone1Controller,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: '010',
                              hintStyle: const TextStyle(
                                color: AppColors.gray400,
                                fontSize: 13,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '-',
                          style: TextStyle(
                            color: AppColors.gray900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 두번째 칸
                        Expanded(
                          child: TextField(
                            controller: _phone2Controller,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '-',
                          style: TextStyle(
                            color: AppColors.gray900,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // 세번째 칸
                        Expanded(
                          child: TextField(
                            controller: _phone3Controller,
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: AppColors.border,
                      margin: const EdgeInsets.symmetric(vertical: 40),
                    ),
                  ],
                ),
                const Text(
                  '사업정보',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.gray700,
                  ),
                ),
                const SizedBox(height: 20),
                //기업명 or 기관명
                Row(
                  children: [
                    Text(
                      _selectedTypeIndex == 0 ? '기업명' : '기관명',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      'assets/images/icon/required.svg',
                      width: 12,
                      height: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: _companyController,
                  hintText:
                      _selectedTypeIndex == 0 ? '기업명을 입력해주세요' : '기관명을 입력해주세요',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return _selectedTypeIndex == 0
                          ? '기업명을 입력해주세요'
                          : '기관명을 입력해주세요';
                    }
                    if (value.length > 50) {
                      return '50자 이내로 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                // 기관 유형일 때만 담당 부서 표시
                if (_selectedTypeIndex == 1) ...[
                  // 담당 부서
                  Row(
                    children: [
                      const Text(
                        '담당 부서',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: AppColors.gray900,
                        ),
                      ),
                      const SizedBox(width: 2),
                      SvgPicture.asset(
                        'assets/images/icon/required.svg',
                        width: 12,
                        height: 12,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  CommonTextField(
                    controller: _departmentController,
                    hintText: '50자 이내로 입력해주세요.',
                    validator: (value) {
                      if (_selectedTypeIndex == 1) {
                        if (value == null || value.isEmpty) {
                          return '담당 부서를 입력해주세요';
                        }
                        if (value.length > 50) {
                          return '50자 이내로 입력해주세요.';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                ],
                // 사업 아이템
                Row(
                  children: [
                    const Text(
                      '사업 아이템',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.gray900,
                      ),
                    ),
                    const SizedBox(width: 2),
                    SvgPicture.asset(
                      'assets/images/icon/required.svg',
                      width: 12,
                      height: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CommonTextField(
                  controller: _itemController,
                  hintText: '사업 아이템을 입력해주세요.',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '사업 아이템을 입력해주세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                // 활동 지역(광역시/도)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '활동지역',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: region,
                                hint: const Text(
                                  '광역시/도',
                                  style: TextStyle(
                                    color: AppColors.gray400,
                                    fontSize: 14,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.gray400,
                                ),
                                isExpanded: true,
                                style: const TextStyle(
                                  color: AppColors.gray900,
                                  fontSize: 14,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    region = value;
                                  });
                                },
                                items:
                                    regions
                                        .map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: region2,
                                hint: const Text(
                                  '시/군/구',
                                  style: TextStyle(
                                    color: AppColors.gray400,
                                    fontSize: 14,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.gray400,
                                ),
                                isExpanded: true,
                                style: const TextStyle(
                                  color: AppColors.gray900,
                                  fontSize: 14,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    region2 = value;
                                  });
                                },
                                items:
                                    subRegions[region]
                                        ?.map(
                                          (e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 법인 설립 여부
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '법인 설립 여부',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CommonToggleButton(
                      options: ['설립', '미설립'],
                      selectedIndex: _establishIndex,
                      onChanged: (idx) {
                        setState(() {
                          _establishIndex = idx;
                        });
                      },
                      height: 36,
                      borderRadius: 8,
                      fontSize: 13,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // 설립날짜
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '설립날짜',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '*',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.gray900,
                        ),
                        decoration: InputDecoration(
                          hintText: '연도-월',
                          hintStyle: const TextStyle(
                            color: AppColors.gray400,
                            fontSize: 14,
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.gray400,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onTap: () async {
                          // 날짜 선택 로직
                          _pickDate();
                        },
                      ),
                    ),
                  ],
                ),
                // 약관동의
                GestureDetector(
                  onTap: () {
                    _showTermsAgreementBottomSheet();
                  },
                  child: Container(
                    height: 44,
                    margin: const EdgeInsets.symmetric(vertical: 32),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: _agree ? AppColors.primary50 : AppColors.gray100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _agree
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
                          '이용 약관 동의',
                          style: TextStyle(
                            color:
                                _agree ? AppColors.gray900 : AppColors.gray600,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 회원정보 수정 버튼
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        memberInfoModify();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('회원정보 수정이 완료되었습니다.')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '회원정보 수정',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
