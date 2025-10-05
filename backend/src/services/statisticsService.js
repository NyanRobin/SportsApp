const { Pool } = require('pg');

// Database connection with fallback
let pool;
try {
  pool = new Pool({
    connectionString: process.env.DATABASE_URL || 'postgresql://localhost:5432/sports_app'
  });
} catch (error) {
  console.warn('Database connection failed, using mock data');
  pool = null;
}

class StatisticsService {
  constructor() {
    this.pool = pool;
  }

  // Fallback mock data when database is not available
  _getMockTopScorers() {
    return [
      {
        rank: 1,
    user_id: 'user1', 
        user_name: 'Kim Junyoung',
        is_student: true,
        grade_or_subject: '3학년',
        position: 'Forward',
        jersey_number: 10,
    team_name: 'Daehan High School',
        goals: 15,
    assists: 8,
        total_games: 10,
        total_minutes: 900,
        goals_per_game: 1.5
  },
  { 
        rank: 2,
    user_id: 'user2', 
    user_name: 'Park Jisung', 
        is_student: true,
        grade_or_subject: '2학년',
        position: 'Midfielder',
        jersey_number: 8,
        team_name: 'Seoul High School',
        goals: 12,
        assists: 6,
        total_games: 10,
        total_minutes: 850,
        goals_per_game: 1.2
      },
      {
        rank: 3,
    user_id: 'user3', 
        user_name: 'Lee Minjae',
        is_student: true,
        grade_or_subject: '3학년',
        position: 'Defender',
        jersey_number: 4,
        team_name: 'Busan High School',
        goals: 10,
    assists: 4,
    total_games: 10, 
        total_minutes: 900,
        goals_per_game: 1.0
      },
      {
        rank: 4,
    user_id: 'user4', 
    user_name: 'Choi Jaewon', 
        is_student: true,
        grade_or_subject: '1학년',
        position: 'Midfielder',
        jersey_number: 6,
        team_name: 'Daegu High School',
        goals: 9,
        assists: 7,
        total_games: 10,
        total_minutes: 880,
        goals_per_game: 0.9
      },
      {
        rank: 5,
        user_id: 'user5',
        user_name: 'Song Heungmin',
        is_student: true,
        grade_or_subject: '2학년',
        position: 'Forward',
        jersey_number: 9,
        team_name: 'Incheon High School',
        goals: 8,
        assists: 5,
        total_games: 10,
        total_minutes: 800,
        goals_per_game: 0.8
      }
    ];
  }

  _getMockTopAssisters() {
    return [
      {
        rank: 1,
        user_id: 'user2',
        user_name: 'Park Jisung',
        is_student: true,
        grade_or_subject: '2학년',
        position: 'Midfielder',
        jersey_number: 8,
        team_name: 'Seoul High School',
        goals: 12,
        assists: 18,
        total_games: 10,
        total_minutes: 850,
        assists_per_game: 1.8
      },
      {
        rank: 2,
        user_id: 'user1',
        user_name: 'Kim Junyoung',
        is_student: true,
        grade_or_subject: '3학년',
        position: 'Forward',
        jersey_number: 10,
        team_name: 'Daehan High School',
        goals: 15,
        assists: 14,
        total_games: 10,
        total_minutes: 900,
        assists_per_game: 1.4
      },
      {
        rank: 3,
        user_id: 'user4',
        user_name: 'Choi Jaewon',
        is_student: true,
        grade_or_subject: '1학년',
        position: 'Midfielder',
        jersey_number: 6,
        team_name: 'Daegu High School',
        goals: 9,
        assists: 12,
        total_games: 10,
        total_minutes: 880,
        assists_per_game: 1.2
      }
    ];
  }

  _getMockTeamRankings() {
    return [
      {
        rank: 1,
        team_id: 1,
        team_name: 'Daehan High School',
        description: 'Championship winners 2024',
        logo_url: null,
        total_games: 10,
        completed_games: 10,
        wins: 8,
        losses: 1,
        draws: 1,
        goals_for: 24,
        goals_against: 8,
        goal_difference: 16,
        points: 25,
        win_rate: 80.0
      },
      {
        rank: 2,
        team_id: 2,
        team_name: 'Seoul High School',
        description: 'Strong offensive team',
        logo_url: null,
        total_games: 10,
        completed_games: 10,
        wins: 6,
        losses: 2,
        draws: 2,
        goals_for: 20,
        goals_against: 12,
        goal_difference: 8,
        points: 20,
        win_rate: 60.0
      },
      {
        rank: 3,
        team_id: 3,
        team_name: 'Busan High School',
        description: 'Defensive specialists',
        logo_url: null,
        total_games: 10,
        completed_games: 10,
        wins: 5,
        losses: 3,
        draws: 2,
        goals_for: 18,
        goals_against: 15,
        goal_difference: 3,
        points: 17,
        win_rate: 50.0
      }
    ];
  }

