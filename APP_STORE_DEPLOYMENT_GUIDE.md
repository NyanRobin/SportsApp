# 🍎 FieldSync App Store 배포 가이드

## 🎯 현재 상태
- ✅ Xcode 설치 완료 (v26.0.1)
- ✅ Bundle ID 설정: `com.fieldsync.sportsapp`
- ✅ 앱 이름: FieldSync
- ✅ iOS 앱 아이콘 생성 완료
- ⚠️ CocoaPods 설치 필요 (관리자 권한 필요)

## 📋 배포 준비 사항

### 1. CocoaPods 설치 (필수)
현재 sudo 권한이 없어 설치가 필요합니다. 다음 중 하나의 방법을 사용하세요:

#### 방법 1: 관리자 권한으로 설치
```bash
sudo gem install cocoapods
```

#### 방법 2: Homebrew 사용 (권장)
```bash
# Homebrew 설치 (없는 경우)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# CocoaPods 설치
brew install cocoapods
```

### 2. iOS 프로젝트 설정 확인
- **Bundle ID**: `com.fieldsync.sportsapp`
- **Display Name**: FieldSync
- **Version**: 1.0.0
- **Build**: 1

### 3. 앱 아이콘
- **1024x1024 아이콘**: 생성 완료
- **다양한 크기**: iOS가 자동으로 리사이징

## 🏪 Apple Developer Program

### 1. Apple Developer Program 가입
1. [Apple Developer](https://developer.apple.com/programs/) 방문
2. Apple ID로 로그인
3. 프로그램 가입 ($99/년)
4. 팀 정보 완성

### 2. 인증서 및 프로비저닝 프로파일
1. **개발 인증서** 생성
2. **배포 인증서** 생성
3. **App ID** 등록 (`com.fieldsync.sportsapp`)
4. **프로비저닝 프로파일** 생성

## 🔧 iOS 빌드 설정

### 1. CocoaPods 설치 후 빌드
```bash
cd ios
pod install
cd ..
flutter build ios --release
```

### 2. Xcode에서 아카이브
1. Xcode 열기
2. `ios/Runner.xcworkspace` 파일 열기
3. Product → Archive 선택
4. Organizer에서 앱 업로드

## 📱 App Store Connect 설정

### 1. 새 앱 등록
1. [App Store Connect](https://appstoreconnect.apple.com) 접속
2. "새 앱" 클릭
3. 앱 정보 입력:
   - **플랫폼**: iOS
   - **이름**: FieldSync
   - **기본 언어**: 한국어
   - **번들 ID**: com.fieldsync.sportsapp
   - **SKU**: fieldsync-sports-app

### 2. 앱 정보 입력

#### 앱 설명
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

#### 키워드
```
스포츠,팀관리,경기분석,통계,팀워크,운동,스포츠앱
```

#### 카테고리
- **주 카테고리**: 스포츠
- **부 카테고리**: 생산성

### 3. 앱 아이콘 및 스크린샷
- **앱 아이콘**: 1024x1024px (생성 완료)
- **스크린샷**: 
  - iPhone 6.7": 1290 x 2796px
  - iPhone 6.5": 1242 x 2688px
  - iPad Pro (6세대): 2048 x 2732px

### 4. 개인정보처리방침
사용자 데이터 수집 시 개인정보처리방침 URL 필요:
```
예시: https://fieldsync-app.com/privacy-policy
```

## 🚀 배포 단계

### 1. TestFlight 베타 테스트
1. App Store Connect에서 "TestFlight" 탭
2. 빌드 업로드 후 베타 테스트 시작
3. 테스터 추가 (최대 10,000명)
4. 내부 테스트 진행

### 2. App Store 제출
1. TestFlight 테스트 완료 후
2. "App Store" 탭에서 "제출 검토"
3. Apple 검토 대기 (일반적으로 24-48시간)
4. 승인 후 자동 출시

## 🔐 코드 사이닝 설정

### 1. Xcode에서 팀 설정
1. Xcode에서 Runner 프로젝트 열기
2. Signing & Capabilities 탭
3. Team 선택 (Apple Developer Program 팀)
4. Bundle Identifier 확인

### 2. 자동 코드 사이닝 활성화
- "Automatically manage signing" 체크
- Xcode가 자동으로 인증서 및 프로파일 관리

## 📊 배포 후 모니터링

### 1. App Store Connect 대시보드
- 다운로드 수 및 사용자 수
- 평점 및 리뷰 관리
- 수익 분석 (유료 앱인 경우)
- 크래시 리포트

### 2. 업데이트 배포
새 버전 배포 시:
1. `pubspec.yaml`에서 버전 번호 증가
2. iOS 빌드 및 아카이브
3. App Store Connect에서 새 버전 제출

## ⚠️ 주의사항

1. **Apple 정책 준수**: App Store 검토 가이드라인 확인
2. **개인정보 보호**: 개인정보처리방침 준수
3. **테스트**: 충분한 테스트 후 제출
4. **버전 관리**: 각 업데이트마다 버전 번호 증가
5. **검토 시간**: 첫 번째 앱은 검토 시간이 더 오래 걸릴 수 있음

## 🔧 문제 해결

### CocoaPods 설치 오류
```bash
# Ruby 버전 확인
ruby --version

# Ruby 업데이트 (필요한 경우)
# rbenv 또는 rvm 사용 권장
```

### Xcode 빌드 오류
1. Product → Clean Build Folder
2. DerivedData 삭제
3. Pod 재설치

### 코드 사이닝 오류
1. Keychain에서 인증서 확인
2. 프로비저닝 프로파일 재다운로드
3. Bundle ID 확인

## 📞 지원 및 문의
- Apple Developer Documentation
- App Store Connect Help
- Flutter iOS Deployment Guide

---

**다음 단계**: 
1. 관리자 권한으로 CocoaPods 설치
2. `pod install` 실행
3. iOS 릴리즈 빌드 테스트
4. Apple Developer Program 가입
5. App Store Connect에서 앱 등록

**예상 소요 시간**: 2-3일 (Apple 검토 포함)

