-- FieldSync Database Schema
-- Sports team management system with real-time features

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Teams table
CREATE TABLE teams (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    logo_url TEXT,
    description TEXT,
    founded_year INTEGER,
    home_venue TEXT,
    coach_name TEXT,
    contact_email TEXT,
    contact_phone TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User profiles table (extends Supabase auth.users)
CREATE TABLE user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    name TEXT NOT NULL,
    phone TEXT,
    birthdate DATE,
    position TEXT, -- e.g., 'Forward', 'Midfielder', 'Defender', 'Goalkeeper'
    jersey_number INTEGER,
    height_cm INTEGER,
    weight_kg INTEGER,
    is_student BOOLEAN DEFAULT TRUE,
    grade_or_subject TEXT, -- Grade for students, subject for teachers
    student_id TEXT,
    department TEXT, -- For teachers/staff
    avatar_url TEXT,
    team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
    role TEXT DEFAULT 'player', -- 'player', 'coach', 'admin', 'staff'
    permissions TEXT[] DEFAULT ARRAY['view_profile'],
    is_active BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id),
    UNIQUE(email)
);

-- Games table
CREATE TABLE games (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    home_team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    away_team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    game_date TIMESTAMP WITH TIME ZONE NOT NULL,
    venue TEXT NOT NULL,
    status TEXT DEFAULT 'scheduled', -- 'scheduled', 'live', 'finished', 'cancelled'
    home_score INTEGER DEFAULT 0,
    away_score INTEGER DEFAULT 0,
    home_formation TEXT,
    away_formation TEXT,
    weather_conditions TEXT,
    attendance INTEGER,
    referee_name TEXT,
    season TEXT NOT NULL DEFAULT '2025',
    round_number INTEGER,
    competition_type TEXT DEFAULT 'league', -- 'league', 'cup', 'friendly'
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Game events table (goals, cards, substitutions, etc.)
CREATE TABLE game_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    game_id UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    player_id UUID REFERENCES user_profiles(id) ON DELETE SET NULL,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    event_type TEXT NOT NULL, -- 'goal', 'yellow_card', 'red_card', 'substitution', 'own_goal'
    minute INTEGER NOT NULL,
    additional_time INTEGER DEFAULT 0,
    description TEXT,
    coordinates JSONB, -- Field position coordinates
    metadata JSONB, -- Additional event data
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Player game statistics
CREATE TABLE player_game_stats (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    game_id UUID NOT NULL REFERENCES games(id) ON DELETE CASCADE,
    player_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    position TEXT,
    minutes_played INTEGER DEFAULT 0,
    goals INTEGER DEFAULT 0,
    assists INTEGER DEFAULT 0,
    shots INTEGER DEFAULT 0,
    shots_on_target INTEGER DEFAULT 0,
    passes INTEGER DEFAULT 0,
    passes_completed INTEGER DEFAULT 0,
    tackles INTEGER DEFAULT 0,
    tackles_won INTEGER DEFAULT 0,
    fouls_committed INTEGER DEFAULT 0,
    fouls_suffered INTEGER DEFAULT 0,
    yellow_cards INTEGER DEFAULT 0,
    red_cards INTEGER DEFAULT 0,
    saves INTEGER DEFAULT 0, -- For goalkeepers
    rating DECIMAL(3,1), -- 1.0 to 10.0
    performance_data JSONB, -- Additional performance metrics
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(game_id, player_id)
);

-- Aggregated user statistics
CREATE TABLE user_statistics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    season TEXT NOT NULL DEFAULT '2025',
    team_id UUID REFERENCES teams(id) ON DELETE SET NULL,
    games_played INTEGER DEFAULT 0,
    total_goals INTEGER DEFAULT 0,
    total_assists INTEGER DEFAULT 0,
    total_shots INTEGER DEFAULT 0,
    total_shots_on_target INTEGER DEFAULT 0,
    total_passes INTEGER DEFAULT 0,
    total_passes_completed INTEGER DEFAULT 0,
    total_tackles INTEGER DEFAULT 0,
    total_tackles_won INTEGER DEFAULT 0,
    total_minutes_played INTEGER DEFAULT 0,
    total_yellow_cards INTEGER DEFAULT 0,
    total_red_cards INTEGER DEFAULT 0,
    total_saves INTEGER DEFAULT 0,
    average_rating DECIMAL(3,1),
    goals_per_game DECIMAL(4,2),
    assists_per_game DECIMAL(4,2),
    pass_accuracy DECIMAL(5,2), -- Percentage
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, season, team_id)
);