  _getMockUserStats(userId) {
    return {
      user_id: userId,
      user_name: '김민수',
      is_student: true,
      grade_or_subject: '3학년 A반',
      position: 'Forward',
      jersey_number: 10,
      games_played: 15,
      total_goals: 12,
      total_assists: 8,
      total_yellow_cards: 2,
      total_red_cards: 0,
      total_minutes_played: 1200,
      avg_goals_per_game: 0.8,
      avg_assists_per_game: 0.53
    };
  }

  _getMockTeamStats(teamId) {
    return {
      team_id: teamId,
      team_name: 'Daehan High School',
      total_games: 15,
      wins: 12,
      losses: 2,
      draws: 1,
      goals_for: 35,
      goals_against: 12,
      goal_difference: 23,
      points: 37,
      win_rate: 80.0,
      top_scorers: [
        { player_name: '김민수', goals: 12 },
        { player_name: '박준호', goals: 8 },
        { player_name: '이승우', goals: 7 }
      ],
      recent_form: ['W', 'W', 'W', 'D', 'W'] // Last 5 games
    };
  }

  // Get user statistics (individual player stats)
  async getUserStats(userId, season = null) {
    try {
      // Use mock data if database is not available
      if (!this.pool) {
        console.log('Using mock data for user stats - no database connection');
        return this._getMockUserStats(userId);
      }

      // Test database connection
      try {
        await this.pool.query('SELECT 1');
      } catch (dbError) {
        console.error('Database connection test failed for user stats, using mock data:', dbError.message);
        return this._getMockUserStats(userId);
      }

      let query = `
        SELECT 
          u.id as user_id,
          u.name as user_name,
          u.is_student,
          u.grade_or_subject,
          up.position,
          up.jersey_number,
          COALESCE(us.total_games, 0) as games_played,
          COALESCE(us.total_goals, 0) as total_goals,
          COALESCE(us.total_assists, 0) as total_assists,
          COALESCE(us.total_yellow_cards, 0) as total_yellow_cards,
          COALESCE(us.total_red_cards, 0) as total_red_cards,
          COALESCE(us.total_minutes_played, 0) as total_minutes_played,
          COALESCE(us.average_goals_per_game, 0) as avg_goals_per_game,
          COALESCE(us.average_assists_per_game, 0) as avg_assists_per_game
        FROM users u
        LEFT JOIN user_profiles up ON u.id = up.user_id
        LEFT JOIN user_statistics us ON u.id = us.user_id
        WHERE u.id = $1
      `;

      const result = await this.pool.query(query, [userId]);
      
      if (result.rows.length === 0) {
        return null;
      }

      const userStats = result.rows[0];

      // If season is specified, get season-specific stats
      if (season) {
        const seasonQuery = `
          SELECT 
            COUNT(DISTINCT gs.game_id) as games_played,
            COALESCE(SUM(gs.goals), 0) as total_goals,
            COALESCE(SUM(gs.assists), 0) as total_assists,
            COALESCE(SUM(gs.yellow_cards), 0) as total_yellow_cards,
            COALESCE(SUM(gs.red_cards), 0) as total_red_cards,
            COALESCE(SUM(gs.minutes_played), 0) as total_minutes_played,
            CASE 
              WHEN COUNT(DISTINCT gs.game_id) > 0 
              THEN ROUND(COALESCE(SUM(gs.goals), 0)::decimal / COUNT(DISTINCT gs.game_id), 2)
              ELSE 0 
            END as avg_goals_per_game,
            CASE 
              WHEN COUNT(DISTINCT gs.game_id) > 0 
              THEN ROUND(COALESCE(SUM(gs.assists), 0)::decimal / COUNT(DISTINCT gs.game_id), 2)
              ELSE 0 
            END as avg_assists_per_game
          FROM game_stats gs
          JOIN games g ON gs.game_id = g.id
          WHERE gs.user_id = $1 AND EXTRACT(YEAR FROM g.game_date) = $2
        `;

        const seasonResult = await this.pool.query(seasonQuery, [userId, season]);
        if (seasonResult.rows.length > 0) {
          const seasonStats = seasonResult.rows[0];
          userStats.games_played = parseInt(seasonStats.games_played);
          userStats.total_goals = parseInt(seasonStats.total_goals);
          userStats.total_assists = parseInt(seasonStats.total_assists);
          userStats.total_yellow_cards = parseInt(seasonStats.total_yellow_cards);
          userStats.total_red_cards = parseInt(seasonStats.total_red_cards);
          userStats.total_minutes_played = parseInt(seasonStats.total_minutes_played);
          userStats.avg_goals_per_game = parseFloat(seasonStats.avg_goals_per_game);
          userStats.avg_assists_per_game = parseFloat(seasonStats.avg_assists_per_game);
        }
      }

      return userStats;
    } catch (error) {
      console.error('Error getting user stats from database, using mock data:', error);
      return this._getMockUserStats(userId);
    }
  }

