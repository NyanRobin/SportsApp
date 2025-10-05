# 🔐 관리자 계정에서 ryanchoi에 권한 부여 가이드

## 현재 상황
- **관리자 계정**: bernard (추정)
- **일반 사용자**: ryanchoi
- **목표**: ryanchoi 계정에 관리자 권한 부여

## 🔑 관리자 계정에서 권한 부여 방법

### 방법 1: 시스템 환경설정에서 부여 (GUI 방식)

#### 1단계: 관리자 계정으로 로그인
1. **로그아웃** → **bernard 계정으로 로그인**
2. 관리자 비밀번호 입력

#### 2단계: 사용자 및 그룹 설정
1. **Apple 메뉴** → **시스템 환경설정** (또는 **시스템 설정**)
2. **사용자 및 그룹** 클릭
3. **자물쇠 아이콘** 클릭 → 관리자 비밀번호 입력
4. **ryanchoi** 계정 선택
5. **"관리자 허용"** 체크박스 선택
6. **적용** 또는 **저장** 클릭

### 방법 2: 터미널에서 부여 (명령어 방식)

#### 1단계: 관리자 계정으로 터미널 실행
```bash
# bernard 계정으로 로그인 후 터미널에서 실행
sudo dscl . -append /Groups/admin GroupMembership ryanchoi
```

#### 2단계: 권한 확인
```bash
# ryanchoi가 관리자 그룹에 추가되었는지 확인
dscl . -read /Groups/admin GroupMembership
```

### 방법 3: 관리자 계정에서 직접 CocoaPods 설치

#### 1단계: 관리자 계정으로 로그인
```bash
# bernard 계정으로 로그인
```

#### 2단계: CocoaPods 설치
```bash
sudo gem install cocoapods
```

#### 3단계: ryanchoi 계정으로 다시 로그인
```bash
# ryanchoi 계정으로 로그인
cd "/Users/ryanchoi/iCloud Drive (Archive)/Desktop/app/sports_app/ios"
pod install
cd ..
flutter build ios --release --no-codesign
```

## 📋 단계별 실행 가이드

### 🎯 **추천 방법: GUI 방식**

#### Step 1: 관리자 계정으로 로그인
1. **현재 세션 로그아웃**
2. **bernard 계정 선택**
3. **관리자 비밀번호 입력**

#### Step 2: 시스템 설정 열기
1. **Apple 메뉴** (🍎) 클릭
2. **시스템 설정** (또는 **시스템 환경설정**) 선택

#### Step 3: 사용자 권한 변경
1. **사용자 및 그룹** 클릭
2. **자물쇠 아이콘** 클릭 → **관리자 비밀번호 입력**
3. **ryanchoi** 계정 클릭
4. **"관리자 허용"** 체크박스 선택 ✅
5. **변경사항 저장**

#### Step 4: ryanchoi 계정으로 다시 로그인
1. **로그아웃**
2. **ryanchoi 계정으로 로그인**
3. **터미널에서 테스트**:
   ```bash
   sudo -v
   # 비밀번호 입력 후 "Sorry, user ryanchoi is not in the sudoers file" 메시지가 사라져야 함
   ```

## 🔍 권한 부여 확인 방법

### 방법 1: 터미널에서 확인
```bash
# ryanchoi 계정에서 실행
sudo -v
# 성공하면 "Password:" 프롬프트가 나타남
```

### 방법 2: 관리자 그룹 확인
```bash
# 관리자 그룹 멤버 확인
dscl . -read /Groups/admin GroupMembership
# 출력에 "ryanchoi"가 포함되어야 함
```

### 방법 3: CocoaPods 설치 테스트
```bash
# ryanchoi 계정에서 실행
sudo gem install cocoapods
# 성공하면 CocoaPods가 설치됨
```

## ⚠️ 주의사항

### 1. 관리자 비밀번호 필요
- bernard 계정의 비밀번호가 필요
- 시스템 설정 변경 시 필요

### 2. 보안 고려사항
- 관리자 권한 부여는 신중하게 결정
- 필요 시 임시 권한 부여 후 제거 고려

### 3. 백업 권장
- 중요한 작업 전 시스템 백업 권장
- Time Machine 백업 확인

## 🚀 권한 부여 후 작업 순서

### 1. 권한 확인
```bash
sudo -v
```

### 2. CocoaPods 설치
```bash
sudo gem install cocoapods
```

### 3. iOS 의존성 설치
```bash
cd ios
pod install
cd ..
```

### 4. iOS 빌드 테스트
```bash
flutter build ios --release --no-codesign
```

## 🔄 권한 제거 방법 (필요 시)

### GUI 방식
1. **시스템 설정** → **사용자 및 그룹**
2. **ryanchoi** 계정 선택
3. **"관리자 허용"** 체크박스 해제
4. **저장**

### 명령어 방식
```bash
# 관리자 계정에서 실행
sudo dscl . -delete /Groups/admin GroupMembership ryanchoi
```

## 📞 문제 해결

### 권한 부여가 안 되는 경우
1. **bernard 계정이 실제 관리자인지 확인**
2. **시스템 설정에서 자물쇠 해제 확인**
3. **관리자 비밀번호 정확성 확인**

### 여전히 sudo가 안 되는 경우
1. **계정 재로그인** 시도
2. **시스템 재시작** 후 확인
3. **관리자 계정에서 직접 CocoaPods 설치**

---

## 🎯 결론

**bernard 계정에서 ryanchoi에게 관리자 권한을 부여하면**:
1. ✅ sudo 명령어 사용 가능
2. ✅ CocoaPods 설치 가능  
3. ✅ iOS 빌드 완료 가능
4. ✅ App Store 배포 준비 완료

**가장 간단한 방법**: GUI 방식으로 시스템 설정에서 권한 부여! 🎉

