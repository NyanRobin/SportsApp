# 📱 FieldSync Play Store 배포 가이드

## 🎯 현재 상태
- ✅ Bundle ID 설정: `com.fieldsync.sportsapp`
- ✅ 앱 이름: FieldSync
- ✅ Android 키스토어 생성 완료
- ✅ Release APK 빌드 성공
- ✅ 앱 아이콘 준비 완료

## 📋 배포 준비 사항

### 1. 릴리즈 빌드 파일
- **APK 위치**: `build/app/outputs/flutter-apk/app-release.apk`
- **크기**: 27.5MB
- **서명**: 완료 (fieldsync-release-key.keystore)

### 2. 키스토어 정보
```
키스토어 파일: android/app/fieldsync-release-key.keystore
스토어 비밀번호: fieldsync2024
키 별칭: fieldsync
키 비밀번호: fieldsync2024
```

⚠️ **중요**: 키스토어 파일과 비밀번호를 안전하게 보관하세요. 분실 시 앱 업데이트가 불가능합니다.

### 3. App Bundle 빌드 (권장)
현재 Android App Bundle 빌드에 이슈가 있으므로, 우선 APK로 배포하고 추후 수정 필요:

```bash
# 현재 작동하는 명령어
flutter build apk --release

# 추후 수정 후 사용할 명령어
flutter build appbundle --release
```

## 🏪 Google Play Console 설정

### 1. 개발자 계정 생성
1. [Google Play Console](https://play.google.com/console) 접속
2. 개발자 계정 등록 ($25 일회성 수수료)
3. 개발자 프로필 완성

### 2. 새 앱 생성
1. **앱 세부정보**:
   - 앱 이름: FieldSync
   - 기본 언어: 한국어
   - 앱 또는 게임: 앱
   - 무료 또는 유료: 무료

2. **앱 카테고리**:
   - 카테고리: 스포츠
   - 태그: 스포츠 관리, 팀 관리, 경기 분석

### 3. 앱 콘텐츠
1. **콘텐츠 등급**: 3세 이상
2. **타겟 고객**: 스포츠 팀 및 개인 사용자
3. **광고**: 광고 없음 (현재 설정 기준)

### 4. 스토어 등록정보

#### 앱 설명 (예시)
```
🏆 FieldSync - 스포츠 팀 관리의 새로운 기준

스포츠 팀을 효율적으로 관리하고 경기 성과를 분석할 수 있는 종합 솔루션입니다.

✨ 주요 기능
• 팀 및 선수 관리
• 경기 일정 및 결과 추적
• 실시간 통계 분석
• 팀 내 커뮤니케이션
• 성과 모니터링

🎯 대상 사용자
• 스포츠 팀 코치 및 매니저
• 선수 및 팀원
• 스포츠 동호회

📊 주요 장점
• 직관적인 사용자 인터페이스
• 실시간 데이터 동기화
• 종합적인 분석 도구
• 팀워크 향상 지원
```

#### 짧은 설명
```
스포츠 팀 관리와 경기 분석을 위한 올인원 솔루션
```

### 5. 그래픽 애셋
생성된 앱 아이콘을 다음 크기로 준비:
- **앱 아이콘**: 512 x 512px (PNG, 32-bit)
- **피처 그래픽**: 1024 x 500px
- **스크린샷**: 
  - 휴대폰: 최소 2개 (16:9 비율)
  - 태블릿: 최소 1개 (권장)

### 6. 개인정보처리방침
앱에서 사용자 데이터를 수집하는 경우 개인정보처리방침 URL 필요:
```
예시 URL: https://fieldsync-app.com/privacy-policy
```

## 🚀 배포 단계

### 1. 내부 테스트
1. Play Console에서 "내부 테스트" 트랙 생성
2. APK 또는 AAB 파일 업로드
3. 테스터 추가 (이메일 주소)
4. 릴리즈 생성 및 검토

### 2. 프로덕션 배포
1. 내부 테스트 완료 후
2. "프로덕션" 트랙으로 승격
3. 국가/지역 선택
4. 출시 일정 설정

### 3. 검토 과정
- Google 검토: 일반적으로 1-3일 소요
- 첫 번째 앱의 경우 더 오래 걸릴 수 있음
- 정책 준수 확인 필요

## 🔧 기술적 이슈 해결

### App Bundle 빌드 이슈
현재 다음 이슈들이 있어 추후 해결 필요:
1. Firebase 설정 불일치
2. Native 라이브러리 stripping 문제

해결 방법:
```bash
# Firebase 재설정
# 새로운 패키지명으로 Firebase 프로젝트 생성 필요

# App Bundle 빌드 시도
flutter build appbundle --release --no-shrink
```

### iOS 배포 준비 (추후)
iOS 배포를 위해서는:
1. Xcode 설치 필요
2. Apple Developer Program 가입 ($99/년)
3. CocoaPods 설치
4. 프로비저닝 프로파일 설정

## 📊 배포 후 모니터링

### 1. Play Console 대시보드
- 설치 수 및 사용자 수
- 평점 및 리뷰 관리
- 충돌 및 ANR 보고서
- 수익 분석 (유료 앱인 경우)

### 2. 업데이트 배포
새 버전 배포 시:
1. `pubspec.yaml`에서 버전 번호 증가
2. 새로운 APK/AAB 빌드
3. Play Console에서 업데이트 롤아웃

## ⚠️ 주의사항

1. **키스토어 백업**: 키스토어 파일을 안전한 곳에 백업
2. **버전 관리**: 앱 업데이트 시 버전 코드 증가 필수
3. **정책 준수**: Google Play 정책 준수 확인
4. **테스트**: 배포 전 충분한 테스트 진행
5. **사용자 피드백**: 초기 리뷰에 적극 대응

## 📞 지원 및 문의
앱 배포 과정에서 문제가 발생할 경우:
- Google Play Console 헬프센터
- Flutter 공식 문서
- Firebase 문서 (Firebase 기능 사용 시)

---

**다음 단계**: Play Console에서 개발자 계정을 생성하고 새 앱을 등록한 후, 생성된 APK 파일을 업로드하여 내부 테스트를 시작하세요.


