# 🔐 JWT 인증 문제 해결 가이드

## 🚨 **현재 문제**
- Supabase Edge Functions가 항상 유효한 JWT 토큰을 요구함
- Flutter 앱에서 401 Unauthorized 에러 발생
- 기존 Anon Key로는 인증이 통과되지 않음

## ✅ **해결된 설정들**

### 1. **Service Role Key 환경 변수 설정**
```bash
SUPABASE_SERVICE_ROLE_KEY=환경변수로_이미_설정됨
SUPABASE_URL=https://ayqcfpldgsfntwlurkca.supabase.co
SUPABASE_ANON_KEY=설정됨
```

### 2. **Edge Function 수정사항**
- Service Role Key로 Supabase 클라이언트 초기화
- 읽기 작업: 인증 우회 허용  
- 쓰기 작업: 인증 필수
- CORS 헤더 최적화 완료

### 3. **Flutter App 설정**
```dart
// API 서비스 헤더 설정
headers: {
  'Authorization': 'Bearer ${AppConstants.supabaseAnonKey}',
  'apikey': AppConstants.supabaseAnonKey,
}
```

## 🎯 **최종 해결방안**

### **방법 1: Row Level Security (RLS) 비활성화**

데이터베이스의 `games` 테이블에서 RLS를 비활성화하여 공개 접근 허용:

```sql
-- RLS 비활성화 (읽기 전용 데이터)
ALTER TABLE public.games DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements DISABLE ROW LEVEL SECURITY;
```

### **방법 2: 공개 정책 생성**

특정 작업에 대해 공개 접근 정책 생성:

```sql
-- 공개 읽기 정책
CREATE POLICY "Public read access for games" ON public.games
  FOR SELECT USING (true);

CREATE POLICY "Public read access for announcements" ON public.announcements
  FOR SELECT USING (true);
```

### **방법 3: Edge Function에서 JWT 검증 우회**

현재 적용된 방법:
- Service Role Key 사용으로 RLS 우회
- 읽기 작업에서는 인증 헤더 불필요
- 쓰기 작업에서만 인증 검증

## 🔧 **현재 작동 상황**

### ✅ **완료된 설정:**
1. Service Role Key 환경 변수 설정
2. Edge Functions 배포 완료
3. Flutter 앱 API 헤더 설정
4. CORS 정책 수정

### ⚠️ **여전한 문제:**
- Supabase 플랫폼 레벨에서 JWT 검증 강제
- 인증 없는 요청이 Edge Functions에 도달하지 못함

## 🚀 **권장 해결책**

### **즉시 적용 가능한 방법:**

1. **데이터베이스 RLS 정책 수정**
   ```bash
   # Supabase Dashboard → Authentication → RLS Policies
   # games 테이블과 announcements 테이블에 Public Read 정책 추가
   ```

2. **임시로 로컬 개발 모드 사용**
   ```dart
   static const bool useSupabaseFunctions = false;
   ```

3. **Service Role Key를 클라이언트에서 직접 사용** (비추천 - 보안상 위험)

## 📋 **다음 단계**

1. **RLS 정책 확인 및 수정**
2. **공개 읽기 접근 허용**  
3. **JWT 토큰 새로 생성 시도**
4. **대안으로 REST API 엔드포인트 직접 사용**

## 🎉 **최종 목표**

Flutter 앱이 Supabase Edge Functions를 통해 데이터베이스의 게임 및 공지사항 데이터에 성공적으로 접근할 수 있도록 하는 것입니다.

---

**현재 진행 상황**: JWT 인증 설정은 완료되었으나, Supabase 플랫폼 레벨의 제약으로 인해 추가 설정이 필요합니다. 