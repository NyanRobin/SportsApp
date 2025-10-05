# 🚀 Sports App Backend Deployment Guide

## ✅ 현재 상태
- ✅ **데이터베이스**: Supabase PostgreSQL 연결됨
- ✅ **API 엔드포인트**: 모든 기능 작동
- ✅ **샘플 데이터**: 삽입 완료
- ✅ **Mock 데이터**: 제거 완료

## 🌐 배포 옵션

### 1. Railway 배포 (추천)

1. [Railway](https://railway.app) 가입
2. GitHub 리포지토리 연결
3. 환경 변수 설정:
   ```
   NODE_ENV=production
   PORT=3000
   DB_HOST=aws-1-ap-northeast-2.pooler.supabase.com
   DB_PORT=6543
   DB_NAME=postgres
   DB_USER=postgres.ayqcfpldgsfntwlurkca
   DB_PASSWORD=smdpos3371
   DB_SSL=true
   JWT_SECRET=your-production-jwt-secret
   CORS_ORIGIN=*
   ```

### 2. Render 배포

1. [Render](https://render.com) 가입
2. GitHub 리포지토리 연결
3. `render.yaml` 파일 사용하여 자동 배포
4. 환경 변수에서 `DB_PASSWORD`와 `JWT_SECRET` 설정

### 3. Vercel 배포

1. [Vercel](https://vercel.com) 가입
2. GitHub 리포지토리 연결
3. 환경 변수 설정
4. `vercel.json` 설정 필요

### 4. Docker 배포

```bash
# 이미지 빌드
docker build -t sports-app-backend .

# 컨테이너 실행
docker run -p 3000:3000 \
  -e DB_HOST=aws-1-ap-northeast-2.pooler.supabase.com \
  -e DB_PORT=6543 \
  -e DB_NAME=postgres \
  -e DB_USER=postgres.ayqcfpldgsfntwlurkca \
  -e DB_PASSWORD=smdpos3371 \
  -e DB_SSL=true \
  -e JWT_SECRET=your-jwt-secret \
  -e NODE_ENV=production \
  sports-app-backend
```

## 🔧 필수 환경 변수

```env
NODE_ENV=production
PORT=3000
DB_HOST=aws-1-ap-northeast-2.pooler.supabase.com
DB_PORT=6543
DB_NAME=postgres
DB_USER=postgres.ayqcfpldgsfntwlurkca
DB_PASSWORD=smdpos3371
DB_SSL=true
JWT_SECRET=your-production-jwt-secret
CORS_ORIGIN=*
```

## 📡 API 엔드포인트

배포 후 다음 엔드포인트들이 사용 가능합니다:

### 🏥 Health Check
- `GET /health` - 서버 상태 확인
- `GET /api/database/status` - 데이터베이스 연결 상태

### 🎮 Games
- `GET /api/games` - 모든 게임 조회
- `GET /api/games/:id` - 특정 게임 조회
- `POST /api/games` - 새 게임 생성

### 📢 Announcements
- `GET /api/announcements` - 모든 공지사항 조회
- `GET /api/announcements/:id` - 특정 공지사항 조회
- `POST /api/announcements` - 새 공지사항 생성

### 👥 Users
- `GET /api/users` - 사용자 목록
- `GET /api/users/profile` - 사용자 프로필

### 📊 Statistics
- `GET /api/statistics` - 통계 데이터
- `GET /api/statistics/top-scorers` - 득점왕 순위
- `GET /api/statistics/team-rankings` - 팀 순위

## 🔄 배포 후 확인사항

1. **Health Check**: `https://your-domain.com/health`
2. **Database Status**: `https://your-domain.com/api/database/status`
3. **Games API**: `https://your-domain.com/api/games`
4. **Announcements**: `https://your-domain.com/api/announcements`

## 📱 Flutter 앱 연동

배포 완료 후 Flutter 앱의 API 기본 URL을 업데이트하세요:

```dart
// lib/core/network/api_service.dart
static const String baseURL = 'https://your-deployed-domain.com';
```

## 🎉 완료!

백엔드가 성공적으로 배포되면:
- ✅ 실제 Supabase 데이터베이스 사용
- ✅ 모든 API 엔드포인트 작동
- ✅ WebSocket 실시간 기능 지원
- ✅ Flutter 앱과 완전 연동 가능 