  // Get top scorers
  async getTopScorers(limit = 10, season = null) {
    try {
      // Use mock data if database is not available
      if (!this.pool) {
        console.log('Using mock data - no database connection');
        return this._getMockTopScorers().slice(0, limit);
      }

      // Test database connection
      try {
        await this.pool.query('SELECT 1');
      } catch (dbError) {
        console.log('Database connection failed, using mock data:', dbError.message);
        return this._getMockTopScorers().slice(0, limit);
      }

      let query = `
        SELECT 
          u.id as user_id,
          u.name as user_name,
          u.is_student,
          u.grade_or_subject,
          up.position,
          up.jersey_number,
          t.name as team_name,
          COUNT(DISTINCT gs.game_id) as total_games,
          COALESCE(SUM(gs.goals), 0) as goals,
          COALESCE(SUM(gs.assists), 0) as assists,
          COALESCE(SUM(gs.minutes_played), 0) as total_minutes,
          CASE 
            WHEN COUNT(DISTINCT gs.game_id) > 0 
            THEN ROUND(COALESCE(SUM(gs.goals), 0)::decimal / COUNT(DISTINCT gs.game_id), 2)
            ELSE 0 
          END as goals_per_game
        FROM users u
        LEFT JOIN user_profiles up ON u.id = up.user_id
        LEFT JOIN user_teams ut ON u.id = ut.user_id
        LEFT JOIN teams t ON ut.team_id = t.id
        LEFT JOIN game_stats gs ON u.id = gs.user_id
        LEFT JOIN games g ON gs.game_id = g.id
      `;

      let params = [];
      let whereClause = '';

      if (season) {
        whereClause = ' WHERE EXTRACT(YEAR FROM g.game_date) = $1';
        params.push(season);
      }

      query += whereClause + `
        GROUP BY u.id, u.name, u.is_student, u.grade_or_subject, up.position, up.jersey_number, t.name
        HAVING COALESCE(SUM(gs.goals), 0) > 0
        ORDER BY goals DESC, goals_per_game DESC, assists DESC
        LIMIT $${params.length + 1}
      `;

      params.push(limit);

      const result = await this.pool.query(query, params);
      
      return result.rows.map((row, index) => ({
        rank: index + 1,
        user_id: row.user_id,
        user_name: row.user_name,
        is_student: row.is_student,
        grade_or_subject: row.grade_or_subject,
        position: row.position,
        jersey_number: row.jersey_number,
        team_name: row.team_name,
        goals: parseInt(row.goals),
        assists: parseInt(row.assists),
        total_games: parseInt(row.total_games),
        total_minutes: parseInt(row.total_minutes),
        goals_per_game: parseFloat(row.goals_per_game)
      }));
    } catch (error) {
      console.error('Error getting top scorers:', error);
      throw error;
    }
  }

