const { safeQuery, isConnected } = require('../config/database');

const gameService = {
  async getAllGames() {
    try {
      console.log('🔄 Fetching games from database...');
      const result = await safeQuery(`
        SELECT 
          id,
          title,
          home_team_name as home_team,
          away_team_name as away_team,
          home_score,
          away_score,
          game_date,
          DATE_PART('hour', game_date)::text || ':' || LPAD(DATE_PART('minute', game_date)::text, 2, '0') as game_time,
          status,
          venue as location
        FROM games 
        ORDER BY game_date DESC
      `);
      
      if (result.rows.length === 0) {
        console.log('⚠️  No games found in database, returning empty array');
      } else {
        console.log(`✅ Found ${result.rows.length} games in database`);
      }
      
      return result.rows;
    } catch (error) {
      console.error('Error in getAllGames:', error);
      // 에러 발생 시 빈 배열 반환
      return [];
    }
  },

  async getGameById(gameId) {
    try {
      const result = await safeQuery(`
        SELECT 
          id,
          title,
          home_team_name as home_team,
          away_team_name as away_team,
          home_score,
          away_score,
          game_date,
          DATE_PART('hour', game_date)::text || ':' || LPAD(DATE_PART('minute', game_date)::text, 2, '0') as game_time,
          status,
          venue as location,
          description
        FROM games 
        WHERE id = $1
      `, [gameId]);
      
      return result.rows[0] || null;
    } catch (error) {
      console.error('Error in getGameById:', error);
      return null;
    }
  },

  async createGame(gameData) {
    try {
      const result = await safeQuery(`
        INSERT INTO games (title, home_team_name, away_team_name, game_date, venue, status, description)
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING *
      `, [
        gameData.title || `${gameData.home_team} vs ${gameData.away_team}`,
        gameData.home_team,
        gameData.away_team,
        gameData.game_date,
        gameData.location || null,
        gameData.status || 'scheduled',
        gameData.description || null
      ]);
      
      return result.rows[0];
    } catch (error) {
      console.error('Error in createGame:', error);
      throw error;
    }
  },

  async getUpcomingGames(limit = 5) {
    try {
      const result = await safeQuery(`
        SELECT 
          id,
          title,
          home_team_name as home_team,
          away_team_name as away_team,
          home_score,
          away_score,
          game_date,
          DATE_PART('hour', game_date)::text || ':' || LPAD(DATE_PART('minute', game_date)::text, 2, '0') as game_time,
          status,
          venue as location
        FROM games 
        WHERE game_date > NOW() AND status = 'scheduled'
        ORDER BY game_date ASC
        LIMIT $1
      `, [limit]);
      
      return result.rows;
    } catch (error) {
      console.error('Error in getUpcomingGames:', error);
      return [];
    }
  },

  async getRecentGames(limit = 5) {
    try {
      const result = await safeQuery(`
        SELECT 
          id,
          title,
          home_team_name as home_team,
          away_team_name as away_team,
          home_score,
          away_score,
          game_date,
          DATE_PART('hour', game_date)::text || ':' || LPAD(DATE_PART('minute', game_date)::text, 2, '0') as game_time,
          status,
          venue as location
        FROM games 
        WHERE status = 'completed'
        ORDER BY game_date DESC
        LIMIT $1
      `, [limit]);
      
      return result.rows;
    } catch (error) {
      console.error('Error in getRecentGames:', error);
      return [];
    }
  }
};

module.exports = gameService; 