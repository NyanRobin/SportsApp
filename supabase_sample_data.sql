-- FieldSync Sample Data for Supabase
-- Run this SQL in your Supabase SQL Editor

-- 1. Create Teams Table and Sample Data
CREATE TABLE IF NOT EXISTS teams (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    logo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample teams
INSERT INTO teams (name, description, logo_url) VALUES
('대한고등학교', '대한고등학교 축구부', 'https://example.com/logos/daehan.png'),
('강북고등학교', '강북고등학교 축구부', 'https://example.com/logos/gangbuk.png'),
('서울고등학교', '서울고등학교 축구부', 'https://example.com/logos/seoul.png'),
('부산고등학교', '부산고등학교 축구부', 'https://example.com/logos/busan.png'),
('인천고등학교', '인천고등학교 축구부', 'https://example.com/logos/incheon.png'),
('대구고등학교', '대구고등학교 축구부', 'https://example.com/logos/daegu.png');

-- 2. Create Users Table and Sample Data
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    position VARCHAR(100),
    jersey_number INTEGER,
    team_id UUID REFERENCES teams(id),
    is_student BOOLEAN DEFAULT true,
    grade_or_subject VARCHAR(100),
    avatar_url TEXT,
    phone VARCHAR(50),
    birthdate DATE,
    height_cm INTEGER,
    weight_kg INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample user profiles
INSERT INTO user_profiles (name, email, position, jersey_number, team_id, is_student, grade_or_subject, height_cm, weight_kg) VALUES
('김민석', 'minseok.kim@example.com', 'Forward', 10, (SELECT id FROM teams WHERE name = '대한고등학교'), true, '3학년', 175, 68),
('박지성', 'jisung.park@example.com', 'Midfielder', 7, (SELECT id FROM teams WHERE name = '강북고등학교'), true, '2학년', 172, 65),
('이준호', 'junho.lee@example.com', 'Forward', 9, (SELECT id FROM teams WHERE name = '서울고등학교'), true, '3학년', 178, 70),
('최재원', 'jaewon.choi@example.com', 'Midfielder', 8, (SELECT id FROM teams WHERE name = '서울고등학교'), true, '1학년', 170, 63),
('정태우', 'taewoo.jung@example.com', 'Defender', 4, (SELECT id FROM teams WHERE name = '대한고등학교'), true, '2학년', 180, 72),
('한승우', 'seungwoo.han@example.com', 'Goalkeeper', 1, (SELECT id FROM teams WHERE name = '부산고등학교'), true, '3학년', 185, 75),
('송민호', 'minho.song@example.com', 'Defender', 5, (SELECT id FROM teams WHERE name = '인천고등학교'), true, '2학년', 177, 69),
('윤상혁', 'sanghyuk.yoon@example.com', 'Midfielder', 6, (SELECT id FROM teams WHERE name = '대구고등학교'), true, '3학년', 174, 66);

-- 3. Create Games Table and Sample Data
CREATE TABLE IF NOT EXISTS games (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    home_team_id UUID REFERENCES teams(id) NOT NULL,
    away_team_id UUID REFERENCES teams(id) NOT NULL,
    game_date TIMESTAMP WITH TIME ZONE NOT NULL,
    venue VARCHAR(255),
    status VARCHAR(50) DEFAULT 'scheduled', -- scheduled, ongoing, completed, cancelled
    home_score INTEGER DEFAULT 0,
    away_score INTEGER DEFAULT 0,
    season VARCHAR(10) DEFAULT '2025',
    round_number INTEGER,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample games
INSERT INTO games (home_team_id, away_team_id, game_date, venue, status, home_score, away_score, season, round_number) VALUES
-- Completed games
((SELECT id FROM teams WHERE name = '대한고등학교'), (SELECT id FROM teams WHERE name = '강북고등학교'), NOW() - INTERVAL '2 hours', '대한고등학교 운동장', 'completed', 3, 1, '2025', 1),
((SELECT id FROM teams WHERE name = '서울고등학교'), (SELECT id FROM teams WHERE name = '대한고등학교'), NOW() - INTERVAL '1 day', '서울고등학교 운동장', 'completed', 2, 2, '2025', 2),
((SELECT id FROM teams WHERE name = '대한고등학교'), (SELECT id FROM teams WHERE name = '부산고등학교'), NOW() - INTERVAL '1 week', '대한고등학교 운동장', 'completed', 4, 0, '2025', 3),
((SELECT id FROM teams WHERE name = '인천고등학교'), (SELECT id FROM teams WHERE name = '강북고등학교'), NOW() - INTERVAL '3 days', '인천고등학교 운동장', 'completed', 1, 2, '2025', 4),
-- Upcoming games
((SELECT id FROM teams WHERE name = '강북고등학교'), (SELECT id FROM teams WHERE name = '서울고등학교'), NOW() + INTERVAL '3 days', '강북고등학교 운동장', 'scheduled', 0, 0, '2025', 5),
((SELECT id FROM teams WHERE name = '대한고등학교'), (SELECT id FROM teams WHERE name = '대구고등학교'), NOW() + INTERVAL '1 week', '대한고등학교 운동장', 'scheduled', 0, 0, '2025', 6),
((SELECT id FROM teams WHERE name = '부산고등학교'), (SELECT id FROM teams WHERE name = '인천고등학교'), NOW() + INTERVAL '10 days', '부산고등학교 운동장', 'scheduled', 0, 0, '2025', 7);

-- 4. Create Game Statistics Table
CREATE TABLE IF NOT EXISTS game_statistics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    game_id UUID REFERENCES games(id) ON DELETE CASCADE,
    player_id UUID REFERENCES user_profiles(id),
    goals INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0,
    shots INTEGER DEFAULT 0,
    shots_on_target INTEGER DEFAULT 0,
    passes INTEGER DEFAULT 0,
    passes_completed INTEGER DEFAULT 0,
    tackles INTEGER DEFAULT 0,
    fouls INTEGER DEFAULT 0,
    yellow_cards INTEGER DEFAULT 0,
    red_cards INTEGER DEFAULT 0,
    minutes_played INTEGER DEFAULT 0,
    rating DECIMAL(3,1),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample game statistics
INSERT INTO game_statistics (game_id, player_id, goals, assists, shots, shots_on_target, passes, passes_completed, tackles, minutes_played, rating) VALUES
-- Game 1: 대한고등학교 vs 강북고등학교 (3-1)
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), (SELECT id FROM user_profiles WHERE name = '김민석'), 2, 1, 5, 3, 45, 38, 2, 90, 8.5),
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), (SELECT id FROM user_profiles WHERE name = '정태우'), 1, 0, 2, 1, 52, 47, 5, 90, 7.8),
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), (SELECT id FROM user_profiles WHERE name = '박지성'), 1, 0, 3, 2, 48, 42, 3, 90, 7.5);