  // Get top assisters
  async getTopAssisters(limit = 10, season = null) {
    try {
      // Use mock data if database is not available
      if (!this.pool) {
        console.log('Using mock data - no database connection');
        return this._getMockTopAssisters().slice(0, limit);
      }

      // Test database connection
      try {
        await this.pool.query('SELECT 1');
      } catch (dbError) {
        console.log('Database connection failed, using mock data:', dbError.message);
        return this._getMockTopAssisters().slice(0, limit);
      }

      let query = `
        SELECT 
          u.id as user_id,
          u.name as user_name,
          u.is_student,
          u.grade_or_subject,
          up.position,
          up.jersey_number,
          t.name as team_name,
          COUNT(DISTINCT gs.game_id) as total_games,
          COALESCE(SUM(gs.goals), 0) as goals,
          COALESCE(SUM(gs.assists), 0) as assists,
          COALESCE(SUM(gs.minutes_played), 0) as total_minutes,
          CASE 
            WHEN COUNT(DISTINCT gs.game_id) > 0 
            THEN ROUND(COALESCE(SUM(gs.assists), 0)::decimal / COUNT(DISTINCT gs.game_id), 2)
            ELSE 0 
          END as assists_per_game
        FROM users u
        LEFT JOIN user_profiles up ON u.id = up.user_id
        LEFT JOIN user_teams ut ON u.id = ut.user_id
        LEFT JOIN teams t ON ut.team_id = t.id
        LEFT JOIN game_stats gs ON u.id = gs.user_id
        LEFT JOIN games g ON gs.game_id = g.id
      `;

      let params = [];
      let whereClause = '';

      if (season) {
        whereClause = ' WHERE EXTRACT(YEAR FROM g.game_date) = $1';
        params.push(season);
      }

      query += whereClause + `
        GROUP BY u.id, u.name, u.is_student, u.grade_or_subject, up.position, up.jersey_number, t.name
        HAVING COALESCE(SUM(gs.assists), 0) > 0
        ORDER BY assists DESC, assists_per_game DESC, goals DESC
        LIMIT $${params.length + 1}
      `;

      params.push(limit);

      const result = await this.pool.query(query, params);
      
      return result.rows.map((row, index) => ({
        rank: index + 1,
        user_id: row.user_id,
        user_name: row.user_name,
        is_student: row.is_student,
        grade_or_subject: row.grade_or_subject,
        position: row.position,
        jersey_number: row.jersey_number,
        team_name: row.team_name,
        goals: parseInt(row.goals),
        assists: parseInt(row.assists),
        total_games: parseInt(row.total_games),
        total_minutes: parseInt(row.total_minutes),
        assists_per_game: parseFloat(row.assists_per_game)
      }));
    } catch (error) {
      console.error('Error getting top assisters:', error);
      throw error;
    }
  }

  // Get team rankings
  async getTeamRankings(season = null) {
    try {
      // Use mock data if database is not available
      if (!this.pool) {
        console.log('Using mock data - no database connection');
        return this._getMockTeamRankings();
      }

      // Test database connection
      try {
        await this.pool.query('SELECT 1');
      } catch (dbError) {
        console.log('Database connection failed, using mock data:', dbError.message);
        return this._getMockTeamRankings();
      }

      let query = `
        SELECT 
          t.id as team_id,
          t.name as team_name,
          t.description,
          t.logo_url,
          COUNT(g.id) as total_games,
          COUNT(CASE WHEN g.status = 'completed' THEN 1 END) as completed_games,
          COUNT(CASE 
            WHEN (g.home_team_id = t.id AND g.home_score > g.away_score) 
              OR (g.away_team_id = t.id AND g.away_score > g.home_score) 
            THEN 1 
          END) as wins,
          COUNT(CASE 
            WHEN (g.home_team_id = t.id AND g.home_score < g.away_score) 
              OR (g.away_team_id = t.id AND g.away_score < g.home_score) 
            THEN 1 
          END) as losses,
          COUNT(CASE 
            WHEN g.home_score = g.away_score AND g.status = 'completed'
            THEN 1 
          END) as draws,
          COALESCE(SUM(
            CASE 
              WHEN g.home_team_id = t.id THEN g.home_score 
              WHEN g.away_team_id = t.id THEN g.away_score 
              ELSE 0 
            END
          ), 0) as goals_for,
          COALESCE(SUM(
            CASE 
              WHEN g.home_team_id = t.id THEN g.away_score 
              WHEN g.away_team_id = t.id THEN g.home_score 
              ELSE 0 
            END
          ), 0) as goals_against
        FROM teams t
        LEFT JOIN games g ON (t.id = g.home_team_id OR t.id = g.away_team_id)
      `;

      let params = [];
      
      if (season) {
        query += ` AND EXTRACT(YEAR FROM g.game_date) = $1`;
        params.push(season);
      }

      query += `
        GROUP BY t.id, t.name, t.description, t.logo_url
        ORDER BY 
          (COUNT(CASE 
            WHEN (g.home_team_id = t.id AND g.home_score > g.away_score) 
              OR (g.away_team_id = t.id AND g.away_score > g.home_score) 
            THEN 1 
          END) * 3 + COUNT(CASE 
            WHEN g.home_score = g.away_score AND g.status = 'completed'
            THEN 1 
          END)) DESC,
          (COALESCE(SUM(
            CASE 
              WHEN g.home_team_id = t.id THEN g.home_score 
              WHEN g.away_team_id = t.id THEN g.away_score 
              ELSE 0 
            END
          ), 0) - COALESCE(SUM(
            CASE 
              WHEN g.home_team_id = t.id THEN g.away_score 
              WHEN g.away_team_id = t.id THEN g.home_score 
              ELSE 0 
            END
          ), 0)) DESC,
          COALESCE(SUM(
            CASE 
              WHEN g.home_team_id = t.id THEN g.home_score 
              WHEN g.away_team_id = t.id THEN g.away_score 
              ELSE 0 
            END
          ), 0) DESC
      `;

      const result = await this.pool.query(query, params);
      
      return result.rows.map((row, index) => {
        const wins = parseInt(row.wins) || 0;
        const losses = parseInt(row.losses) || 0;
        const draws = parseInt(row.draws) || 0;
        const completedGames = parseInt(row.completed_games) || 0;
        const goalsFor = parseInt(row.goals_for) || 0;
        const goalsAgainst = parseInt(row.goals_against) || 0;

        return {
          rank: index + 1,
          team_id: row.team_id,
          team_name: row.team_name,
          description: row.description,
          logo_url: row.logo_url,
          total_games: parseInt(row.total_games) || 0,
          completed_games: completedGames,
          wins,
          losses,
          draws,
          goals_for: goalsFor,
          goals_against: goalsAgainst,
          goal_difference: goalsFor - goalsAgainst,
          points: (wins * 3) + (draws * 1),
          win_rate: completedGames > 0 ? Math.round((wins / completedGames) * 100 * 10) / 10 : 0
        };
      });
    } catch (error) {
      console.error('Error getting team rankings:', error);
      throw error;
    }
  }

