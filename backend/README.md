# Sports App Backend

스포츠 앱을 위한 Node.js/Express.js 백엔드 API 서버입니다.

## 🚀 시작하기

### 필수 요구사항

- Node.js 18+ 
- PostgreSQL 12+
- Firebase 프로젝트

### 설치

1. 의존성 설치
```bash
npm install
```

2. 환경 변수 설정
```bash
cp env.example .env
# .env 파일을 편집하여 실제 값으로 설정
```

3. 데이터베이스 설정
```bash
# PostgreSQL에 데이터베이스 생성
createdb sports_app

# 마이그레이션 실행
psql -d sports_app -f src/config/migrations.sql
```

4. 개발 서버 실행
```bash
npm run dev
```

## 📁 프로젝트 구조

```
src/
├── config/          # 설정 파일들
│   ├── database.ts  # 데이터베이스 연결
│   ├── firebase.ts  # Firebase 설정
│   └── migrations.sql # 데이터베이스 스키마
├── controllers/     # API 컨트롤러
├── middleware/      # 미들웨어
├── models/         # 데이터 모델
├── routes/         # API 라우트
├── services/       # 비즈니스 로직
├── types/          # TypeScript 타입 정의
├── utils/          # 유틸리티 함수
└── app.ts          # 메인 애플리케이션
```

## 🔧 스크립트

- `npm run dev`: 개발 서버 실행 (nodemon)
- `npm run build`: TypeScript 컴파일
- `npm start`: 프로덕션 서버 실행

## 🔐 인증

Firebase Authentication을 사용하여 JWT 토큰 기반 인증을 구현했습니다.

### API 요청 시 인증 헤더 추가
```
Authorization: Bearer <firebase-id-token>
```

## 📊 API 엔드포인트

### 헬스 체크
- `GET /health` - 서버 상태 확인

### 게임 관리
- `GET /api/games` - 모든 게임 조회
- `GET /api/games/:id` - 특정 게임 조회
- `POST /api/games` - 게임 생성

### 공지사항 관리
- `GET /api/announcements` - 모든 공지사항 조회
- `GET /api/announcements?tag=Games` - 태그별 공지사항 필터링
- `GET /api/announcements?search=keyword` - 검색어로 공지사항 검색
- `GET /api/announcements/:id` - 특정 공지사항 조회

### 통계
- `GET /api/statistics` - 전체 통계 (상위 득점자, 어시스트, 팀 순위)
- `GET /api/statistics?user_id=user1` - 특정 사용자 통계
- `GET /api/statistics?team_id=1` - 특정 팀 통계
- `GET /api/statistics/top-scorers` - 상위 득점자 목록
- `GET /api/statistics/top-assisters` - 상위 어시스트 목록

### 사용자 관리 (기본)
- `GET /api/users` - 사용자 목록 (기본)

## 🗄️ 데이터베이스

PostgreSQL을 사용하며, 다음 테이블들이 포함됩니다:

- `users` - 사용자 정보
- `teams` - 팀 정보
- `team_members` - 팀 멤버 관계
- `games` - 경기 정보
- `game_stats` - 경기 통계
- `announcements` - 공지사항
- `attachments` - 첨부파일
- `notifications` - 알림

## 🔒 보안

- Helmet.js를 사용한 보안 헤더 설정
- CORS 설정
- 입력 데이터 검증
- SQL 인젝션 방지 (parameterized queries)

## 🧪 테스트

```bash
npm test
```

## 📝 환경 변수

필요한 환경 변수들:

- `PORT`: 서버 포트 (기본값: 3000)
- `NODE_ENV`: 환경 (development/production)
- `DB_HOST`: 데이터베이스 호스트
- `DB_PORT`: 데이터베이스 포트
- `DB_NAME`: 데이터베이스 이름
- `DB_USER`: 데이터베이스 사용자
- `DB_PASSWORD`: 데이터베이스 비밀번호
- `JWT_SECRET`: JWT 시크릿 키
- Firebase 관련 설정들

## 🚀 배포

1. 빌드
```bash
npm run build
```

2. 프로덕션 실행
```bash
npm start
```

## 📞 지원

문제가 있거나 질문이 있으시면 이슈를 생성해주세요. 