-- Announcements table
CREATE TABLE announcements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    team_id UUID REFERENCES teams(id) ON DELETE CASCADE, -- NULL for global announcements
    priority TEXT DEFAULT 'normal', -- 'low', 'normal', 'high', 'urgent'
    category TEXT DEFAULT 'general', -- 'general', 'game', 'training', 'administrative'
    target_audience TEXT[] DEFAULT ARRAY['all'], -- 'all', 'players', 'coaches', 'staff'
    is_pinned BOOLEAN DEFAULT FALSE,
    is_published BOOLEAN DEFAULT TRUE,
    publish_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expiry_date TIMESTAMP WITH TIME ZONE,
    attachments JSONB, -- File attachments metadata
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    notification_type TEXT NOT NULL, -- 'game', 'announcement', 'system', 'achievement'
    data JSONB, -- Additional notification data
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    read_at TIMESTAMP WITH TIME ZONE
);

-- Recent activities table (for activity feed)
CREATE TABLE recent_activities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    activity_type TEXT NOT NULL, -- 'goal_scored', 'game_played', 'announcement_posted', etc.
    title TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'completed', -- 'completed', 'pending', 'cancelled'
    activity_data JSONB, -- Additional activity metadata
    activity_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Team statistics table
CREATE TABLE team_statistics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    team_id UUID NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    season TEXT NOT NULL DEFAULT '2025',
    games_played INTEGER DEFAULT 0,
    wins INTEGER DEFAULT 0,
    draws INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0,
    goals_for INTEGER DEFAULT 0,
    goals_against INTEGER DEFAULT 0,
    goal_difference INTEGER DEFAULT 0,
    points INTEGER DEFAULT 0,
    clean_sheets INTEGER DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(team_id, season)
);

-- Chat messages table (for team communication)
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sender_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    team_id UUID REFERENCES teams(id) ON DELETE CASCADE,
    game_id UUID REFERENCES games(id) ON DELETE CASCADE,
    message_type TEXT DEFAULT 'text', -- 'text', 'image', 'file', 'system'
    content TEXT NOT NULL,
    metadata JSONB, -- File attachments, reply info, etc.
    is_edited BOOLEAN DEFAULT FALSE,
    is_deleted BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    edited_at TIMESTAMP WITH TIME ZONE
);

-- File uploads table
CREATE TABLE file_uploads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    uploader_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    filename TEXT NOT NULL,
    original_filename TEXT NOT NULL,
    file_type TEXT NOT NULL,
    file_size INTEGER NOT NULL,
    storage_path TEXT NOT NULL,
    public_url TEXT,
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Settings table (for app configuration)
CREATE TABLE app_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key TEXT NOT NULL UNIQUE,
    value JSONB NOT NULL,
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    updated_by UUID REFERENCES user_profiles(id),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for better performance
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_user_profiles_team_id ON user_profiles(team_id);
CREATE INDEX idx_user_profiles_role ON user_profiles(role);
CREATE INDEX idx_games_date ON games(game_date);
CREATE INDEX idx_games_status ON games(status);
CREATE INDEX idx_games_teams ON games(home_team_id, away_team_id);
CREATE INDEX idx_game_events_game_id ON game_events(game_id);
CREATE INDEX idx_game_events_player_id ON game_events(player_id);
CREATE INDEX idx_player_game_stats_game_id ON player_game_stats(game_id);
CREATE INDEX idx_player_game_stats_player_id ON player_game_stats(player_id);
CREATE INDEX idx_user_statistics_user_id ON user_statistics(user_id);
CREATE INDEX idx_user_statistics_season ON user_statistics(season);
CREATE INDEX idx_announcements_team_id ON announcements(team_id);
CREATE INDEX idx_announcements_published ON announcements(is_published, publish_date);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read);
CREATE INDEX idx_recent_activities_user_id ON recent_activities(user_id);
CREATE INDEX idx_recent_activities_date ON recent_activities(activity_date);
CREATE INDEX idx_chat_messages_team_id ON chat_messages(team_id);
CREATE INDEX idx_chat_messages_game_id ON chat_messages(game_id);
CREATE INDEX idx_chat_messages_sent_at ON chat_messages(sent_at);

