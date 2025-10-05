# 🚀 Supabase Edge Functions 배포 완료 가이드

## ✅ 배포된 Edge Functions

모든 API 엔드포인트가 성공적으로 Supabase Edge Functions로 배포되었습니다!

### 📡 **배포된 Functions:**

1. **🎮 Games Function**
   - URL: `https://ayqcfpldgsfntwlurkca.supabase.co/functions/v1/games`
   - 기능: 게임 CRUD 작업

2. **📢 Announcements Function**
   - URL: `https://ayqcfpldgsfntwlurkca.supabase.co/functions/v1/announcements`
   - 기능: 공지사항 CRUD 작업

3. **👥 Users Function**
   - URL: `https://ayqcfpldgsfntwlurkca.supabase.co/functions/v1/users`
   - 기능: 사용자 관리

4. **📊 Statistics Function**
   - URL: `https://ayqcfpldgsfntwlurkca.supabase.co/functions/v1/statistics`
   - 기능: 통계 데이터 조회

## 🔌 **API 엔드포인트**

### Games API
```
GET    /functions/v1/games           - 모든 게임 조회
GET    /functions/v1/games/:id       - 특정 게임 조회
POST   /functions/v1/games           - 새 게임 생성
GET    /functions/v1/games/upcoming  - 예정된 게임
GET    /functions/v1/games/recent    - 최근 완료된 게임
```

### Announcements API
```
GET    /functions/v1/announcements         - 모든 공지사항 조회
GET    /functions/v1/announcements/:id     - 특정 공지사항 조회
POST   /functions/v1/announcements         - 새 공지사항 생성
GET    /functions/v1/announcements/pinned  - 고정된 공지사항
```

### Users API
```
GET    /functions/v1/users          - 모든 사용자 조회
GET    /functions/v1/users/:id      - 특정 사용자 조회
GET    /functions/v1/users/profile  - 사용자 프로필 조회
```

### Statistics API
```
GET    /functions/v1/statistics             - 기본 통계
GET    /functions/v1/statistics/top-scorers - 득점 순위
GET    /functions/v1/statistics/team-rankings - 팀 순위
```

## 🔑 **인증 헤더**

모든 요청에 다음 헤더를 포함해야 합니다:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5cWNmcGxkZ3NmbnR3bHVya2NhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM4NjI2MjQsImV4cCI6MjAzOTQzODYyNH0.z1aP-_lKPCVUo2SkxBP6SKK7PZtKyJ8dYH4IA77aP1U
Content-Type: application/json
```

## 📱 **Flutter 앱 설정**

Flutter 앱이 자동으로 Edge Functions를 사용하도록 설정되었습니다:

- **Base URL**: `https://ayqcfpldgsfntwlurkca.supabase.co/functions/v1`
- **인증**: Supabase Anon Key 자동 포함
- **환경 전환**: `AppConstants.useSupabaseFunctions = true/false`로 로컬/프로덕션 전환 가능

## 🧪 **테스트 방법**

### cURL 테스트 예제:

```bash
# 게임 목록 조회
curl -X GET "https://ayqcfpldgsfntwlurkca.supabase.co/functions/v1/games" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5cWNmcGxkZ3NmbnR3bHVya2NhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM4NjI2MjQsImV4cCI6MjAzOTQzODYyNH0.z1aP-_lKPCVUo2SkxBP6SKK7PZtKyJ8dYH4IA77aP1U" \
  -H "Content-Type: application/json"

# 공지사항 조회
curl -X GET "https://ayqcfpldgsfntwlurkca.supabase.co/functions/v1/announcements" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5cWNmcGxkZ3NmbnR3bHVya2NhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM4NjI2MjQsImV4cCI6MjAzOTQzODYyNH0.z1aP-_lKPCVUo2SkxBP6SKK7PZtKyJ8dYH4IA77aP1U" \
  -H "Content-Type: application/json"

# 새 게임 생성
curl -X POST "https://ayqcfpldgsfntwlurkca.supabase.co/functions/v1/games" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5cWNmcGxkZ3NmbnR3bHVya2NhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM4NjI2MjQsImV4cCI6MjAzOTQzODYyNH0.z1aP-_lKPCVUo2SkxBP6SKK7PZtKyJ8dYH4IA77aP1U" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Game",
    "home_team": "Team A",
    "away_team": "Team B",
    "game_date": "2024-03-01T15:00:00Z",
    "location": "Stadium A"
  }'
```

## 🔄 **로컬 개발 모드로 전환**

로컬 Node.js 서버를 사용하려면:

1. `lib/core/constants/app_constants.dart`에서:
   ```dart
   static const bool useSupabaseFunctions = false;
   ```

2. 로컬 서버 시작:
   ```bash
   cd backend && npm start
   ```

## 🎉 **완료된 기능들**

- ✅ **Supabase PostgreSQL 데이터베이스** 연결
- ✅ **4개 Edge Functions** 배포 완료
- ✅ **CORS 설정** 완료
- ✅ **인증 시스템** 통합
- ✅ **Flutter 앱** 자동 연동
- ✅ **환경 전환** 기능 (로컬/프로덕션)
- ✅ **실시간 데이터** (Supabase 직접 연결)

## 📊 **성능 이점**

- **🚀 빠른 응답시간**: Edge 배포로 전 세계 CDN 활용
- **📱 무제한 확장**: 서버리스 아키텍처
- **💰 비용 효율적**: 사용량 기반 과금
- **🔒 보안**: Supabase RLS 및 JWT 인증
- **🌐 글로벌**: 전 세계 어디서나 빠른 접근

## 🎯 **다음 단계**

1. Flutter 앱에서 실제 API 호출 테스트
2. 필요시 추가 엔드포인트 개발
3. 프로덕션 환경에서 성능 모니터링
4. 사용자 피드백 수집 및 개선

---

**🎉 축하합니다! Sports App 백엔드가 성공적으로 Supabase Edge Functions로 배포되었습니다!** 