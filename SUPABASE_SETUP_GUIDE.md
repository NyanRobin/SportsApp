# FieldSync Supabase 설정 가이드

이 가이드는 FieldSync 앱을 위한 Supabase 백엔드를 완전히 설정하는 방법을 안내합니다.

## 🗄️ 1. Supabase 프로젝트 생성

### 1.1 Supabase 계정 생성 및 프로젝트 설정
1. [Supabase.com](https://supabase.com)에 접속하여 계정을 생성합니다
2. "New Project" 버튼을 클릭합니다
3. 프로젝트 정보를 입력합니다:
   - **Name**: `FieldSync`
   - **Database Password**: 강력한 비밀번호 생성
   - **Region**: 가장 가까운 지역 선택 (Korea Central 권장)
4. "Create new project" 버튼을 클릭합니다

### 1.2 프로젝트 URL 및 API Key 확인
1. 프로젝트 대시보드에서 "Settings" → "API" 메뉴로 이동
2. 다음 정보를 복사해 둡니다:
   - **Project URL**: `https://[your-project-ref].supabase.co`
   - **anon public**: `eyJ...` (공개 키)
   - **service_role**: `eyJ...` (서비스 역할 키, 보안 유지 필요)

## 📊 2. 데이터베이스 스키마 및 샘플 데이터 생성

### 2.1 SQL 스크립트 실행
1. Supabase 대시보드에서 "SQL Editor" 메뉴로 이동
2. "New query" 버튼을 클릭
3. 프로젝트 루트의 `supabase_sample_data.sql` 파일 내용을 복사하여 붙여넣기
4. "Run" 버튼을 클릭하여 실행

### 2.2 실행 결과 확인
SQL 스크립트 실행으로 다음이 생성됩니다:
- **테이블**: teams, user_profiles, games, game_statistics, announcements, user_statistics, team_rankings, recent_activities, game_timeline_events, notifications
- **샘플 데이터**: 각 테이블에 테스트용 샘플 데이터
- **RLS 정책**: Row Level Security 설정
- **뷰**: top_scorers, top_assisters (통계 조회용)
- **트리거**: updated_at 자동 업데이트

### 2.3 데이터 확인
1. "Table Editor" 메뉴에서 생성된 테이블들을 확인
2. 각 테이블에 샘플 데이터가 올바르게 삽입되었는지 확인

## 🔧 3. Edge Functions 배포

### 3.1 Supabase CLI 설치
```bash
# macOS (Homebrew)
brew install supabase/tap/supabase

# Windows (Scoop)
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase

# Linux
curl -s https://raw.githubusercontent.com/supabase/cli/main/install.sh | bash
```

### 3.2 CLI 로그인 및 프로젝트 연결
```bash
# Supabase에 로그인
supabase login

# 프로젝트 디렉토리로 이동
cd /path/to/sports_app

# Supabase 프로젝트와 연결
supabase link --project-ref [your-project-ref]
```

### 3.3 Edge Functions 배포
```bash
# 모든 Edge Functions 배포
supabase functions deploy games
supabase functions deploy statistics
supabase functions deploy announcements
supabase functions deploy users
supabase functions deploy activities
```

### 3.4 Environment Variables 설정
1. Supabase 대시보드에서 "Edge Functions" 메뉴로 이동
2. 각 함수에 대해 다음 환경 변수 설정:
   - `SUPABASE_URL`: 프로젝트 URL
   - `SUPABASE_SERVICE_ROLE_KEY`: 서비스 역할 키

## 🔐 4. 인증 설정

### 4.1 Firebase Authentication 연동 (선택사항)
FieldSync는 Firebase Auth를 사용하므로 Supabase Auth 대신 Firebase를 유지할 수 있습니다.

### 4.2 RLS 정책 확인
샘플 데이터 스크립트에서 이미 설정된 RLS 정책들을 확인:
```sql
-- 예시: 인증된 사용자만 읽기 가능
CREATE POLICY "Allow authenticated users to read teams" 
ON teams FOR SELECT TO authenticated USING (true);
```

## 📱 5. Flutter 앱 설정

### 5.1 Supabase URL 및 Key 업데이트
`lib/core/constants/app_constants.dart` 파일에서 Supabase 정보를 업데이트:

```dart
class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://[your-project-ref].supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
  
  // Use Supabase backend
  static const bool useSupabaseFunctions = true;
  
  // ... 나머지 설정
}
```

### 5.2 패키지 설치 및 앱 실행
```bash
# Flutter 패키지 설치
flutter pub get

# 앱 실행
flutter run
```

## 🧪 6. API 테스트

### 6.1 Edge Functions 테스트
각 Edge Function이 올바르게 작동하는지 테스트:

```bash
# Games API 테스트
curl "https://[your-project-ref].supabase.co/functions/v1/games" \
  -H "Authorization: Bearer [your-anon-key]"

# Statistics API 테스트
curl "https://[your-project-ref].supabase.co/functions/v1/statistics/top-scorers" \
  -H "Authorization: Bearer [your-anon-key]"

# Announcements API 테스트
curl "https://[your-project-ref].supabase.co/functions/v1/announcements" \
  -H "Authorization: Bearer [your-anon-key]"
```

### 6.2 Flutter 앱에서 데이터 확인
1. 앱을 실행하고 로그인
2. 각 화면(홈, 게임, 통계, 공지사항)에서 샘플 데이터가 표시되는지 확인
3. 에러가 발생하면 Supabase 대시보드의 "Logs" 메뉴에서 확인

## 📋 7. 샘플 데이터 상세 정보

### 7.1 Teams (팀)
- 대한고등학교, 강북고등학교, 서울고등학교, 부산고등학교, 인천고등학교, 대구고등학교

### 7.2 Players (선수)
- 김민석 (Forward, #10) - 대한고등학교
- 박지성 (Midfielder, #7) - 강북고등학교
- 이준호 (Forward, #9) - 서울고등학교
- 최재원 (Midfielder, #8) - 서울고등학교
- 정태우 (Defender, #4) - 대한고등학교
- 한승우 (Goalkeeper, #1) - 부산고등학교
- 송민호 (Defender, #5) - 인천고등학교
- 윤상혁 (Midfielder, #6) - 대구고등학교

### 7.3 Games (경기)
- 완료된 경기: 대한고 vs 강북고 (3-1), 서울고 vs 대한고 (2-2), 대한고 vs 부산고 (4-0)
- 예정된 경기: 강북고 vs 서울고, 대한고 vs 대구고, 부산고 vs 인천고

### 7.4 Statistics (통계)
- 개인 통계: 골, 어시스트, 슈팅, 패스, 태클 등
- 팀 랭킹: 승점, 득실차, 승률 등
- 시즌 통계: 2025 시즌 기준

### 7.5 Announcements (공지사항)
- 훈련 일정 변경
- 경기 분석 자료
- 팀 저녁 식사 모임
- 새로운 유니폼 배급
- 의료진 검진 일정
- 겨울 훈련 캠프

### 7.6 Recent Activities (최근 활동)
- 경기 결과 (골, 어시스트 포함)
- 훈련 세션
- 개인 성취 (목표 달성)
- 팀 회의

## 🔧 8. 문제 해결

### 8.1 일반적인 오류
1. **"Invalid API key"**: `app_constants.dart`의 API 키 확인
2. **"Function not found"**: Edge Functions 배포 상태 확인
3. **"Permission denied"**: RLS 정책 및 인증 상태 확인
4. **"No data"**: 샘플 데이터 스크립트 실행 여부 확인

### 8.2 로그 확인
- Supabase 대시보드 → "Logs" → "Edge Functions"에서 함수 실행 로그 확인
- Flutter 콘솔에서 API 요청/응답 로그 확인

### 8.3 데이터베이스 직접 확인
- Supabase 대시보드 → "Table Editor"에서 데이터 직접 조회/수정 가능

## 🚀 9. 추가 설정 (선택사항)

### 9.1 실시간 기능 활성화
```sql
-- 실시간 구독을 위한 publication 생성
CREATE PUBLICATION supabase_realtime FOR ALL TABLES;
```

### 9.2 스토리지 설정 (이미지 업로드용)
1. "Storage" 메뉴에서 "Create bucket" 클릭
2. Bucket 이름: `avatars`, `team-logos` 등
3. RLS 정책 설정

### 9.3 백업 설정
- "Settings" → "Database" → "Backups"에서 자동 백업 설정

## ✅ 10. 완료 체크리스트

- [ ] Supabase 프로젝트 생성
- [ ] 데이터베이스 스키마 생성 (SQL 스크립트 실행)
- [ ] 샘플 데이터 삽입
- [ ] Edge Functions 배포
- [ ] Flutter 앱 설정 업데이트
- [ ] API 테스트 완료
- [ ] 앱에서 데이터 표시 확인

---

## 🎉 설정 완료!

모든 단계를 완료하면 FieldSync 앱이 Supabase 백엔드와 완전히 연동되어 실제 데이터베이스 데이터를 표시하게 됩니다.

**주의사항**: 
- Service Role Key는 절대 클라이언트 코드에 노출하지 마세요
- 프로덕션 환경에서는 RLS 정책을 더 엄격하게 설정하세요
- 정기적으로 데이터베이스 백업을 수행하세요

문제가 발생하면 Supabase 공식 문서나 커뮤니티를 참고하세요: https://supabase.com/docs