  // Get season statistics summary
  async getSeasonStats(season) {
    try {
      const query = `
        SELECT 
          COUNT(DISTINCT g.id) as total_games,
          COUNT(DISTINCT CASE WHEN g.status = 'completed' THEN g.id END) as completed_games,
          COUNT(DISTINCT u.id) as total_players,
          COUNT(DISTINCT t.id) as total_teams,
          COALESCE(SUM(gs.goals), 0) as total_goals,
          COALESCE(SUM(gs.assists), 0) as total_assists,
          COALESCE(AVG(g.home_score + g.away_score), 0) as avg_goals_per_game
        FROM games g
        LEFT JOIN game_stats gs ON g.id = gs.game_id
        LEFT JOIN users u ON gs.user_id = u.id
        LEFT JOIN teams t ON (g.home_team_id = t.id OR g.away_team_id = t.id)
        WHERE EXTRACT(YEAR FROM g.game_date) = $1
      `;

      const result = await this.pool.query(query, [season]);
      
      return {
        season: parseInt(season),
        ...result.rows[0],
        total_games: parseInt(result.rows[0].total_games) || 0,
        completed_games: parseInt(result.rows[0].completed_games) || 0,
        total_players: parseInt(result.rows[0].total_players) || 0,
        total_teams: parseInt(result.rows[0].total_teams) || 0,
        total_goals: parseInt(result.rows[0].total_goals) || 0,
        total_assists: parseInt(result.rows[0].total_assists) || 0,
        avg_goals_per_game: parseFloat(result.rows[0].avg_goals_per_game) || 0
      };
    } catch (error) {
      console.error('Error getting season stats:', error);
      throw error;
    }
  }

