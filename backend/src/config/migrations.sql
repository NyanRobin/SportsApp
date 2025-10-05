-- Sports App Database Schema
-- PostgreSQL 마이그레이션 파일

-- 사용자 테이블
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(255) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    is_student BOOLEAN DEFAULT false,
    grade_or_subject VARCHAR(100),
    profile_image_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 팀 테이블
CREATE TABLE IF NOT EXISTS teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    logo_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 사용자 팀 관계 테이블
CREATE TABLE IF NOT EXISTS user_teams (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES users(id) ON DELETE CASCADE,
    team_id INTEGER REFERENCES teams(id) ON DELETE CASCADE,
    role VARCHAR(50) DEFAULT 'member', -- 'coach', 'captain', 'member'
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, team_id)
);

-- 게임 테이블
CREATE TABLE IF NOT EXISTS games (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    home_team_id INTEGER REFERENCES teams(id),
    away_team_id INTEGER REFERENCES teams(id),
    home_team_name VARCHAR(255),
    away_team_name VARCHAR(255),
    game_date TIMESTAMP NOT NULL,
    venue VARCHAR(255),
    status VARCHAR(50) DEFAULT 'scheduled', -- 'scheduled', 'in_progress', 'completed', 'cancelled'
    home_score INTEGER DEFAULT 0,
    away_score INTEGER DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 게임 통계 테이블
CREATE TABLE IF NOT EXISTS game_stats (
    id SERIAL PRIMARY KEY,
    game_id INTEGER REFERENCES games(id) ON DELETE CASCADE,
    user_id VARCHAR(255) REFERENCES users(id) ON DELETE CASCADE,
    goals INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0,
    yellow_cards INTEGER DEFAULT 0,
    red_cards INTEGER DEFAULT 0,
    minutes_played INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, user_id)
);

-- 공지사항 테이블
CREATE TABLE IF NOT EXISTS announcements (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    tag VARCHAR(50) DEFAULT 'general', -- 'games', 'other', 'general'
    author_id VARCHAR(255) REFERENCES users(id),
    is_pinned BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 공지사항 첨부파일 테이블
CREATE TABLE IF NOT EXISTS announcement_attachments (
    id SERIAL PRIMARY KEY,
    announcement_id INTEGER REFERENCES announcements(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    file_type VARCHAR(50),
    file_size INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 사용자 프로필 확장 테이블
CREATE TABLE IF NOT EXISTS user_profiles (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    position VARCHAR(100),
    jersey_number INTEGER,
    height INTEGER, -- cm
    weight INTEGER, -- kg
    birth_date DATE,
    nationality VARCHAR(100),
    bio TEXT,
    achievements TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 사용자 통계 테이블
CREATE TABLE IF NOT EXISTS user_statistics (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    total_games INTEGER DEFAULT 0,
    total_goals INTEGER DEFAULT 0,
    total_assists INTEGER DEFAULT 0,
    total_yellow_cards INTEGER DEFAULT 0,
    total_red_cards INTEGER DEFAULT 0,
    total_minutes_played INTEGER DEFAULT 0,
    average_goals_per_game DECIMAL(4,2) DEFAULT 0,
    average_assists_per_game DECIMAL(4,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_games_date ON games(game_date);
CREATE INDEX IF NOT EXISTS idx_games_status ON games(status);
CREATE INDEX IF NOT EXISTS idx_announcements_created_at ON announcements(created_at);
CREATE INDEX IF NOT EXISTS idx_announcements_tag ON announcements(tag);
CREATE INDEX IF NOT EXISTS idx_game_stats_game_id ON game_stats(game_id);
CREATE INDEX IF NOT EXISTS idx_game_stats_user_id ON game_stats(user_id);
CREATE INDEX IF NOT EXISTS idx_user_teams_user_id ON user_teams(user_id);
CREATE INDEX IF NOT EXISTS idx_user_teams_team_id ON user_teams(team_id);

-- 트리거 함수: updated_at 자동 업데이트
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 트리거 생성
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_teams_updated_at BEFORE UPDATE ON teams FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_games_updated_at BEFORE UPDATE ON games FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_game_stats_updated_at BEFORE UPDATE ON game_stats FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_announcements_updated_at BEFORE UPDATE ON announcements FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_statistics_updated_at BEFORE UPDATE ON user_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column(); 