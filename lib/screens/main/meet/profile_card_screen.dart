import 'dart:convert';

import 'package:bizsignal_app/controller/custom/profile_card_controller.dart';
import 'package:bizsignal_app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:bizsignal_app/constants/app_colors.dart';
import 'package:bizsignal_app/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';

class ProfileCardScreen extends StatefulWidget {
  const ProfileCardScreen({super.key});

  @override
  State<ProfileCardScreen> createState() => _ProfileCardScreenState();
}

class _ProfileCardScreenState extends State<ProfileCardScreen> {
  bool _isMeetingEnabled = true;
  final List<String> _keywords = [
    '투자/자금 유치',
    '마케팅/프로모션',
    '정부지원사업',
    '해외진출/수출입',
    '세무/법무/회계',
    'R&D(IT&S/W)',
    '경영/사업 전략',
    '프라이빗 멘토링',
    '부동산/공간',
    '오픈이노베이션/MOU',
  ];
  final Set<String> _selectedKeywords = {'투자/자금 유치'};
  final TextEditingController _introductionController = TextEditingController();

  XFile? img;
  final ImagePicker picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        img = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  void _saveProfileCard() async {
    File image = (img != null) ? File(img!.path) : File('');

    Map<String, dynamic> data = {
      'APP_MEMBER_IDENTIFICATION_CODE': 1,
      'MEETING_REQUEST_YN': _isMeetingEnabled ? 'Y' : 'N',
      'KEYWORD_LIST': jsonEncode(_selectedKeywords.toList()),
      'INTRODUCTION': _introductionController.text,
    };

    await ProfileCardController().profileCardUpload(data, image).then((result) {
      if (result['status'] == 200) {
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
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
      appBar: AppBarWidget(title: '프로필카드 설정', isBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 만남 신청 받기 섹션
              _buildMeetingSection(),
              const SizedBox(height: 24),
              Divider(color: AppColors.gray200, height: 1),
              const SizedBox(height: 24),

              // 기본 정보 섹션
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              Divider(color: AppColors.gray200, height: 1),
              const SizedBox(height: 24),

              // 프로필 이미지 섹션
              _buildProfileImageSection(),
              const SizedBox(height: 24),
              Divider(color: AppColors.gray200, height: 1),
              const SizedBox(height: 24),

              // 대화 주제 키워드 섹션
              _buildKeywordsSection(),
              const SizedBox(height: 24),
              Divider(color: AppColors.gray200, height: 1),
              const SizedBox(height: 24),

              // 한줄 소개 섹션
              _buildIntroductionSection(),
              const SizedBox(height: 32),

              // 하단 안내 텍스트
              const Center(
                child: Text(
                  '등록 이후 my page에서 수정이 가능합니다.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.gray600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child:
                // 저장 버튼
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      _saveProfileCard();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeetingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '만남 신청 받기',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Expanded(
                child: Text(
                  '활성화시, 만남 리스트에 프로필카드가 공개되며\n신청을 받을 수 있습니다.',
                  style: TextStyle(fontSize: 12, color: AppColors.gray600),
                ),
              ),
              Transform.scale(
                scale: 0.7, // 크기를 80%로 줄임 (0.5~1.5 사이 값 조절 가능)
                child: Switch(
                  value: _isMeetingEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isMeetingEnabled = value;
                    });
                  },
                  activeTrackColor: AppColors.primary500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '기본 정보',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '기본정보는 마이페이지> 회원정보 에서 수정이 가능합니다.',
            style: TextStyle(fontSize: 12, color: AppColors.gray600),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  '기업명',
                  context.watch<UserProvider>().user.companyName ?? '',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  '사업 아이템',
                  context.watch<UserProvider>().user.businessItem ?? '',
                ),
                const SizedBox(height: 4),
                _buildInfoRow(
                  '활동 지역',
                  context.watch<UserProvider>().user.region ?? '',
                ),
                const SizedBox(height: 4),
                _buildInfoRow('사업 분야', '사업 분야 없음'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.gray600),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, color: AppColors.gray700),
        ),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '프로필 이미지',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '공적 용도로 사용 가능한 신뢰감 있는 프로필 사진이면 좋아요.',
            style: TextStyle(fontSize: 12, color: AppColors.gray600),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              getImage(ImageSource.gallery);
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.gray200),
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  img != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(img!.path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Icon(
                        Icons.add,
                        size: 24,
                        color: AppColors.gray900,
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeywordsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '대화 주제 키워드',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '만남 후, 나눌 주요 주제를 선택해주세요. (다중 선택가능)',
            style: TextStyle(fontSize: 12, color: AppColors.gray600),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _keywords.map((keyword) {
                  final isSelected = _selectedKeywords.contains(keyword);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedKeywords.remove(keyword);
                        } else {
                          _selectedKeywords.add(keyword);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color:
                              isSelected
                                  ? AppColors.primary500
                                  : AppColors.gray200,
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        keyword,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color:
                              isSelected
                                  ? AppColors.primary500
                                  : AppColors.gray600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroductionSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '한줄 소개',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _introductionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: '프로필카드에 노출할 간단 소개를 입력 해보세요.',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: AppColors.gray400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.gray200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.gray200),
              ),

              filled: true,
              fillColor: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
