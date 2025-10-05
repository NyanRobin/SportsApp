-- FieldSync Sample Data
-- This file populates the database with sample data for development and testing

-- Sample teams
INSERT INTO teams (id, name, logo_url, description, founded_year, home_venue, coach_name, contact_email) VALUES
('11111111-1111-1111-1111-111111111111', 'Daehan High School', null, '대한고등학교 축구부', 1995, 'Daehan Stadium', 'Lee Junho', 'coach@daehan.edu'),
('22222222-2222-2222-2222-222222222222', 'Gangbuk High School', null, '강북고등학교 축구부', 1998, 'Gangbuk Sports Center', 'Kim Taehyun', 'coach@gangbuk.edu'),
('33333333-3333-3333-3333-333333333333', 'FieldSync FC', null, 'FieldSync 공식 팀', 2023, 'FieldSync Arena', 'Park Minseok', 'coach@fieldsync.app'),
('44444444-4444-4444-4444-444444444444', 'Seoul United', null, '서울 유나이티드', 2020, 'Seoul Stadium', 'Choi Seunghoon', 'coach@seoulu.com');

-- Sample user profiles (these will need actual auth.users entries in production)
INSERT INTO user_profiles (id, user_id, email, name, phone, position, jersey_number, is_student, grade_or_subject, team_id, role) VALUES
-- Players for Daehan High School
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'user1', 'kim.minseok@daehan.edu', 'Kim Minseok', '010-1234-5678', 'Forward', 10, true, '3학년 A반', '11111111-1111-1111-1111-111111111111', 'player'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'user2', 'park.jisung@daehan.edu', 'Park Jisung', '010-2345-6789', 'Midfielder', 8, true, '2학년 B반', '11111111-1111-1111-1111-111111111111', 'player'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', 'user3', 'lee.junho@daehan.edu', 'Lee Junho', '010-3456-7890', null, null, false, 'Physical Education', '11111111-1111-1111-1111-111111111111', 'coach'),