-- 5. Create Announcements Table and Sample Data
CREATE TABLE IF NOT EXISTS announcements (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id UUID REFERENCES user_profiles(id),
    tag VARCHAR(100) DEFAULT 'General',
    priority VARCHAR(50) DEFAULT 'normal', -- low, normal, high, urgent
    published_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    expires_at TIMESTAMP WITH TIME ZONE,
    is_pinned BOOLEAN DEFAULT false,
    team_id UUID REFERENCES teams(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample announcements
INSERT INTO announcements (title, content, tag, priority, is_pinned, team_id) VALUES
('이번 주 훈련 일정 변경', '안녕하세요. 이번 주 훈련 일정이 변경되었습니다. 화요일 훈련은 오후 4시로 변경되며, 목요일은 휴식일로 변경됩니다. 모든 선수들은 새로운 일정을 확인해 주세요.', 'Training', 'high', true, (SELECT id FROM teams WHERE name = '대한고등학교')),
('다음 경기 상대팀 분석 자료', '다음 주 강북고등학교와의 경기를 위한 상대팀 분석 자료를 공유합니다. 상대팀의 주요 전술과 핵심 선수들에 대한 정보를 포함하고 있습니다.', 'Games', 'normal', false, (SELECT id FROM teams WHERE name = '대한고등학교')),
('팀 저녁 식사 모임 안내', '이번 토요일 저녁 7시에 팀 전체 저녁 식사 모임이 있습니다. 장소는 학교 근처 한식당이며, 참석 여부를 코치에게 알려주세요.', 'Social', 'normal', false, null),
('새로운 유니폼 배급', '2025 시즌 새로운 유니폼이 도착했습니다. 내일부터 개인별로 수령 가능하며, 사이즈 확인 후 배급 예정입니다.', 'Equipment', 'normal', false, null),
('의료진 검진 일정', '선수들의 건강 관리를 위한 정기 의료진 검진이 다음 주 월요일에 예정되어 있습니다. 모든 선수는 필수 참석입니다.', 'Health', 'high', true, null),
('겨울 훈련 캠프 안내', '겨울 방학 기간 중 특별 훈련 캠프를 개최합니다. 기간은 1월 15일부터 25일까지이며, 참가 신청서를 제출해 주세요.', 'Training', 'normal', false, null);

-- 6. Create User Statistics Table
CREATE TABLE IF NOT EXISTS user_statistics (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id) ON DELETE CASCADE,
    season VARCHAR(10) DEFAULT '2025',
    games_played INTEGER DEFAULT 0,
    total_goals INTEGER DEFAULT 0,
    total_assists INTEGER DEFAULT 0,
    total_shots INTEGER DEFAULT 0,
    total_shots_on_target INTEGER DEFAULT 0,
    total_passes INTEGER DEFAULT 0,
    total_passes_completed INTEGER DEFAULT 0,
    total_tackles INTEGER DEFAULT 0,
    total_minutes_played INTEGER DEFAULT 0,
    average_rating DECIMAL(3,1),
    goals_per_game DECIMAL(4,2),
    assists_per_game DECIMAL(4,2),
    pass_accuracy DECIMAL(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample user statistics
INSERT INTO user_statistics (user_id, season, games_played, total_goals, total_assists, total_shots, total_shots_on_target, total_passes, total_passes_completed, total_tackles, total_minutes_played, average_rating, goals_per_game, assists_per_game, pass_accuracy) VALUES
((SELECT id FROM user_profiles WHERE name = '김민석'), '2025', 12, 15, 8, 48, 32, 420, 355, 18, 1080, 8.2, 1.25, 0.67, 84.52),
((SELECT id FROM user_profiles WHERE name = '박지성'), '2025', 11, 12, 15, 35, 25, 528, 467, 42, 990, 8.0, 1.09, 1.36, 88.45),
((SELECT id FROM user_profiles WHERE name = '이준호'), '2025', 10, 10, 6, 38, 26, 285, 243, 15, 900, 7.8, 1.00, 0.60, 85.26),
((SELECT id FROM user_profiles WHERE name = '최재원'), '2025', 9, 5, 12, 22, 16, 405, 365, 28, 810, 7.5, 0.56, 1.33, 90.12),
((SELECT id FROM user_profiles WHERE name = '정태우'), '2025', 11, 3, 4, 15, 8, 485, 437, 65, 990, 7.6, 0.27, 0.36, 90.10),
((SELECT id FROM user_profiles WHERE name = '한승우'), '2025', 8, 0, 0, 0, 0, 195, 167, 2, 720, 7.2, 0.00, 0.00, 85.64),
((SELECT id FROM user_profiles WHERE name = '송민호'), '2025', 10, 2, 3, 12, 7, 432, 389, 58, 900, 7.4, 0.20, 0.30, 90.05),
((SELECT id FROM user_profiles WHERE name = '윤상혁'), '2025', 9, 6, 9, 28, 19, 378, 335, 35, 810, 7.7, 0.67, 1.00, 88.62);

-- 7. Create Team Rankings Table
CREATE TABLE IF NOT EXISTS team_rankings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    team_id UUID REFERENCES teams(id) NOT NULL,
    season VARCHAR(10) DEFAULT '2025',
    total_games INTEGER DEFAULT 0,
    wins INTEGER DEFAULT 0,
    draws INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0,
    goals_for INTEGER DEFAULT 0,
    goals_against INTEGER DEFAULT 0,
    goal_difference INTEGER DEFAULT 0,
    points INTEGER DEFAULT 0,
    position INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample team rankings
INSERT INTO team_rankings (team_id, season, total_games, wins, draws, losses, goals_for, goals_against, goal_difference, points, position) VALUES
((SELECT id FROM teams WHERE name = '대한고등학교'), '2025', 12, 10, 1, 1, 35, 12, 23, 31, 1),
((SELECT id FROM teams WHERE name = '강북고등학교'), '2025', 11, 8, 2, 1, 28, 15, 13, 26, 2),
((SELECT id FROM teams WHERE name = '서울고등학교'), '2025', 10, 6, 2, 2, 22, 18, 4, 20, 3),
((SELECT id FROM teams WHERE name = '부산고등학교'), '2025', 9, 5, 1, 3, 18, 16, 2, 16, 4),
((SELECT id FROM teams WHERE name = '인천고등학교'), '2025', 10, 4, 2, 4, 15, 20, -5, 14, 5),
((SELECT id FROM teams WHERE name = '대구고등학교'), '2025', 8, 2, 2, 4, 12, 18, -6, 8, 6);

-- 8. Create Recent Activities Table
CREATE TABLE IF NOT EXISTS recent_activities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id),
    activity_type VARCHAR(50) NOT NULL, -- game, training, meeting, achievement, announcement, statistics, profile
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'completed', -- completed, ongoing, scheduled, cancelled
    activity_data JSONB,
    activity_date TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample recent activities
INSERT INTO recent_activities (user_id, activity_type, title, description, status, activity_data, activity_date) VALUES
((SELECT id FROM user_profiles WHERE name = '김민석'), 'game', '대한고등학교 vs 강북고등학교', '3-1 승리 • 2골 1도움', 'completed', '{"goals": 2, "assists": 1, "rating": 8.5}', NOW() - INTERVAL '2 hours'),
((SELECT id FROM user_profiles WHERE name = '김민석'), 'training', '개인 훈련 세션', '슈팅 연습 • 90분', 'completed', '{"duration": 90, "type": "shooting"}', NOW() - INTERVAL '1 day'),
((SELECT id FROM user_profiles WHERE name = '김민석'), 'achievement', '시즌 10골 달성!', '축하합니다! 이번 시즌 10골을 달성했습니다.', 'completed', '{"milestone": "10_goals", "season": "2025"}', NOW() - INTERVAL '1 day' - INTERVAL '5 hours'),
((SELECT id FROM user_profiles WHERE name = '박지성'), 'meeting', '팀 회의', '전술 토론 및 다음 경기 준비', 'completed', '{"topic": "tactics", "duration": 60}', NOW() - INTERVAL '2 days'),
((SELECT id FROM user_profiles WHERE name = '이준호'), 'game', '서울고등학교 vs 대한고등학교', '2-2 무승부 • 1골', 'completed', '{"goals": 1, "assists": 0, "rating": 7.5}', NOW() - INTERVAL '1 day'),
((SELECT id FROM user_profiles WHERE name = '정태우'), 'training', '팀 훈련', '전술 훈련 • 120분', 'completed', '{"duration": 120, "type": "tactics"}', NOW() - INTERVAL '3 days'),
((SELECT id FROM user_profiles WHERE name = '최재원'), 'achievement', '연속 5경기 출전', '꾸준한 출전으로 팀에 기여', 'completed', '{"milestone": "5_consecutive_games"}', NOW() - INTERVAL '1 week'),
((SELECT id FROM user_profiles WHERE name = '한승우'), 'training', '골키퍼 훈련', '반응속도 향상 훈련 • 60분', 'completed', '{"duration": 60, "type": "goalkeeper"}', NOW() - INTERVAL '2 days');

-- 9. Create Game Timeline Events Table
CREATE TABLE IF NOT EXISTS game_timeline_events (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    game_id UUID REFERENCES games(id) ON DELETE CASCADE,
    minute INTEGER NOT NULL,
    event_type VARCHAR(50) NOT NULL, -- goal, assist, yellow_card, red_card, substitution, kickoff, halftime, fulltime
    player_id UUID REFERENCES user_profiles(id),
    team_id UUID REFERENCES teams(id),
    description TEXT,
    additional_data JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample game timeline events
INSERT INTO game_timeline_events (game_id, minute, event_type, player_id, team_id, description, additional_data) VALUES
-- 대한고등학교 vs 강북고등학교 (3-1)
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), 0, 'kickoff', null, (SELECT id FROM teams WHERE name = '대한고등학교'), '경기 시작', '{}'),
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), 23, 'goal', (SELECT id FROM user_profiles WHERE name = '김민석'), (SELECT id FROM teams WHERE name = '대한고등학교'), '김민석 선제골', '{"assist": "정태우"}'),
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), 35, 'goal', (SELECT id FROM user_profiles WHERE name = '박지성'), (SELECT id FROM teams WHERE name = '강북고등학교'), '박지성 동점골', '{}'),
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), 45, 'halftime', null, null, '전반전 종료', '{}'),
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), 58, 'goal', (SELECT id FROM user_profiles WHERE name = '김민석'), (SELECT id FROM teams WHERE name = '대한고등학교'), '김민석 추가골', '{"assist": "정태우"}'),
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), 74, 'goal', (SELECT id FROM user_profiles WHERE name = '정태우'), (SELECT id FROM teams WHERE name = '대한고등학교'), '정태우 마지막 골', '{}'),
((SELECT id FROM games WHERE home_score = 3 AND away_score = 1), 90, 'fulltime', null, null, '경기 종료', '{}');