-- Row Level Security (RLS) policies
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE games ENABLE ROW LEVEL SECURITY;
ALTER TABLE game_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE player_game_stats ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE recent_activities ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Basic RLS policies (these can be customized based on your needs)

-- Users can view their own profile and profiles of users in their team
CREATE POLICY "Users can view own profile" ON user_profiles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile" ON user_profiles
    FOR UPDATE USING (auth.uid() = user_id);

-- Everyone can view teams
CREATE POLICY "Everyone can view teams" ON teams
    FOR SELECT USING (true);

-- Everyone can view games
CREATE POLICY "Everyone can view games" ON games
    FOR SELECT USING (true);

-- Users can view game events for games involving their team
CREATE POLICY "Users can view game events" ON game_events
    FOR SELECT USING (true);

-- Users can view their own stats
CREATE POLICY "Users can view own stats" ON user_statistics
    FOR SELECT USING (
        user_id IN (
            SELECT id FROM user_profiles WHERE user_id = auth.uid()
        )
    );

-- Users can view announcements for their team or global announcements
CREATE POLICY "Users can view announcements" ON announcements
    FOR SELECT USING (
        is_published = true AND (
            team_id IS NULL OR 
            team_id IN (
                SELECT team_id FROM user_profiles WHERE user_id = auth.uid()
            )
        )
    );

-- Users can view their own notifications
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT USING (
        user_id IN (
            SELECT id FROM user_profiles WHERE user_id = auth.uid()
        )
    );

-- Users can update their own notifications (mark as read)
CREATE POLICY "Users can update own notifications" ON notifications
    FOR UPDATE USING (
        user_id IN (
            SELECT id FROM user_profiles WHERE user_id = auth.uid()
        )
    );

-- Users can view their own activities
CREATE POLICY "Users can view own activities" ON recent_activities
    FOR SELECT USING (
        user_id IN (
            SELECT id FROM user_profiles WHERE user_id = auth.uid()
        )
    );

-- Users can view chat messages for their team
CREATE POLICY "Users can view team chat" ON chat_messages
    FOR SELECT USING (
        team_id IN (
            SELECT team_id FROM user_profiles WHERE user_id = auth.uid()
        )
    );

-- Functions for updating timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers for updating timestamps
CREATE TRIGGER update_teams_updated_at BEFORE UPDATE ON teams
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_games_updated_at BEFORE UPDATE ON games
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_announcements_updated_at BEFORE UPDATE ON announcements
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_statistics_updated_at BEFORE UPDATE ON user_statistics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_team_statistics_updated_at BEFORE UPDATE ON team_statistics
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to calculate team statistics
CREATE OR REPLACE FUNCTION calculate_team_statistics(team_uuid UUID, season_year TEXT)
RETURNS VOID AS $$
DECLARE
    wins_count INTEGER;
    draws_count INTEGER;
    losses_count INTEGER;
    goals_for_count INTEGER;
    goals_against_count INTEGER;
    games_count INTEGER;