  // Get player's game history
  async getPlayerGameHistory(playerId, limit = 20) {
    try {
      const query = `
        SELECT 
          g.id as game_id,
          g.title,
          g.game_date,
          g.venue,
          g.status,
          g.home_team_name,
          g.away_team_name,
          g.home_score,
          g.away_score,
          gs.goals,
          gs.assists,
          gs.yellow_cards,
          gs.red_cards,
          gs.minutes_played,
          ht.name as home_team_full_name,
          at.name as away_team_full_name
        FROM games g
        JOIN game_stats gs ON g.id = gs.game_id
        LEFT JOIN teams ht ON g.home_team_id = ht.id
        LEFT JOIN teams at ON g.away_team_id = at.id
        WHERE gs.user_id = $1
        ORDER BY g.game_date DESC
        LIMIT $2
      `;

      const result = await this.pool.query(query, [playerId, limit]);
      
      return result.rows.map(row => ({
        game_id: row.game_id,
        title: row.title,
        game_date: row.game_date,
        venue: row.venue,
        status: row.status,
        home_team: row.home_team_full_name || row.home_team_name,
        away_team: row.away_team_full_name || row.away_team_name,
        home_score: row.home_score,
        away_score: row.away_score,
        player_performance: {
          goals: parseInt(row.goals) || 0,
          assists: parseInt(row.assists) || 0,
          yellow_cards: parseInt(row.yellow_cards) || 0,
          red_cards: parseInt(row.red_cards) || 0,
          minutes_played: parseInt(row.minutes_played) || 0
        }
      }));
    } catch (error) {
      console.error('Error getting player game history:', error);
      throw error;
    }
  }

  // Get all players with statistics
  async getAllPlayersStats(season = null, limit = 50) {
    try {
      let query = `
        SELECT 
          u.id as user_id,
          u.name as user_name,
          u.is_student,
          u.grade_or_subject,
          up.position,
          up.jersey_number,
          t.name as team_name,
          COUNT(DISTINCT gs.game_id) as total_games,
          COALESCE(SUM(gs.goals), 0) as goals,
          COALESCE(SUM(gs.assists), 0) as assists,
          COALESCE(SUM(gs.yellow_cards), 0) as yellow_cards,
          COALESCE(SUM(gs.red_cards), 0) as red_cards,
          COALESCE(SUM(gs.minutes_played), 0) as total_minutes,
          CASE 
            WHEN COUNT(DISTINCT gs.game_id) > 0 
            THEN ROUND(COALESCE(SUM(gs.goals), 0)::decimal / COUNT(DISTINCT gs.game_id), 2)
            ELSE 0 
          END as goals_per_game,
          CASE 
            WHEN COUNT(DISTINCT gs.game_id) > 0 
            THEN ROUND(COALESCE(SUM(gs.assists), 0)::decimal / COUNT(DISTINCT gs.game_id), 2)
            ELSE 0 
          END as assists_per_game
        FROM users u
        LEFT JOIN user_profiles up ON u.id = up.user_id
        LEFT JOIN user_teams ut ON u.id = ut.user_id
        LEFT JOIN teams t ON ut.team_id = t.id
        LEFT JOIN game_stats gs ON u.id = gs.user_id
        LEFT JOIN games g ON gs.game_id = g.id
      `;

      let params = [];
      let whereClause = '';

      if (season) {
        whereClause = ' WHERE EXTRACT(YEAR FROM g.game_date) = $1';
        params.push(season);
      }

      query += whereClause + `
        GROUP BY u.id, u.name, u.is_student, u.grade_or_subject, up.position, up.jersey_number, t.name
        ORDER BY goals DESC, assists DESC, total_games DESC
        LIMIT $${params.length + 1}
      `;

      params.push(limit);

      const result = await this.pool.query(query, params);
      
      return result.rows.map(row => ({
        user_id: row.user_id,
        user_name: row.user_name,
        is_student: row.is_student,
        grade_or_subject: row.grade_or_subject,
        position: row.position,
        jersey_number: row.jersey_number,
        team_name: row.team_name,
        goals: parseInt(row.goals),
        assists: parseInt(row.assists),
        yellow_cards: parseInt(row.yellow_cards),
        red_cards: parseInt(row.red_cards),
        total_games: parseInt(row.total_games),
        total_minutes: parseInt(row.total_minutes),
        goals_per_game: parseFloat(row.goals_per_game),
        assists_per_game: parseFloat(row.assists_per_game)
      }));
    } catch (error) {
      console.error('Error getting all players stats:', error);
      throw error;
    }
  }

