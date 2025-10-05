# Sports App Backend TODO List

## 🏗️ 프로젝트 구조 및 설정

### 1. 프로젝트 초기 설정
- [ ] Node.js/Express.js 또는 Django/FastAPI 프로젝트 생성
- [ ] TypeScript 설정 (Node.js 사용 시)
- [ ] 환경 변수 설정 (.env)
- [ ] CORS 설정
- [ ] 기본 미들웨어 설정 (logging, error handling)
- [ ] Docker 설정 (선택사항)

### 2. 데이터베이스 설정
- [ ] PostgreSQL 또는 MongoDB 설정
- [ ] 데이터베이스 연결 설정
- [ ] 마이그레이션 스크립트 작성
- [ ] 시드 데이터 작성

## 🔐 인증 및 사용자 관리

### 3. Firebase Auth 연동
- [ ] Firebase Admin SDK 설정
- [ ] JWT 토큰 검증 미들웨어
- [ ] 사용자 인증 상태 확인 API
- [ ] 토큰 갱신 API

### 4. 사용자 관리 API
- [ ] 사용자 프로필 조회 API (`GET /api/users/profile`)
- [ ] 사용자 프로필 수정 API (`PUT /api/users/profile`)
- [ ] 사용자 목록 조회 API (`GET /api/users`)
- [ ] 사용자 역할 관리 (학생/교사)
- [ ] 사용자 팀 관리

## 📊 게임 및 경기 관리

### 5. 게임 관리 API
- [ ] 게임 목록 조회 API (`GET /api/games`)
- [ ] 게임 상세 조회 API (`GET /api/games/:id`)
- [ ] 게임 생성 API (`POST /api/games`)
- [ ] 게임 수정 API (`PUT /api/games/:id`)
- [ ] 게임 삭제 API (`DELETE /api/games/:id`)
- [ ] 게임 상태 관리 (예정/진행중/완료)

### 6. 경기 준비 관리
- [ ] 경기 준비 상태 조회 API (`GET /api/games/:id/preparation`)
- [ ] 경기 준비 상태 업데이트 API (`PUT /api/games/:id/preparation`)
- [ ] 선수 출전 명단 관리
- [ ] 전술 및 포메이션 관리

### 7. 경기 결과 및 통계
- [ ] 경기 결과 입력 API (`POST /api/games/:id/result`)
- [ ] 개인 통계 입력 API (`POST /api/games/:id/stats`)
- [ ] 팀 통계 계산 및 저장
- [ ] 시즌 통계 집계

## 📢 공지사항 관리

### 8. 공지사항 API
- [ ] 공지사항 목록 조회 API (`GET /api/announcements`)
- [ ] 공지사항 상세 조회 API (`GET /api/announcements/:id`)
- [ ] 공지사항 생성 API (`POST /api/announcements`)
- [ ] 공지사항 수정 API (`PUT /api/announcements/:id`)
- [ ] 공지사항 삭제 API (`DELETE /api/announcements/:id`)
- [ ] 공지사항 카테고리별 필터링
- [ ] 공지사항 검색 기능

### 9. 첨부파일 관리
- [ ] 파일 업로드 API (`POST /api/attachments`)
- [ ] 파일 다운로드 API (`GET /api/attachments/:id`)
- [ ] 파일 삭제 API (`DELETE /api/attachments/:id`)
- [ ] 파일 저장소 설정 (AWS S3 또는 로컬)
- [ ] 파일 타입 검증
- [ ] 파일 크기 제한

## 📈 통계 및 분석

### 10. 개인 통계 API
- [ ] 개인 통계 조회 API (`GET /api/users/:id/stats`)
- [ ] 시즌별 통계 조회 API (`GET /api/users/:id/stats/season/:season`)
- [ ] 경기별 통계 조회 API (`GET /api/users/:id/stats/game/:gameId`)
- [ ] 통계 집계 및 계산 로직
- [ ] 성과 그래프 데이터 API

### 11. 팀 통계 API
- [ ] 팀 통계 조회 API (`GET /api/teams/:id/stats`)
- [ ] 팀 순위 조회 API (`GET /api/teams/rankings`)
- [ ] 팀 성과 분석 API
- [ ] 팀 간 비교 통계

### 12. 포지션 분석
- [ ] 포지션별 성과 분석 API
- [ ] 핫스팟 데이터 API
- [ ] 레이더 차트 데이터 API
- [ ] 성과 지표 계산

## 👥 팀 관리

### 13. 팀 관리 API
- [ ] 팀 목록 조회 API (`GET /api/teams`)
- [ ] 팀 상세 조회 API (`GET /api/teams/:id`)
- [ ] 팀 생성 API (`POST /api/teams`)
- [ ] 팀 수정 API (`PUT /api/teams/:id`)
- [ ] 팀 삭제 API (`DELETE /api/teams/:id`)

### 14. 팀 멤버 관리
- [ ] 팀 멤버 조회 API (`GET /api/teams/:id/members`)
- [ ] 팀 멤버 추가 API (`POST /api/teams/:id/members`)
- [ ] 팀 멤버 제거 API (`DELETE /api/teams/:id/members/:userId`)
- [ ] 팀 역할 관리 (주장, 부주장 등)