BEGIN
    -- Calculate wins, draws, losses
    SELECT 
        COUNT(*) FILTER (WHERE 
            (home_team_id = team_uuid AND home_score > away_score) OR 
            (away_team_id = team_uuid AND away_score > home_score)
        ),
        COUNT(*) FILTER (WHERE home_score = away_score),
        COUNT(*) FILTER (WHERE 
            (home_team_id = team_uuid AND home_score < away_score) OR 
            (away_team_id = team_uuid AND away_score < home_score)
        ),
        COUNT(*)
    INTO wins_count, draws_count, losses_count, games_count
    FROM games 
    WHERE (home_team_id = team_uuid OR away_team_id = team_uuid)
    AND season = season_year
    AND status = 'finished';

    -- Calculate goals for and against
    SELECT 
        SUM(CASE 
            WHEN home_team_id = team_uuid THEN home_score 
            WHEN away_team_id = team_uuid THEN away_score 
            ELSE 0 
        END),
        SUM(CASE 
            WHEN home_team_id = team_uuid THEN away_score 
            WHEN away_team_id = team_uuid THEN home_score 
            ELSE 0 
        END)
    INTO goals_for_count, goals_against_count
    FROM games 
    WHERE (home_team_id = team_uuid OR away_team_id = team_uuid)
    AND season = season_year
    AND status = 'finished';

    -- Insert or update team statistics
    INSERT INTO team_statistics (
        team_id, season, games_played, wins, draws, losses, 
        goals_for, goals_against, goal_difference, points
    ) VALUES (
        team_uuid, season_year, games_count, wins_count, draws_count, losses_count,
        COALESCE(goals_for_count, 0), COALESCE(goals_against_count, 0),
        COALESCE(goals_for_count, 0) - COALESCE(goals_against_count, 0),
        (wins_count * 3) + draws_count
    )
    ON CONFLICT (team_id, season) DO UPDATE SET
        games_played = EXCLUDED.games_played,
        wins = EXCLUDED.wins,
        draws = EXCLUDED.draws,
        losses = EXCLUDED.losses,
        goals_for = EXCLUDED.goals_for,
        goals_against = EXCLUDED.goals_against,
        goal_difference = EXCLUDED.goal_difference,
        points = EXCLUDED.points,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- Function to update user statistics after a game
CREATE OR REPLACE FUNCTION update_user_statistics()
RETURNS TRIGGER AS $$
BEGIN
    -- Update user statistics based on player_game_stats
    INSERT INTO user_statistics (
        user_id, season, team_id, games_played, total_goals, total_assists,
        total_shots, total_shots_on_target, total_passes, total_passes_completed,
        total_tackles, total_tackles_won, total_minutes_played,
        total_yellow_cards, total_red_cards, total_saves
    )
    SELECT 
        pgs.player_id, g.season, pgs.team_id,
        COUNT(*),
        SUM(pgs.goals),
        SUM(pgs.assists),
        SUM(pgs.shots),
        SUM(pgs.shots_on_target),
        SUM(pgs.passes),
        SUM(pgs.passes_completed),
        SUM(pgs.tackles),
        SUM(pgs.tackles_won),
        SUM(pgs.minutes_played),
        SUM(pgs.yellow_cards),
        SUM(pgs.red_cards),
        SUM(pgs.saves)
    FROM player_game_stats pgs
    JOIN games g ON pgs.game_id = g.id
    WHERE pgs.player_id = NEW.player_id
    GROUP BY pgs.player_id, g.season, pgs.team_id
    ON CONFLICT (user_id, season, team_id) DO UPDATE SET
        games_played = EXCLUDED.games_played,
        total_goals = EXCLUDED.total_goals,
        total_assists = EXCLUDED.total_assists,
        total_shots = EXCLUDED.total_shots,
        total_shots_on_target = EXCLUDED.total_shots_on_target,
        total_passes = EXCLUDED.total_passes,
        total_passes_completed = EXCLUDED.total_passes_completed,
        total_tackles = EXCLUDED.total_tackles,
        total_tackles_won = EXCLUDED.total_tackles_won,
        total_minutes_played = EXCLUDED.total_minutes_played,
        total_yellow_cards = EXCLUDED.total_yellow_cards,
        total_red_cards = EXCLUDED.total_red_cards,
        total_saves = EXCLUDED.total_saves,
        goals_per_game = CASE WHEN EXCLUDED.games_played > 0 THEN EXCLUDED.total_goals::decimal / EXCLUDED.games_played ELSE 0 END,
        assists_per_game = CASE WHEN EXCLUDED.games_played > 0 THEN EXCLUDED.total_assists::decimal / EXCLUDED.games_played ELSE 0 END,
        pass_accuracy = CASE WHEN EXCLUDED.total_passes > 0 THEN (EXCLUDED.total_passes_completed::decimal / EXCLUDED.total_passes) * 100 ELSE 0 END,
        updated_at = NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update user statistics when player game stats are inserted/updated
CREATE TRIGGER update_user_stats_trigger
    AFTER INSERT OR UPDATE ON player_game_stats
    FOR EACH ROW EXECUTE FUNCTION update_user_statistics();


