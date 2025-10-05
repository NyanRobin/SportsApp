# PostgreSQL 설정 가이드

스포츠 앱에서 PostgreSQL을 사용하기 위한 완전한 설정 가이드입니다.

## 1. PostgreSQL 설치

### macOS에서 설치

#### 방법 1: Homebrew 사용 (권장)
```bash
# Homebrew가 없다면 먼저 설치
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# PostgreSQL 설치
brew install postgresql

# PostgreSQL 서비스 시작
brew services start postgresql
```

#### 방법 2: PostgreSQL 공식 설치 프로그램
1. https://www.postgresql.org/download/macos/ 방문
2. macOS용 설치 프로그램 다운로드
3. 설치 프로그램 실행 후 지시사항 따르기

#### 방법 3: Postgres.app (가장 간단)
1. https://postgresapp.com/ 방문
2. Postgres.app 다운로드 및 설치
3. 애플리케이션 실행

## 2. PostgreSQL 초기 설정

### 데이터베이스 사용자 생성 (필요한 경우)
```bash
# PostgreSQL에 연결
psql postgres

# 새 사용자 생성 (선택사항)
CREATE USER sports_app_user WITH PASSWORD 'your_secure_password';

# 데이터베이스 생성 권한 부여
ALTER USER sports_app_user CREATEDB;

# 종료
\q
```

## 3. 환경 설정

### .env 파일 설정
`backend/.env` 파일에서 다음 값들을 수정하세요:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sports_app
DB_USER=postgres  # 또는 생성한 사용자명
DB_PASSWORD=your_password_here  # 실제 비밀번호로 변경

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key-here-change-this-in-production  # 실제 시크릿 키로 변경
```

**중요**: 프로덕션 환경에서는 반드시 강력한 비밀번호와 JWT 시크릿을 사용하세요!

## 4. 의존성 설치 및 데이터베이스 설정

### Node.js 의존성 설치
```bash
cd sports_app/backend
npm install
```

### 데이터베이스 설정 실행
```bash
# 데이터베이스 생성 및 테이블 생성
npm run setup-db
```

이 명령어는 다음 작업을 수행합니다:
- `sports_app` 데이터베이스 생성 (존재하지 않는 경우)
- 필요한 모든 테이블 생성
- 샘플 데이터 삽입

## 5. 서버 실행

### 개발 모드로 실행
```bash
npm run dev
```

### 프로덕션 모드로 실행
```bash
npm start
```

## 6. 데이터베이스 구조

생성되는 주요 테이블들:

### users
- 사용자 정보 저장
- Firebase UID를 기본 키로 사용

### teams
- 팀 정보 저장

### games
- 경기 정보 저장
- 홈팀, 원정팀, 점수 등

### announcements
- 공지사항 저장
- 태그별 분류

### game_stats
- 경기별 선수 통계

### notifications
- 사용자별 알림

## 7. 문제 해결

### 연결 오류 발생 시
1. PostgreSQL 서비스가 실행 중인지 확인:
   ```bash
   brew services list | grep postgresql
   ```

2. 포트 5432가 사용 중인지 확인:
   ```bash
   lsof -i :5432
   ```

3. 사용자 권한 확인:
   ```bash
   psql -U postgres -c "\du"
   ```

### 데이터베이스 재설정
```bash
# 데이터베이스 삭제 (주의: 모든 데이터가 삭제됩니다!)
psql postgres -c "DROP DATABASE IF EXISTS sports_app;"

# 다시 설정 실행
npm run setup-db
```

## 8. 보안 고려사항

### 프로덕션 환경에서:
1. 강력한 데이터베이스 비밀번호 사용
2. JWT_SECRET을 복잡한 랜덤 문자열로 변경
3. 데이터베이스 접근을 필요한 IP만으로 제한
4. SSL 연결 사용 고려

### 개발 환경에서:
1. `.env` 파일을 git에 커밋하지 않기 (이미 .gitignore에 포함됨)
2. 개발용 데이터베이스와 프로덕션 데이터베이스 분리

## 9. 유용한 PostgreSQL 명령어

```bash
# 데이터베이스 목록 확인
psql postgres -c "\l"

# 특정 데이터베이스에 연결
psql sports_app

# 테이블 목록 확인
\dt

# 특정 테이블 구조 확인
\d users

# SQL 쿼리 실행 예시
SELECT * FROM users LIMIT 5;

# 연결 종료
\q
```

## 10. Firebase와의 연동

현재 설정된 Firebase 프로젝트:
- Project ID: `sports-app-dc923`
- 인증은 Firebase에서 처리
- 사용자 데이터는 PostgreSQL에 저장

Firebase 인증 후 사용자 정보를 PostgreSQL에 동기화하는 로직이 구현되어 있습니다.
