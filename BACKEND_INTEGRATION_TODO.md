# 백엔드 연동 TODO 리스트

## 📋 개요
Flutter 앱과 Node.js 백엔드 API 연동을 위한 작업 목록

## 🎯 Phase 1: 기본 설정 및 인프라 (1-2일)

### 1.1 환경 설정
- [ ] Flutter 앱에 HTTP 클라이언트 패키지 추가 (`http`, `dio` 중 선택)
- [ ] 백엔드 API 기본 URL 설정 (개발/프로덕션 환경 분리)
- [ ] 환경 변수 관리 설정 (`.env` 파일 또는 Flutter 환경 설정)

### 1.2 네트워크 레이어 구축
- [ ] API 서비스 클래스 생성 (`lib/core/network/api_service.dart`)
- [ ] HTTP 클라이언트 설정 (타임아웃, 헤더, 인터셉터 등)
- [ ] 에러 핸들링 클래스 생성
- [ ] 응답 모델 클래스 생성

### 1.3 상태 관리 설정
- [ ] 상태 관리 라이브러리 선택 (Provider, Riverpod, Bloc 등)
- [ ] 전역 상태 관리 구조 설계
- [ ] 로딩/에러 상태 관리

## 🎯 Phase 2: 인증 시스템 연동 (2-3일)

### 2.1 Firebase Auth 연동
- [ ] Firebase Auth 패키지 추가 및 설정
- [ ] 로그인/회원가입 화면에서 Firebase Auth 사용
- [ ] 토큰 관리 및 저장 (SharedPreferences 또는 Secure Storage)
- [ ] 자동 로그인 기능 구현

### 2.2 백엔드 인증 연동
- [ ] Firebase ID 토큰을 백엔드로 전송하는 API 구현
- [ ] 백엔드에서 Firebase Admin SDK로 토큰 검증
- [ ] JWT 토큰 발급 및 관리
- [ ] API 요청 시 인증 토큰 자동 첨부

### 2.3 인증 상태 관리
- [ ] 로그인/로그아웃 상태 전역 관리
- [ ] 인증이 필요한 화면 보호 (Route Guard)
- [ ] 토큰 만료 시 자동 로그아웃

## 🎯 Phase 3: 게임 데이터 연동 (2-3일)

### 3.1 게임 목록 연동
- [ ] `lib/features/games/screens/games_screen.dart` 수정
- [ ] `GET /api/games` API 호출 구현
- [ ] 로딩 상태 및 에러 처리
- [ ] 게임 데이터 모델 클래스 생성/수정

### 3.2 게임 상세 정보 연동
- [ ] `lib/features/games/screens/game_detail_screen.dart` 수정
- [ ] `GET /api/games/:id` API 호출 구현
- [ ] 게임 상세 정보 표시 (팀 정보, 스코어, 일정 등)
- [ ] 실시간 업데이트 기능 (WebSocket 또는 폴링)

### 3.3 게임 생성/수정 기능
- [ ] 게임 생성 화면 구현
- [ ] `POST /api/games` API 연동
- [ ] 게임 수정 기능 구현
- [ ] 이미지 업로드 기능 (게임 사진, 팀 로고 등)

## 🎯 Phase 4: 공지사항 연동 (2일)

### 4.1 공지사항 목록 연동
- [ ] `lib/features/announcements/screens/announcements_screen.dart` 수정
- [ ] `GET /api/announcements` API 호출 구현
- [ ] 검색 및 필터링 기능 연동
- [ ] 페이지네이션 구현

### 4.2 공지사항 상세 연동
- [ ] `lib/features/announcements/screens/announcement_detail_screen.dart` 수정
- [ ] `GET /api/announcements/:id` API 호출 구현
- [ ] 조회수 증가 기능 (`PUT /api/announcements/:id/view`)
- [ ] 첨부파일 다운로드 기능

### 4.3 공지사항 관리 기능
- [ ] 공지사항 작성 화면 구현
- [ ] `POST /api/announcements` API 연동
- [ ] 공지사항 수정/삭제 기능
- [ ] 파일 첨부 기능

## 🎯 Phase 5: 통계 데이터 연동 (2일)

### 5.1 통계 화면 연동
- [ ] `lib/features/statistics/screens/statistics_screen.dart` 수정
- [ ] `GET /api/statistics` API 호출 구현
- [ ] 사용자별 통계 연동 (`GET /api/statistics?user_id=xxx`)
- [ ] 팀별 통계 연동 (`GET /api/statistics?team_id=xxx`)