-- 10. Create Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES user_profiles(id),
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    notification_type VARCHAR(50) DEFAULT 'general', -- game, announcement, achievement, system, general
    data JSONB,
    is_read BOOLEAN DEFAULT false,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- Insert sample notifications
INSERT INTO notifications (user_id, title, body, notification_type, data, is_read, sent_at) VALUES
((SELECT id FROM user_profiles WHERE name = '김민석'), '경기 결과', '대한고등학교 vs 강북고등학교 3-1 승리!', 'game', '{"game_id": "' || (SELECT id FROM games WHERE home_score = 3 AND away_score = 1) || '"}', true, NOW() - INTERVAL '2 hours'),
((SELECT id FROM user_profiles WHERE name = '김민석'), '새로운 기록!', '축하합니다! 이번 시즌 15골을 달성했습니다.', 'achievement', '{"milestone": "15_goals"}', false, NOW() - INTERVAL '2 hours'),
((SELECT id FROM user_profiles WHERE name = '박지성'), '훈련 일정 변경', '이번 주 화요일 훈련이 오후 4시로 변경되었습니다.', 'announcement', '{}', false, NOW() - INTERVAL '3 hours'),
((SELECT id FROM user_profiles WHERE name = '이준호'), '다음 경기 안내', '강북고등학교와의 경기가 3일 후에 예정되어 있습니다.', 'game', '{}', false, NOW() - INTERVAL '1 day'),
((SELECT id FROM user_profiles WHERE name = '정태우'), '팀 저녁 식사', '토요일 저녁 7시 팀 전체 저녁 식사 모임이 있습니다.', 'announcement', '{}', true, NOW() - INTERVAL '2 days');