  // Get game statistics for a specific game
  async getGameStats(gameId) {
    try {
      const query = `
        SELECT 
          gs.id,
          gs.game_id,
          gs.user_id,
          u.name as player_name,
          u.is_student,
          u.grade_or_subject,
          up.position,
          up.jersey_number,
          gs.goals,
          gs.assists,
          gs.yellow_cards,
          gs.red_cards,
          gs.minutes_played,
          t.name as team_name
        FROM game_stats gs
        JOIN users u ON gs.user_id = u.id
        LEFT JOIN user_profiles up ON u.id = up.user_id
        LEFT JOIN user_teams ut ON u.id = ut.user_id
        LEFT JOIN teams t ON ut.team_id = t.id
        WHERE gs.game_id = $1
        ORDER BY gs.goals DESC, gs.assists DESC
      `;

      const result = await this.pool.query(query, [gameId]);
      
      return result.rows.map(row => ({
        id: row.id,
        game_id: row.game_id,
        user_id: row.user_id,
        player_name: row.player_name,
        is_student: row.is_student,
        grade_or_subject: row.grade_or_subject,
        position: row.position,
        jersey_number: row.jersey_number,
        goals: parseInt(row.goals) || 0,
        assists: parseInt(row.assists) || 0,
        yellow_cards: parseInt(row.yellow_cards) || 0,
        red_cards: parseInt(row.red_cards) || 0,
        minutes_played: parseInt(row.minutes_played) || 0,
        team_name: row.team_name
      }));
    } catch (error) {
      console.error('Error getting game stats:', error);
      throw error;
    }
  }

  // Get team statistics
  async getTeamStats(teamId, season = null) {
    try {
      // Use mock data if database is not available
      if (!this.pool) {
        console.log('Using mock data for team stats - no database connection');
        return this._getMockTeamStats(teamId);
      }

      // Test database connection
      try {
        await this.pool.query('SELECT 1');
      } catch (dbError) {
        console.error('Database connection test failed for team stats, using mock data:', dbError.message);
        return this._getMockTeamStats(teamId);
      }

      let query = `
        SELECT 
          t.id as team_id,
          t.name as team_name,
          COUNT(DISTINCT g.id) as total_games,
          SUM(CASE 
            WHEN (g.home_team_id = t.id AND g.home_score > g.away_score) OR 
                 (g.away_team_id = t.id AND g.away_score > g.home_score) 
            THEN 1 ELSE 0 
          END) as wins,
          SUM(CASE 
            WHEN (g.home_team_id = t.id AND g.home_score < g.away_score) OR 
                 (g.away_team_id = t.id AND g.away_score < g.home_score) 
            THEN 1 ELSE 0 
          END) as losses,
          SUM(CASE 
            WHEN g.home_score = g.away_score 
            THEN 1 ELSE 0 
          END) as draws,
          SUM(CASE 
            WHEN g.home_team_id = t.id THEN g.home_score 
            WHEN g.away_team_id = t.id THEN g.away_score 
            ELSE 0 
          END) as goals_for,
          SUM(CASE 
            WHEN g.home_team_id = t.id THEN g.away_score 
            WHEN g.away_team_id = t.id THEN g.home_score 
            ELSE 0 
          END) as goals_against
        FROM teams t
        LEFT JOIN games g ON (g.home_team_id = t.id OR g.away_team_id = t.id) 
          AND g.status = 'completed'
        WHERE t.id = $1
        GROUP BY t.id, t.name
      `;

      const params = [teamId];
      if (season) {
        query += ` AND EXTRACT(YEAR FROM g.game_date) = $2`;
        params.push(season);
      }

      const result = await this.pool.query(query, params);
      
      if (result.rows.length === 0) {
        return this._getMockTeamStats(teamId);
      }

      const teamStats = result.rows[0];
      const wins = parseInt(teamStats.wins) || 0;
      const totalGames = parseInt(teamStats.total_games) || 0;
      const goalsFor = parseInt(teamStats.goals_for) || 0;
      const goalsAgainst = parseInt(teamStats.goals_against) || 0;

      return {
        team_id: teamStats.team_id,
        team_name: teamStats.team_name,
        total_games: totalGames,
        wins: wins,
        losses: parseInt(teamStats.losses) || 0,
        draws: parseInt(teamStats.draws) || 0,
        goals_for: goalsFor,
        goals_against: goalsAgainst,
        goal_difference: goalsFor - goalsAgainst,
        points: (wins * 3) + (parseInt(teamStats.draws) || 0),
        win_rate: totalGames > 0 ? Math.round((wins / totalGames) * 100 * 100) / 100 : 0
      };
    } catch (error) {
      console.error('Error getting team stats from database, using mock data:', error);
      return this._getMockTeamStats(teamId);
    }
  }
}

module.exports = new StatisticsService(); 
