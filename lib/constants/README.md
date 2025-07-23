# 색상 시스템 가이드

이 폴더는 BizSignal 앱에서 사용하는 모든 색상값들을 체계적으로 관리합니다.

## 파일 구조

- `app_colors.dart` - 모든 색상값 정의
- `app_theme.dart` - Material 테마 설정
- `color_examples.dart` - 색상 사용 예시
- `README.md` - 이 파일

## 색상 사용법

### 1. 기본 사용법

```dart
import 'package:flutter/material.dart';
import 'constants/app_colors.dart';

// 색상 사용 예시
Container(
  color: AppColors.primary,
  child: Text(
    'Primary 색상 텍스트',
    style: TextStyle(color: AppColors.white),
  ),
)
```

### 2. 테마 사용법

```dart
import 'package:flutter/material.dart';
import 'constants/app_theme.dart';

// MaterialApp에서 테마 적용
MaterialApp(
  theme: AppTheme.lightTheme,
  // 또는 다크 테마
  // theme: AppTheme.darkTheme,
)
```

### 3. 색상 카테고리

#### Primary Colors (주요 색상)

- `AppColors.primary` - 메인 브랜드 색상
- `AppColors.primaryLight` - 밝은 버전
- `AppColors.primaryDark` - 어두운 버전

#### Secondary Colors (보조 색상)

- `AppColors.secondary` - 보조 브랜드 색상
- `AppColors.secondaryLight` - 밝은 버전
- `AppColors.secondaryDark` - 어두운 버전

#### Semantic Colors (의미론적 색상)

- `AppColors.success` - 성공 상태
- `AppColors.error` - 오류 상태
- `AppColors.warning` - 경고 상태
- `AppColors.info` - 정보 상태

#### Brand Colors (브랜드 특화 색상)

- `AppColors.brandBlue` - 브랜드 블루
- `AppColors.brandGreen` - 브랜드 그린
- `AppColors.brandOrange` - 브랜드 오렌지
- `AppColors.brandPurple` - 브랜드 퍼플

#### Status Colors (상태 색상)

- `AppColors.online` - 온라인 상태
- `AppColors.offline` - 오프라인 상태
- `AppColors.busy` - 바쁨 상태
- `AppColors.away` - 자리비움 상태

#### Gray Scale (회색 스케일)

- `AppColors.gray50` ~ `AppColors.gray900` - 50부터 900까지

#### Text Colors (텍스트 색상)

- `AppColors.textPrimary` - 주요 텍스트
- `AppColors.textSecondary` - 보조 텍스트
- `AppColors.textTertiary` - 3차 텍스트
- `AppColors.textInverse` - 반전 텍스트

### 4. 실제 사용 예시

#### 버튼 스타일링

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
  ),
  onPressed: () {},
  child: Text('Primary Button'),
)
```

#### 카드 스타일링

```dart
Card(
  color: AppColors.surface,
  child: Container(
    padding: EdgeInsets.all(16),
    child: Text(
      '카드 내용',
      style: TextStyle(color: AppColors.textPrimary),
    ),
  ),
)
```

#### 상태 표시

```dart
Container(
  width: 12,
  height: 12,
  decoration: BoxDecoration(
    color: AppColors.online,
    shape: BoxShape.circle,
  ),
)
```

#### 배경과 텍스트

```dart
Container(
  color: AppColors.background,
  child: Text(
    '배경 텍스트',
    style: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
    ),
  ),
)
```

### 5. 색상 가이드 확인

색상 가이드를 확인하려면 `ColorGuideWidget`을 사용하세요:

```dart
import 'constants/color_examples.dart';

// 라우트에 추가
'/color-guide': (context) => const ColorGuideWidget(),
```

### 6. 새로운 색상 추가

새로운 색상을 추가할 때는 `app_colors.dart` 파일에 추가하고, 적절한 카테고리에 배치하세요:

```dart
// 새로운 브랜드 색상 예시
static const Color brandTeal = Color(0xFF0D9488);
```

### 7. 주의사항

- 하드코딩된 색상값 사용을 피하세요
- 항상 `AppColors` 클래스의 색상을 사용하세요
- 색상 변경이 필요할 때는 `app_colors.dart` 파일만 수정하세요
- 다크 테마 지원을 고려하여 색상을 선택하세요

### 8. 색상 팔레트

현재 사용 중인 주요 색상들:

- **Primary**: #4A90E2 (파란색 계열)
- **Secondary**: #6C757D (회색 계열)
- **Accent**: #FF6B35 (오렌지 계열)
- **Success**: #28A745 (녹색 계열)
- **Error**: #DC3545 (빨간색 계열)
- **Warning**: #FFC107 (노란색 계열)
- **Info**: #17A2B8 (청록색 계열)
