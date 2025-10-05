# 🚀 온라인 환경 설정 가이드

## 📋 개요
이 가이드는 Sports App을 온라인 환경으로 전환하는 방법을 설명합니다.

## 🗄️ 데이터베이스 옵션

### 1. Supabase (추천 - 무료)
- **URL**: https://supabase.com
- **특징**: PostgreSQL 기반, 무료 플랜 제공, 실시간 기능 내장

#### 설정 단계:
1. Supabase 계정 생성
2. 새 프로젝트 생성
3. Database > Settings에서 연결 정보 확인
4. `.env` 파일 업데이트:

```env
# Database Configuration (Supabase)
DB_HOST=db.xxxxxxxxxxxxx.supabase.co
DB_PORT=5432
DB_NAME=postgres
DB_USER=postgres
DB_PASSWORD=your-supabase-db-password
DB_SSL=true

# Supabase Configuration
SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
```

### 2. Railway
- **URL**: https://railway.app
- **특징**: PostgreSQL 호스팅, 간단한 배포

### 3. PlanetScale
- **URL**: https://planetscale.com
- **특징**: MySQL 기반, 무료 플랜 제공

### 4. Neon
- **URL**: https://neon.tech
- **특징**: PostgreSQL 기반, 서버리스

## 🔧 설정 방법

### 1. 환경 변수 설정
```bash
cd backend
cp env.example .env
```

### 2. 데이터베이스 스키마 생성
```bash
npm run setup-db
```

### 3. 연결 테스트
```bash
curl http://localhost:3000/api/database/status
```

## 🌐 배포 옵션

### 1. Backend 배포
- **Railway**: https://railway.app
- **Render**: https://render.com
- **Heroku**: https://heroku.com
- **Vercel**: https://vercel.com

### 2. Frontend 배포
- **Vercel**: Flutter Web 배포
- **Netlify**: Flutter Web 배포
- **Firebase Hosting**: Flutter Web 배포

## 📱 Flutter 앱 설정

### 1. API URL 업데이트
`lib/core/constants/app_constants.dart`에서:
```dart
static const String baseUrl = 'https://your-backend-url.com';
```

### 2. Firebase 설정
- Firebase Console에서 웹 앱 설정
- `web/index.html`에 Firebase 설정 추가

## 🔒 보안 설정

### 1. 환경 변수
- 프로덕션에서는 모든 민감한 정보를 환경 변수로 설정
- `.env` 파일을 `.gitignore`에 추가

### 2. CORS 설정
- 프로덕션에서는 특정 도메인만 허용
- `server.js`에서 CORS 설정 수정

### 3. JWT Secret
- 강력한 JWT Secret 생성
- 정기적으로 변경

## 📊 모니터링

### 1. 로그 모니터링
- Winston 로거 설정
- 에러 추적 서비스 연결 (Sentry 등)

### 2. 성능 모니터링
- New Relic, DataDog 등 사용
- 데이터베이스 쿼리 최적화

## 🚨 문제 해결

### 1. 데이터베이스 연결 실패
```bash
# 연결 테스트
curl http://localhost:3000/api/database/status

# 로그 확인
npm run dev
```

### 2. CORS 오류
- 백엔드 CORS 설정 확인
- 프론트엔드 API URL 확인

### 3. 인증 오류
- Firebase 설정 확인
- JWT Secret 확인

## 📞 지원

문제가 발생하면:
1. 로그 확인
2. 환경 변수 설정 확인
3. 데이터베이스 연결 상태 확인
4. 네트워크 연결 확인 