## 🔔 알림 시스템

### 15. 알림 관리
- [ ] 알림 생성 API (`POST /api/notifications`)
- [ ] 알림 목록 조회 API (`GET /api/notifications`)
- [ ] 알림 읽음 처리 API (`PUT /api/notifications/:id/read`)
- [ ] 알림 삭제 API (`DELETE /api/notifications/:id`)
- [ ] 푸시 알림 설정 관리

### 16. 실시간 알림
- [ ] WebSocket 설정
- [ ] 실시간 알림 전송
- [ ] 알림 구독 관리
- [ ] 연결 상태 관리

## 🛠️ 시스템 관리

### 17. 설정 관리
- [ ] 앱 설정 조회 API (`GET /api/settings`)
- [ ] 설정 수정 API (`PUT /api/settings`)
- [ ] 사용자별 설정 관리
- [ ] 시스템 기본값 관리

### 18. 로그 및 모니터링
- [ ] API 요청 로깅
- [ ] 에러 로깅 및 추적
- [ ] 성능 모니터링
- [ ] 사용량 통계

## 🔒 보안 및 권한

### 19. 권한 관리
- [ ] 역할 기반 접근 제어 (RBAC)
- [ ] API 권한 검증 미들웨어
- [ ] 관리자 권한 관리
- [ ] 팀별 권한 관리

### 20. 데이터 보안
- [ ] 데이터 암호화
- [ ] API 요청 제한 (Rate Limiting)
- [ ] 입력 데이터 검증
- [ ] SQL 인젝션 방지

## 📱 API 문서화

### 21. API 문서
- [ ] Swagger/OpenAPI 문서 작성
- [ ] API 엔드포인트 설명
- [ ] 요청/응답 예시
- [ ] 에러 코드 문서화

## 🧪 테스트

### 22. 테스트 작성
- [ ] 단위 테스트 작성
- [ ] 통합 테스트 작성
- [ ] API 테스트 작성
- [ ] 테스트 데이터 설정

## 🚀 배포 및 운영

### 23. 배포 설정
- [ ] CI/CD 파이프라인 설정
- [ ] 환경별 배포 설정 (개발/스테이징/프로덕션)
- [ ] 데이터베이스 마이그레이션 자동화
- [ ] 헬스체크 엔드포인트

### 24. 성능 최적화
- [ ] 데이터베이스 쿼리 최적화
- [ ] 캐싱 전략 구현 (Redis)
- [ ] API 응답 시간 최적화
- [ ] 데이터베이스 인덱싱

## 📊 데이터 모델

### 25. 데이터베이스 스키마
```sql
-- 사용자 테이블
CREATE TABLE users (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    is_student BOOLEAN DEFAULT true,
    grade_or_subject VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 팀 테이블
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 팀 멤버 테이블
CREATE TABLE team_members (
    id SERIAL PRIMARY KEY,
    team_id INTEGER REFERENCES teams(id),
    user_id VARCHAR(255) REFERENCES users(id),
    role VARCHAR(50) DEFAULT 'member',
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 게임 테이블
CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    home_team_id INTEGER REFERENCES teams(id),
    away_team_id INTEGER REFERENCES teams(id),
    game_date TIMESTAMP NOT NULL,
    venue VARCHAR(255),
    status VARCHAR(50) DEFAULT 'scheduled',
    home_score INTEGER DEFAULT 0,
    away_score INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 게임 통계 테이블
CREATE TABLE game_stats (
    id SERIAL PRIMARY KEY,
    game_id INTEGER REFERENCES games(id),
    user_id VARCHAR(255) REFERENCES users(id),
    goals INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0,
    yellow_cards INTEGER DEFAULT 0,
    red_cards INTEGER DEFAULT 0,
    minutes_played INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 공지사항 테이블
CREATE TABLE announcements (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    tag VARCHAR(50) NOT NULL,
    author_id VARCHAR(255) REFERENCES users(id),
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 첨부파일 테이블
CREATE TABLE attachments (
    id SERIAL PRIMARY KEY,
    announcement_id INTEGER REFERENCES announcements(id),
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER NOT NULL,
    file_type VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 알림 테이블
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 🎯 우선순위

### 높은 우선순위 (Phase 1)
1. 프로젝트 초기 설정
2. 데이터베이스 설정
3. Firebase Auth 연동
4. 사용자 관리 API
5. 게임 관리 API
6. 공지사항 API

### 중간 우선순위 (Phase 2)
7. 통계 및 분석 API
8. 팀 관리 API
9. 알림 시스템
10. 보안 및 권한

### 낮은 우선순위 (Phase 3)
11. 고급 기능 (실시간 알림, 고급 통계)
12. 성능 최적화
13. 모니터링 및 로깅
14. API 문서화

## 📝 참고사항

- 모든 API는 RESTful 원칙을 따름
- JWT 토큰 기반 인증 사용
- 에러 처리 및 로깅 필수
- 데이터 검증 및 보안 고려
- 확장 가능한 구조로 설계
- 테스트 코드 작성 필수 