-- Players for Gangbuk High School
('dddddddd-dddd-dddd-dddd-dddddddddddd', 'user4', 'choi.minho@gangbuk.edu', 'Choi Minho', '010-4567-8901', 'Defender', 5, true, '3학년 C반', '22222222-2222-2222-2222-222222222222', 'player'),
('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'user5', 'song.kyuhyun@gangbuk.edu', 'Song Kyuhyun', '010-5678-9012', 'Goalkeeper', 1, true, '2학년 A반', '22222222-2222-2222-2222-222222222222', 'player'),

-- FieldSync FC team
('ffffffff-ffff-ffff-ffff-ffffffffffff', 'user6', 'admin@fieldsync.app', 'Admin User', '010-6789-0123', 'Forward', 7, false, 'Software Development', '33333333-3333-3333-3333-333333333333', 'admin'),
('gggggggg-gggg-gggg-gggg-gggggggggggg', 'user7', 'player@fieldsync.app', 'Test Player', '010-7890-1234', 'Midfielder', 11, true, '1학년 A반', '33333333-3333-3333-3333-333333333333', 'player');

-- Sample games
INSERT INTO games (id, home_team_id, away_team_id, game_date, venue, status, home_score, away_score, season, round_number) VALUES
-- Completed games
('g1111111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', '2025-01-15 15:00:00+09', 'Daehan Stadium', 'finished', 3, 1, '2025', 1),
('g2222222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333', '2025-01-10 14:00:00+09', 'Gangbuk Sports Center', 'finished', 2, 2, '2025', 1),
('g3333333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', '44444444-4444-4444-4444-444444444444', '2025-01-08 16:00:00+09', 'FieldSync Arena', 'finished', 4, 0, '2025', 1),

-- Upcoming games
('g4444444-4444-4444-4444-444444444444', '11111111-1111-1111-1111-111111111111', '33333333-3333-3333-3333-333333333333', '2025-01-25 15:00:00+09', 'Daehan Stadium', 'scheduled', 0, 0, '2025', 2),
('g5555555-5555-5555-5555-555555555555', '44444444-4444-4444-4444-444444444444', '22222222-2222-2222-2222-222222222222', '2025-01-28 14:30:00+09', 'Seoul Stadium', 'scheduled', 0, 0, '2025', 2);

-- Sample game events
INSERT INTO game_events (id, game_id, player_id, team_id, event_type, minute, description) VALUES
-- Events for game 1 (Daehan vs Gangbuk)
('e1111111-1111-1111-1111-111111111111', 'g1111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'goal', 15, 'Great strike from outside the box'),
('e2222222-2222-2222-2222-222222222222', 'g1111111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'goal', 32, 'Header from corner kick'),
('e3333333-3333-3333-3333-333333333333', 'g1111111-1111-1111-1111-111111111111', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '22222222-2222-2222-2222-222222222222', 'goal', 45, 'Free kick goal'),
('e4444444-4444-4444-4444-444444444444', 'g1111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'goal', 78, 'Counter attack finish'),
('e5555555-5555-5555-5555-555555555555', 'g1111111-1111-1111-1111-111111111111', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '22222222-2222-2222-2222-222222222222', 'yellow_card', 85, 'Tactical foul');

-- Sample player game statistics
INSERT INTO player_game_stats (id, game_id, player_id, team_id, position, minutes_played, goals, assists, shots, shots_on_target, passes, passes_completed, rating) VALUES
-- Daehan players in game 1
('s1111111-1111-1111-1111-111111111111', 'g1111111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Forward', 90, 2, 0, 5, 3, 35, 28, 8.5),
('s2222222-2222-2222-2222-222222222222', 'g1111111-1111-1111-1111-111111111111', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'Midfielder', 90, 1, 1, 3, 2, 65, 52, 7.8),

-- Gangbuk players in game 1
('s3333333-3333-3333-3333-333333333333', 'g1111111-1111-1111-1111-111111111111', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '22222222-2222-2222-2222-222222222222', 'Defender', 90, 1, 0, 2, 1, 45, 38, 7.2),
('s4444444-4444-4444-4444-444444444444', 'g1111111-1111-1111-1111-111111111111', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '22222222-2222-2222-2222-222222222222', 'Goalkeeper', 90, 0, 0, 0, 0, 25, 20, 6.5);

-- Sample user statistics (aggregated)
INSERT INTO user_statistics (id, user_id, season, team_id, games_played, total_goals, total_assists, total_shots, total_shots_on_target, total_passes, total_passes_completed, total_minutes_played, average_rating, goals_per_game, assists_per_game, pass_accuracy) VALUES
('stat1111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '2025', '11111111-1111-1111-1111-111111111111', 15, 12, 8, 45, 28, 425, 340, 1350, 8.2, 0.8, 0.53, 80.0),
('stat2222-2222-2222-2222-222222222222', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '2025', '11111111-1111-1111-1111-111111111111', 12, 8, 15, 35, 20, 650, 520, 1080, 7.9, 0.67, 1.25, 80.0),
('stat3333-3333-3333-3333-333333333333', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '2025', '22222222-2222-2222-2222-222222222222', 14, 3, 2, 18, 8, 420, 350, 1260, 7.1, 0.21, 0.14, 83.3),
('stat4444-4444-4444-4444-444444444444', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '2025', '22222222-2222-2222-2222-222222222222', 13, 0, 0, 0, 0, 285, 245, 1170, 6.8, 0.0, 0.0, 86.0);

-- Sample team statistics
INSERT INTO team_statistics (id, team_id, season, games_played, wins, draws, losses, goals_for, goals_against, goal_difference, points) VALUES
('tstat111-1111-1111-1111-111111111111', '11111111-1111-1111-1111-111111111111', '2025', 8, 5, 2, 1, 18, 8, 10, 17),
('tstat222-2222-2222-2222-222222222222', '22222222-2222-2222-2222-222222222222', '2025', 8, 3, 3, 2, 12, 10, 2, 12),
('tstat333-3333-3333-3333-333333333333', '33333333-3333-3333-3333-333333333333', '2025', 7, 4, 1, 2, 15, 9, 6, 13),
('tstat444-4444-4444-4444-444444444444', '44444444-4444-4444-4444-444444444444', '2025', 7, 2, 1, 4, 8, 15, -7, 7);

-- Sample announcements
INSERT INTO announcements (id, title, content, author_id, team_id, priority, category, is_pinned) VALUES
('ann11111-1111-1111-1111-111111111111', '다음 경기 일정 안내', '대한고등학교와의 경기가 1월 25일 오후 3시에 예정되어 있습니다. 모든 선수는 2시까지 경기장에 도착해 주세요.', 'cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111', 'high', 'game', true),
('ann22222-2222-2222-2222-222222222222', '훈련 일정 변경', '이번 주 화요일 훈련이 우천으로 인해 실내로 변경됩니다.', 'cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111', 'normal', 'training', false),
('ann33333-3333-3333-3333-333333333333', 'FieldSync 앱 업데이트', 'FieldSync 모바일 앱이 새로운 기능과 함께 업데이트되었습니다. 앱스토어에서 업데이트해 주세요.', 'ffffffff-ffff-ffff-ffff-ffffffffffff', null, 'normal', 'general', false),
('ann44444-4444-4444-4444-444444444444', '시즌 성과 발표', '2024시즌이 성공적으로 마무리되었습니다. 모든 선수들의 노고에 감사드립니다.', 'ffffffff-ffff-ffff-ffff-ffffffffffff', null, 'low', 'general', false);

-- Sample notifications
INSERT INTO notifications (id, user_id, title, body, notification_type, is_read) VALUES
('not11111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '골 기록!', '오늘 경기에서 2골을 기록했습니다. 축하합니다!', 'achievement', false),
('not22222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '다음 경기 안내', '1월 25일 경기 준비를 시작해 주세요.', 'game', true),
('not33333-3333-3333-3333-333333333333', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '새로운 공지사항', '훈련 일정이 변경되었습니다.', 'announcement', false),
('not44444-4444-4444-4444-444444444444', 'dddddddd-dddd-dddd-dddd-dddddddddddd', '경고카드 주의', '이번 경기에서 옐로카드를 받았습니다. 다음 경기 시 주의하세요.', 'system', true);

-- Sample recent activities
INSERT INTO recent_activities (id, user_id, activity_type, title, description, status, activity_date) VALUES
('act11111-1111-1111-1111-111111111111', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'goal_scored', '골 득점', 'vs 강북고등학교 - 15분', 'completed', '2025-01-15 15:15:00+09'),
('act22222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'goal_scored', '골 득점', 'vs 강북고등학교 - 78분', 'completed', '2025-01-15 16:18:00+09'),
('act33333-3333-3333-3333-333333333333', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'assist', '어시스트', 'vs 강북고등학교 - 32분', 'completed', '2025-01-15 15:32:00+09'),
('act44444-4444-4444-4444-444444444444', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'game_played', '경기 출전', 'vs 강북고등학교 (90분 출전)', 'completed', '2025-01-15 16:30:00+09'),
('act55555-5555-5555-5555-555555555555', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'goal_scored', '골 득점', 'vs 대한고등학교 - 45분', 'completed', '2025-01-15 15:45:00+09'),
('act66666-6666-6666-6666-666666666666', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'training', '훈련 참가', '전술 훈련 완료', 'completed', '2025-01-14 17:00:00+09'),
('act77777-7777-7777-7777-777777777777', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'training', '훈련 참가', '체력 훈련 완료', 'completed', '2025-01-14 17:00:00+09');

-- Sample chat messages
INSERT INTO chat_messages (id, sender_id, team_id, message_type, content) VALUES
('msg11111-1111-1111-1111-111111111111', 'cccccccc-cccc-cccc-cccc-cccccccccccc', '11111111-1111-1111-1111-111111111111', 'text', '내일 훈련 시간이 30분 앞당겨집니다. 모두 참고해 주세요.'),
('msg22222-2222-2222-2222-222222222222', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'text', '네, 알겠습니다!'),
('msg33333-3333-3333-3333-333333333333', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '11111111-1111-1111-1111-111111111111', 'text', '오늘 경기 정말 수고하셨습니다 👏'),
('msg44444-4444-4444-4444-444444444444', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'text', '다음 경기도 열심히 준비하겠습니다!');

-- Sample app settings
INSERT INTO app_settings (id, key, value, description, is_public) VALUES
('set11111-1111-1111-1111-111111111111', 'app_version', '"1.0.0"', '현재 앱 버전', true),
('set22222-2222-2222-2222-222222222222', 'maintenance_mode', 'false', '점검 모드 설정', false),
('set33333-3333-3333-3333-333333333333', 'current_season', '"2025"', '현재 시즌', true),
('set44444-4444-4444-4444-444444444444', 'max_team_size', '30', '팀 최대 인원', true),
('set55555-5555-5555-5555-555555555555', 'game_duration_minutes', '90', '경기 시간 (분)', true);