### 5.2 상위 순위 연동
- [ ] 상위 득점자 연동 (`GET /api/statistics/top-scorers`)
- [ ] 상위 어시스트 연동 (`GET /api/statistics/top-assisters`)
- [ ] 팀 순위 연동
- [ ] 차트 및 그래프 표시

### 5.3 실시간 통계 업데이트
- [ ] 게임 진행 중 실시간 통계 업데이트
- [ ] WebSocket을 통한 실시간 데이터 전송
- [ ] 통계 캐싱 및 최적화

## 🎯 Phase 6: 사용자 프로필 연동 (2일)

### 6.1 프로필 정보 연동
- [ ] `lib/features/profile/screens/profile_screen.dart` 수정
- [ ] 사용자 정보 API 연동
- [ ] 프로필 이미지 업로드 기능
- [ ] 개인 정보 수정 기능

### 6.2 팀 관리 기능
- [ ] 팀 멤버 관리 화면 구현
- [ ] 팀 생성/수정/삭제 기능
- [ ] 팀 멤버 초대/제거 기능
- [ ] 팀 권한 관리

### 6.3 설정 기능
- [ ] 알림 설정 연동
- [ ] 개인정보 보호 설정
- [ ] 앱 정보 표시
- [ ] 고객 지원 연동

## 🎯 Phase 7: 실시간 기능 구현 (3-4일)

### 7.1 WebSocket 연동
- [ ] WebSocket 클라이언트 설정
- [ ] 실시간 게임 업데이트
- [ ] 실시간 공지사항 알림
- [ ] 실시간 채팅 기능 (선택사항)

### 7.2 푸시 알림
- [ ] Firebase Cloud Messaging 설정
- [ ] 게임 일정 알림
- [ ] 공지사항 알림
- [ ] 팀 활동 알림

### 7.3 실시간 데이터 동기화
- [ ] 오프라인 데이터 캐싱
- [ ] 데이터 동기화 전략 구현
- [ ] 충돌 해결 로직

## 🎯 Phase 8: 고급 기능 및 최적화 (2-3일)

### 8.1 이미지 및 파일 관리
- [ ] 이미지 캐싱 및 최적화
- [ ] 파일 업로드 진행률 표시
- [ ] 이미지 압축 및 리사이징
- [ ] CDN 연동

### 8.2 성능 최적화
- [ ] API 응답 캐싱
- [ ] 이미지 지연 로딩
- [ ] 리스트 가상화 (대용량 데이터)
- [ ] 메모리 사용량 최적화

### 8.3 오프라인 지원
- [ ] 오프라인 모드 구현
- [ ] 데이터 동기화 큐
- [ ] 오프라인 상태 표시
- [ ] 데이터 백업/복원

## 🎯 Phase 9: 테스트 및 배포 (2-3일)

### 9.1 테스트
- [ ] API 연동 단위 테스트
- [ ] 통합 테스트
- [ ] UI 테스트
- [ ] 성능 테스트

### 9.2 에러 처리 및 모니터링
- [ ] 전역 에러 핸들링
- [ ] 에러 로깅 및 분석
- [ ] 사용자 피드백 수집
- [ ] 크래시 리포팅

### 9.3 배포 준비
- [ ] 환경별 설정 분리
- [ ] API 키 보안 관리
- [ ] 앱 서명 및 배포
- [ ] 백엔드 서버 배포

## 📊 우선순위 및 예상 소요 시간

### 높은 우선순위 (필수)
- Phase 1: 기본 설정 및 인프라 (1-2일)
- Phase 2: 인증 시스템 연동 (2-3일)
- Phase 3: 게임 데이터 연동 (2-3일)
- Phase 4: 공지사항 연동 (2일)

### 중간 우선순위 (중요)
- Phase 5: 통계 데이터 연동 (2일)
- Phase 6: 사용자 프로필 연동 (2일)
- Phase 7: 실시간 기능 구현 (3-4일)

### 낮은 우선순위 (선택사항)
- Phase 8: 고급 기능 및 최적화 (2-3일)
- Phase 9: 테스트 및 배포 (2-3일)

## 🎯 총 예상 소요 시간: 18-25일

## 📝 참고사항

### 기술 스택
- **Flutter**: HTTP 클라이언트, 상태 관리, 로컬 저장소
- **Backend**: Node.js, Express, PostgreSQL, Firebase Admin
- **실시간**: WebSocket, Firebase Cloud Messaging
- **파일**: Multer, Cloud Storage

### 개발 환경
- **개발**: `http://localhost:3001`
- **스테이징**: `https://staging-api.sportsapp.com`
- **프로덕션**: `https://api.sportsapp.com`

### 보안 고려사항
- API 키 보안 관리
- 사용자 데이터 암호화
- HTTPS 통신 강제
- 토큰 만료 관리 