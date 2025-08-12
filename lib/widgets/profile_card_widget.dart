import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String companyName;
  final dynamic profileImage;
  final String introduction;
  final List<dynamic> keywordList;
  final bool isOfficialMentor;
  final VoidCallback? goToProfileDetail;

  const ProfileCard({
    super.key,
    required this.name,
    required this.companyName,
    required this.profileImage,
    required this.introduction,
    required this.keywordList,
    this.isOfficialMentor = false,
    this.goToProfileDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: goToProfileDetail,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 태그들
            _buildTopTags(),
            const SizedBox(height: 12),
            // 프로필 이미지와 기본 정보
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 이미지
                _buildProfileImage(),
                const SizedBox(width: 12),
                // 이름, 회사명, 버튼이 한 줄에
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildNameAndTitle()),
                          _buildApplyButton(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // 설명
                      Text(
                        introduction,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // 전문 분야 태그들
                      _buildExpertiseTags(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOfficialMentor ? Colors.transparent : AppColors.gray300,
              width: 2,
            ),
            gradient:
                isOfficialMentor
                    ? const LinearGradient(
                      colors: [Color(0xFFFF6928), Color(0xFFED28FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color: isOfficialMentor ? null : AppColors.gray300,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(profileImage),
            ),
          ),
        ),
        if (isOfficialMentor)
          Positioned(
            top: 4,
            left: 4,
            child: SizedBox(
              width: 12,
              height: 12,
              child: SvgPicture.asset('assets/images/icon/badge.svg'),
            ),
          ),
      ],
    );
  }

  Widget _buildTopTags() {
    return Row(
      children: [
        if (isOfficialMentor)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              border: Border.all(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ShaderMask(
              shaderCallback:
                  (bounds) => const LinearGradient(
                    colors: [Color(0xFFED28FF), Color(0xFFFF6928)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    transform: GradientRotation(99 * 3.14159 / 180), // 99도 회전
                  ).createShader(bounds),
              child: const Text(
                '공식 멘토',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.5, // line-height: 150%
                  color: Colors.white, // shaderMask가 적용되려면 흰색이어야 함
                ),
              ),
            ),
          ),
        if (isOfficialMentor) const SizedBox(width: 4),
        if (isOfficialMentor)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              border: Border.all(color: AppColors.gray200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ShaderMask(
              shaderCallback:
                  (bounds) => const LinearGradient(
                    colors: [Color(0xFFED28FF), Color(0xFFFF6928)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    transform: GradientRotation(99 * 3.14159 / 180), // 99도 회전
                  ).createShader(bounds),
              child: const Text(
                '멘토링 티켓 구매',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.5, // line-height: 150%
                  color: Colors.white, // shaderMask가 적용되려면 흰색이어야 함
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNameAndTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이름과 화살표
        GestureDetector(
          onTap: goToProfileDetail,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
              SvgPicture.asset('assets/images/icon/arrow_right.svg'),
            ],
          ),
        ),
        const SizedBox(height: 2),
        //회사명
        Text(
          companyName,
          style: const TextStyle(fontSize: 11, color: AppColors.gray600),
        ),
      ],
    );
  }

  Widget _buildExpertiseTags() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children:
          keywordList
              .map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.gray700,
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: 80,
      height: 28,
      child: ElevatedButton(
        onPressed: goToProfileDetail,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          minimumSize: const Size(44, 28), // min-width: 44px
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '만남신청',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
