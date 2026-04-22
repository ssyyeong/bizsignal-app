# 💼 비즈시그널 — 비즈니스 네트워킹 앱

Flutter 기반의 비즈니스 네트워킹 모바일 앱입니다.  
모임 서비스, 커피챗, 실시간 채팅, 캘린더 & 알림 기능을 제공합니다.

---

## 📱 주요 기능

- **모임 서비스** — 비즈니스 모임 생성 및 참여
- **커피챗** — 1:1 미팅 신청 및 관리
- **실시간 채팅** — Firebase Realtime Database 기반 채팅
- **캘린더 & 알림** — 일정 관리 및 푸시 알림

---

## 🛠 기술 스택

| 분류 | 기술 |
|------|------|
| App | Flutter (Dart) |
| 상태관리 | Provider |
| Backend | Node.js |
| 실시간 DB | Firebase Realtime Database |

---

## 🏗 프로젝트 구조

```
lib/
├── constants/         # 앱 색상, 테마 등 공통 상수
├── controller/        # 상태 및 비즈니스 로직
│   ├── base/          # 베이스 컨트롤러
│   └── custom/        # 기능별 커스텀 컨트롤러
├── data/              # 데이터 레이어
│   ├── models/        # 데이터 모델
│   ├── providers/     # Provider 상태 관리
│   └── region_data.dart
├── models/            # 도메인 모델 (login_model 등)
└── screens/           # UI 화면
    ├── auth/          # 로그인/회원가입
    └── main/          # 메인 기능 화면들
```

---

## ⚙️ 기술적 도전

### Firebase Realtime Database 기반 실시간 채팅 구현

Firebase Realtime Database를 연동해 채팅 메시지를 실시간으로 저장하고 화면에 반영하는 구조를 설계했습니다.

- 메시지 전송 시 Firebase에 즉시 저장
- `onValue` 스트림으로 채팅방 메시지 실시간 수신 및 UI 반영
- Provider를 통해 채팅 상태를 앱 전역에서 일관되게 관리

---

## 👤 개발 참여 인원

- 1인 개발 (서버 + 앱 전체)
- 기획 제외 설계·개발·배포 전 과정 단독 수행
