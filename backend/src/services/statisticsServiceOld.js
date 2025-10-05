// Mock data for development
const mockStats = {
  user1: {
    games_played: 15,
    total_goals: 12,
    total_assists: 8,
    total_yellow_cards: 2,
    total_red_cards: 0,
    total_minutes_played: 1350,
    avg_goals_per_game: 0.8,
    avg_assists_per_game: 0.53
  },
  user2: {
    games_played: 12,
    total_goals: 8,
    total_assists: 15,
    total_yellow_cards: 1,
    total_red_cards: 0,
    total_minutes_played: 1080,
    avg_goals_per_game: 0.67,
    avg_assists_per_game: 1.25
  }
};

const mockTopScorers = [
  { 
    user_id: 'user1', 
    user_name: 'Kim Minseok', 
    team_name: 'Daehan High School',
    goals: 12, 
    assists: 8,
    total_games: 15, 
    goals_per_game: 0.8 
  },
  { 
    user_id: 'user2', 
    user_name: 'Park Jisung', 
    team_name: 'Gangbuk High School',
    goals: 8, 
    assists: 15,
    total_games: 12, 
    goals_per_game: 0.67 
  },
  { 
    user_id: 'user3', 
    user_name: 'Lee Junho', 
    team_name: 'Seoul High School',
    goals: 6, 
    assists: 4,
    total_games: 10, 
    goals_per_game: 0.6 
  }
];

const mockTopAssisters = [
  { 
    user_id: 'user2', 
    user_name: 'Park Jisung', 
    team_name: 'Gangbuk High School',
    assists: 15, 
    goals: 8,
    total_games: 12, 
    assists_per_game: 1.25 
  },
  { 
    user_id: 'user1', 
    user_name: 'Kim Minseok', 
    team_name: 'Daehan High School',
    assists: 8, 
    goals: 12,
    total_games: 15, 
    assists_per_game: 0.53 
  },
  { 
    user_id: 'user4', 
    user_name: 'Choi Jaewon', 
    team_name: 'Seoul High School',
    assists: 5, 
    goals: 3,
    total_games: 8, 
    assists_per_game: 0.63 
  }
];

class StatisticsService {
  async getUserStats(userId, season = null) {
    return mockStats[userId] || {
      games_played: 0,
      total_goals: 0,
      total_assists: 0,
      total_yellow_cards: 0,
      total_red_cards: 0,
      total_minutes_played: 0,
      avg_goals_per_game: 0,
      avg_assists_per_game: 0
    };
  }

  async getTeamStats(teamId, season = null) {
    const mockTeamStats = {
      1: {
        games_played: 8,
        completed_games: 7,
        wins: 5,
        losses: 1,
        draws: 1,
        goals_for: 18,
        goals_against: 8,
        win_rate: 71,
        goal_difference: 10
      },
      2: {
        games_played: 8,
        completed_games: 7,
        wins: 3,
        losses: 3,
        draws: 1,
        goals_for: 12,
        goals_against: 11,
        win_rate: 43,
        goal_difference: 1
      }
    };
    
    return mockTeamStats[teamId] || {
      games_played: 0,
      completed_games: 0,
      wins: 0,
      losses: 0,
      draws: 0,
      goals_for: 0,
      goals_against: 0,
      win_rate: 0,
      goal_difference: 0
    };
  }

  async getGameStats(gameId) {
    return [
      {
        id: 1,
        game_id: gameId,
        user_id: 'user1',
        player_name: 'Kim Minseok',
        goals: 2,
        assists: 1,
        yellow_cards: 0,
        red_cards: 0,
        minutes_played: 90,
        is_student: true,
        grade_or_subject: '3학년'
      },
      {
        id: 2,
        game_id: gameId,
        user_id: 'user2',
        player_name: 'Park Jisung',
        goals: 1,
        assists: 2,
        yellow_cards: 1,
        red_cards: 0,
        minutes_played: 85,
        is_student: true,
        grade_or_subject: '2학년'
      }
    ];
  }

  async getSeasonStats(season) {
    const query = `
      SELECT 
        u.id,
        u.name,
        u.is_student,
        u.grade_or_subject,
        COUNT(DISTINCT g.id) as games_played,
        SUM(gs.goals) as total_goals,
        SUM(gs.assists) as total_assists,
        AVG(gs.goals) as avg_goals_per_game,
        AVG(gs.assists) as avg_assists_per_game
      FROM users u
      LEFT JOIN game_stats gs ON u.id = gs.user_id
      LEFT JOIN games g ON gs.game_id = g.id AND EXTRACT(YEAR FROM g.game_date) = $1
      GROUP BY u.id, u.name, u.is_student, u.grade_or_subject
      HAVING COUNT(DISTINCT g.id) > 0
      ORDER BY total_goals DESC, total_assists DESC
    `;
    
    const result = await pool.query(query, [season]);
    return result.rows;
  }

  async getTopScorers(limit = 10, season = null) {
    return mockTopScorers.slice(0, limit);
  }

  async getTopAssisters(limit = 10, season = null) {
    return mockTopAssisters.slice(0, limit);
  }

  async getTeamRankings(season = null) {
    return [
      {
        team_id: 1,
        team_name: 'Daehan High School',
        total_games: 8,
        wins: 5,
        losses: 1,
        draws: 1,
        goals_for: 18,
        goals_against: 8,
        goal_difference: 10,
        points: 16,
        win_rate: 71.4,
        rank: 1
      },
      {
        team_id: 2,
        team_name: 'Gangbuk High School',
        total_games: 8,
        wins: 3,
        losses: 3,
        draws: 1,
        goals_for: 12,
        goals_against: 11,
        goal_difference: 1,
        points: 10,
        win_rate: 42.9,
        rank: 2
      },
      {
        team_id: 3,
        team_name: 'Seoul High School',
        total_games: 8,
        wins: 2,
        losses: 4,
        draws: 1,
        goals_for: 9,
        goals_against: 15,
        goal_difference: -6,
        points: 7,
        win_rate: 28.6,
        rank: 3
      }
    ];
  }
}

module.exports = new StatisticsService(); 