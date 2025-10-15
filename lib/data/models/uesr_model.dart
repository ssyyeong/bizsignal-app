class UserModel {
  int? id; //아이디
  String? fullName; //이름
  String? userName; //이메일
  String? memberType; //회원 유형
  String? phoneNumber; //휴대전화
  String? companyName; //기업명
  String? businessItem; //사업 아이템
  String? region; //지역
  String? region2; //지역2
  String? corporationYn; //법인 여부
  String? corporationDate; //법인 설립일
  // String? companyIndustry; //사업 분야
  String? profileImage; //프로필 이미지
  String? termsYn; //약관 동의 여부
  String? fcmToken; //FCM 토큰

  UserModel({
    this.id,
    this.fullName,
    this.userName,
    this.memberType,
    this.phoneNumber,
    this.companyName,
    this.businessItem,
    this.region,
    this.region2,
    this.corporationYn,
    this.corporationDate,
    // this.companyIndustry,
    this.profileImage,
    this.termsYn,
    this.fcmToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['APP_MEMBER_IDENTIFICATION_CODE'],
    fullName: json['FULL_NAME'],
    memberType: json['MEMBER_TYPE'],
    userName: json['USER_NAME'],
    phoneNumber: json['PHONE_NUMBER'],
    companyName: json['COMPANY_NAME'],
    businessItem: json['BUSINESS_ITEM'],
    region: json['REGION'],
    region2: json['REGION2'],
    corporationYn: json['CORPORATION_YN'],
    corporationDate: json['CORPORATION_DATE'],
    // companyIndustry: json['MATCHING_INFO']['COMPANY_INDUSTRY'],
    profileImage: json['PROFILE_IMAGE'],
    termsYn: json['TERMS_YN'],
    fcmToken: json['FCM_TOKEN'],
  );
}
