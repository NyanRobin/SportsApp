-- FieldSync 샘플 데이터 확인 쿼리
-- Supabase SQL Editor에서 실행하여 데이터 확인

-- 1. 팀 데이터 확인
SELECT 'Teams' as table_name, COUNT(*) as record_count FROM teams
UNION ALL
-- 2. 사용자 프로필 확인  
SELECT 'User Profiles' as table_name, COUNT(*) as record_count FROM user_profiles
UNION ALL
-- 3. 경기 데이터 확인
SELECT 'Games' as table_name, COUNT(*) as record_count FROM games
UNION ALL
-- 4. 경기 통계 확인
SELECT 'Game Statistics' as table_name, COUNT(*) as record_count FROM game_statistics
UNION ALL
-- 5. 공지사항 확인
SELECT 'Announcements' as table_name, COUNT(*) as record_count FROM announcements
UNION ALL
-- 6. 사용자 통계 확인
SELECT 'User Statistics' as table_name, COUNT(*) as record_count FROM user_statistics
UNION ALL
-- 7. 팀 랭킹 확인
SELECT 'Team Rankings' as table_name, COUNT(*) as record_count FROM team_rankings
UNION ALL
-- 8. 최근 활동 확인
SELECT 'Recent Activities' as table_name, COUNT(*) as record_count FROM recent_activities
UNION ALL
-- 9. 타임라인 이벤트 확인
SELECT 'Timeline Events' as table_name, COUNT(*) as record_count FROM game_timeline_events
UNION ALL
-- 10. 알림 확인
SELECT 'Notifications' as table_name, COUNT(*) as record_count FROM notifications;

-- 상세 데이터 샘플 확인

-- 팀 목록
SELECT '=== TEAMS ===' as section;
SELECT name, description FROM teams ORDER BY name;

-- 선수 목록 (팀별)
SELECT '=== PLAYERS ===' as section;
SELECT 
    up.name,
    up.position,
    up.jersey_number,
    t.name as team_name
FROM user_profiles up
LEFT JOIN teams t ON up.team_id = t.id
ORDER BY t.name, up.jersey_number;

-- 경기 결과
SELECT '=== RECENT GAMES ===' as section;
SELECT 
    ht.name as home_team,
    at.name as away_team,
    g.home_score,
    g.away_score,
    g.status,
    g.game_date::date as game_date
FROM games g
JOIN teams ht ON g.home_team_id = ht.id
JOIN teams at ON g.away_team_id = at.id
ORDER BY g.game_date DESC;

-- 상위 득점자
SELECT '=== TOP SCORERS ===' as section;
SELECT 
    user_name,
    team_name,
    goals,
    assists,
    total_games,
    rank
FROM top_scorers
ORDER BY rank
LIMIT 5;

-- 팀 순위
SELECT '=== TEAM RANKINGS ===' as section;
SELECT 
    tr.position as rank,
    t.name as team_name,
    tr.points,
    tr.wins,
    tr.draws,
    tr.losses,
    tr.goal_difference
FROM team_rankings tr
JOIN teams t ON tr.team_id = t.id
ORDER BY tr.position;

-- 최근 활동
SELECT '=== RECENT ACTIVITIES ===' as section;
SELECT 
    ra.activity_type,
    ra.title,
    ra.description,
    up.name as user_name,
    ra.activity_date::date as activity_date
FROM recent_activities ra
LEFT JOIN user_profiles up ON ra.user_id = up.id
ORDER BY ra.activity_date DESC
LIMIT 5;

-- 공지사항
SELECT '=== ANNOUNCEMENTS ===' as section;
SELECT 
    title,
    tag,
    priority,
    is_pinned,
    published_at::date as published_date
FROM announcements
ORDER BY is_pinned DESC, published_at DESC;

-- 데이터 무결성 확인
SELECT '=== DATA INTEGRITY CHECKS ===' as section;

-- 1. 팀이 없는 선수 확인
SELECT 'Players without team' as check_name, COUNT(*) as issue_count
FROM user_profiles 
WHERE team_id IS NULL;

-- 2. 통계가 없는 선수 확인  
SELECT 'Players without statistics' as check_name, COUNT(*) as issue_count
FROM user_profiles up
LEFT JOIN user_statistics us ON up.id = us.user_id
WHERE us.user_id IS NULL;

-- 3. 홈팀과 어웨이팀이 같은 경기 확인
SELECT 'Games with same home/away team' as check_name, COUNT(*) as issue_count  
FROM games
WHERE home_team_id = away_team_id;

-- 4. 미래 날짜의 완료된 경기 확인
SELECT 'Completed games in future' as check_name, COUNT(*) as issue_count
FROM games
WHERE status = 'completed' AND game_date > NOW();

-- RLS 정책 확인
SELECT '=== RLS POLICIES ===' as section;
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;