-- Enable Row Level Security (RLS) for all tables
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE games ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_rankings ENABLE ROW LEVEL SECURITY;
ALTER TABLE recent_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_timeline_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Create RLS policies (basic read access for authenticated users)
CREATE POLICY "Allow authenticated users to read teams" ON teams FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read user profiles" ON user_profiles FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read games" ON games FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read game statistics" ON game_statistics FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read announcements" ON announcements FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read user statistics" ON user_statistics FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read team rankings" ON team_rankings FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read recent activities" ON recent_activities FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read game timeline events" ON game_timeline_events FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated users to read notifications" ON notifications FOR SELECT TO authenticated USING (true);

-- Allow users to update their own profiles
CREATE POLICY "Allow users to update own profile" ON user_profiles FOR UPDATE TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Allow users to update own statistics" ON user_statistics FOR UPDATE TO authenticated USING (auth.uid() = user_id);
CREATE POLICY "Allow users to update own notifications" ON notifications FOR UPDATE TO authenticated USING (auth.uid() = user_id);

-- Create functions and triggers for updating timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = TIMEZONE('utc'::text, NOW());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Add triggers for updated_at columns
CREATE TRIGGER update_teams_updated_at BEFORE UPDATE ON teams FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_games_updated_at BEFORE UPDATE ON games FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_announcements_updated_at BEFORE UPDATE ON announcements FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_statistics_updated_at BEFORE UPDATE ON user_statistics FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_team_rankings_updated_at BEFORE UPDATE ON team_rankings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create views for easy data access
CREATE OR REPLACE VIEW top_scorers AS
SELECT 
    up.id as user_id,
    up.name as user_name,
    up.position,
    up.jersey_number,
    t.name as team_name,
    us.total_goals as goals,
    us.total_assists as assists,
    us.games_played as total_games,
    us.goals_per_game,
    us.average_rating,
    ROW_NUMBER() OVER (ORDER BY us.total_goals DESC, us.goals_per_game DESC) as rank
FROM user_statistics us
JOIN user_profiles up ON us.user_id = up.id
LEFT JOIN teams t ON up.team_id = t.id
WHERE us.season = '2025' AND us.games_played > 0
ORDER BY us.total_goals DESC, us.goals_per_game DESC;

CREATE OR REPLACE VIEW top_assisters AS
SELECT 
    up.id as user_id,
    up.name as user_name,
    up.position,
    up.jersey_number,
    t.name as team_name,
    us.total_assists as assists,
    us.total_goals as goals,
    us.games_played as total_games,
    us.assists_per_game,
    us.average_rating,
    ROW_NUMBER() OVER (ORDER BY us.total_assists DESC, us.assists_per_game DESC) as rank
FROM user_statistics us
JOIN user_profiles up ON us.user_id = up.id
LEFT JOIN teams t ON up.team_id = t.id
WHERE us.season = '2025' AND us.games_played > 0
ORDER BY us.total_assists DESC, us.assists_per_game DESC;

-- Sample data insertion complete!
-- You now have comprehensive sample data for all features of FieldSync




