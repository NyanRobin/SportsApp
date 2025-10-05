const { Pool } = require('pg');

// Database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://localhost:5432/sports_app'
});

async function insertSampleData() {
  const client = await pool.connect();
  
  try {
    console.log('Starting sample data insertion...');
    
    // Begin transaction
    await client.query('BEGIN');

    // Insert sample users
    console.log('Inserting sample users...');
    const users = [
      { id: 'user1', email: 'kim.junyoung@example.com', name: 'Kim Junyoung', is_student: true, grade_or_subject: '3학년' },
      { id: 'user2', email: 'park.jisung@example.com', name: 'Park Jisung', is_student: true, grade_or_subject: '2학년' },
      { id: 'user3', email: 'lee.minjae@example.com', name: 'Lee Minjae', is_student: true, grade_or_subject: '3학년' },
      { id: 'user4', email: 'choi.jaewon@example.com', name: 'Choi Jaewon', is_student: true, grade_or_subject: '1학년' },
      { id: 'user5', email: 'song.heungmin@example.com', name: 'Song Heungmin', is_student: true, grade_or_subject: '2학년' },
      { id: 'user6', email: 'jung.hoseok@example.com', name: 'Jung Hoseok', is_student: true, grade_or_subject: '3학년' },
      { id: 'user7', email: 'kang.minhyuk@example.com', name: 'Kang Minhyuk', is_student: true, grade_or_subject: '1학년' },
      { id: 'user8', email: 'yoon.seonho@example.com', name: 'Yoon Seonho', is_student: true, grade_or_subject: '2학년' },
    ];

    for (const user of users) {
      await client.query(
        'INSERT INTO users (id, email, name, is_student, grade_or_subject) VALUES ($1, $2, $3, $4, $5) ON CONFLICT (id) DO NOTHING',
        [user.id, user.email, user.name, user.is_student, user.grade_or_subject]
      );
    }

    // Insert sample teams
    console.log('Inserting sample teams...');
    const teams = [
      { name: 'Daehan High School', description: 'Championship winners 2024' },
      { name: 'Seoul High School', description: 'Strong offensive team' },
      { name: 'Busan High School', description: 'Defensive specialists' },
      { name: 'Daegu High School', description: 'Rising stars' },
      { name: 'Incheon High School', description: 'Veteran team' },
      { name: 'Gwangju High School', description: 'New challengers' },
    ];

    const teamIds = [];
    for (let i = 0; i < teams.length; i++) {
      const team = teams[i];
      const result = await client.query(
        'INSERT INTO teams (name, description) VALUES ($1, $2) ON CONFLICT (name) DO UPDATE SET description = $2 RETURNING id',
        [team.name, team.description]
      );
      teamIds.push(result.rows[0].id);
    }

    // Insert user-team relationships
    console.log('Inserting user-team relationships...');
    const userTeams = [
      { user_id: 'user1', team_id: teamIds[0], role: 'captain' }, // Kim Junyoung - Daehan High School
      { user_id: 'user2', team_id: teamIds[1], role: 'member' },  // Park Jisung - Seoul High School
      { user_id: 'user3', team_id: teamIds[2], role: 'member' },  // Lee Minjae - Busan High School
      { user_id: 'user4', team_id: teamIds[3], role: 'member' },  // Choi Jaewon - Daegu High School
      { user_id: 'user5', team_id: teamIds[4], role: 'member' },  // Song Heungmin - Incheon High School
      { user_id: 'user6', team_id: teamIds[0], role: 'member' },  // Jung Hoseok - Daehan High School
      { user_id: 'user7', team_id: teamIds[1], role: 'member' },  // Kang Minhyuk - Seoul High School
      { user_id: 'user8', team_id: teamIds[2], role: 'member' },  // Yoon Seonho - Busan High School
    ];

    for (const userTeam of userTeams) {
      await client.query(
        'INSERT INTO user_teams (user_id, team_id, role) VALUES ($1, $2, $3) ON CONFLICT (user_id, team_id) DO NOTHING',
        [userTeam.user_id, userTeam.team_id, userTeam.role]
      );
    }

    // Insert user profiles
    console.log('Inserting user profiles...');
    const profiles = [
      { user_id: 'user1', position: 'Forward', jersey_number: 10, height: 175, weight: 70 },
      { user_id: 'user2', position: 'Midfielder', jersey_number: 8, height: 172, weight: 68 },
      { user_id: 'user3', position: 'Defender', jersey_number: 4, height: 180, weight: 75 },
      { user_id: 'user4', position: 'Midfielder', jersey_number: 6, height: 168, weight: 65 },
      { user_id: 'user5', position: 'Forward', jersey_number: 9, height: 178, weight: 72 },
      { user_id: 'user6', position: 'Goalkeeper', jersey_number: 1, height: 185, weight: 80 },
      { user_id: 'user7', position: 'Defender', jersey_number: 3, height: 182, weight: 76 },
      { user_id: 'user8', position: 'Midfielder', jersey_number: 7, height: 170, weight: 67 },
    ];

    for (const profile of profiles) {
      await client.query(
        'INSERT INTO user_profiles (user_id, position, jersey_number, height, weight) VALUES ($1, $2, $3, $4, $5) ON CONFLICT (user_id) DO UPDATE SET position = $2, jersey_number = $3, height = $4, weight = $5',
        [profile.user_id, profile.position, profile.jersey_number, profile.height, profile.weight]
      );
    }

    // Insert sample games
    console.log('Inserting sample games...');
    const games = [
      {
        title: 'Championship Final',
        home_team_id: teamIds[0],
        away_team_id: teamIds[1],
        home_team_name: 'Daehan High School',
        away_team_name: 'Seoul High School',
        game_date: '2025-01-20 14:00:00',
        venue: 'Seoul Sports Complex',
        status: 'completed',
        home_score: 3,
        away_score: 1
      },
      {
        title: 'Semi Final',
        home_team_id: teamIds[2],
        away_team_id: teamIds[3],
        home_team_name: 'Busan High School',
        away_team_name: 'Daegu High School',
        game_date: '2025-01-18 14:00:00',
        venue: 'Busan Stadium',
        status: 'completed',
        home_score: 2,
        away_score: 1
      },
      {
        title: 'Quarter Final A',
        home_team_id: teamIds[0],
        away_team_id: teamIds[4],
        home_team_name: 'Daehan High School',
        away_team_name: 'Incheon High School',
        game_date: '2025-01-15 14:00:00',
        venue: 'Daehan Stadium',
        status: 'completed',
        home_score: 4,
        away_score: 0
      },
      {
        title: 'Quarter Final B',
        home_team_id: teamIds[1],
        away_team_id: teamIds[5],
        home_team_name: 'Seoul High School',
        away_team_name: 'Gwangju High School',
        game_date: '2025-01-15 16:00:00',
        venue: 'Seoul Stadium',
        status: 'completed',
        home_score: 2,
        away_score: 2
      },
      {
        title: 'League Match',
        home_team_id: teamIds[2],
        away_team_id: teamIds[5],
        home_team_name: 'Busan High School',
        away_team_name: 'Gwangju High School',
        game_date: '2025-01-12 14:00:00',
        venue: 'Busan Stadium',
        status: 'completed',
        home_score: 1,
        away_score: 1
      }
    ];

    const gameIds = [];
    for (const game of games) {
      const result = await client.query(
        'INSERT INTO games (title, home_team_id, away_team_id, home_team_name, away_team_name, game_date, venue, status, home_score, away_score) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10) RETURNING id',
        [game.title, game.home_team_id, game.away_team_id, game.home_team_name, game.away_team_name, game.game_date, game.venue, game.status, game.home_score, game.away_score]
      );
      gameIds.push(result.rows[0].id);
    }

    // Insert game statistics
    console.log('Inserting game statistics...');
    const gameStats = [
      // Championship Final (Game 0)
      { game_id: gameIds[0], user_id: 'user1', goals: 2, assists: 1, minutes_played: 90 },
      { game_id: gameIds[0], user_id: 'user6', goals: 1, assists: 0, minutes_played: 90 },
      { game_id: gameIds[0], user_id: 'user2', goals: 1, assists: 0, minutes_played: 85 },
      { game_id: gameIds[0], user_id: 'user7', goals: 0, assists: 1, minutes_played: 90 },
      
      // Semi Final (Game 1)
      { game_id: gameIds[1], user_id: 'user3', goals: 1, assists: 1, minutes_played: 90 },
      { game_id: gameIds[1], user_id: 'user8', goals: 1, assists: 0, minutes_played: 90 },
      { game_id: gameIds[1], user_id: 'user4', goals: 1, assists: 0, minutes_played: 88 },
      
      // Quarter Final A (Game 2)
      { game_id: gameIds[2], user_id: 'user1', goals: 2, assists: 2, minutes_played: 90 },
      { game_id: gameIds[2], user_id: 'user6', goals: 2, assists: 0, minutes_played: 90 },
      { game_id: gameIds[2], user_id: 'user5', goals: 0, assists: 0, minutes_played: 90 },
      
      // Quarter Final B (Game 3)
      { game_id: gameIds[3], user_id: 'user2', goals: 1, assists: 1, minutes_played: 90 },
      { game_id: gameIds[3], user_id: 'user7', goals: 1, assists: 0, minutes_played: 90 },
      
      // League Match (Game 4)
      { game_id: gameIds[4], user_id: 'user3', goals: 1, assists: 0, minutes_played: 90 },
      { game_id: gameIds[4], user_id: 'user8', goals: 0, assists: 1, minutes_played: 90 },
    ];

    for (const stat of gameStats) {
      await client.query(
        'INSERT INTO game_stats (game_id, user_id, goals, assists, yellow_cards, red_cards, minutes_played) VALUES ($1, $2, $3, $4, $5, $6, $7) ON CONFLICT (game_id, user_id) DO UPDATE SET goals = $3, assists = $4, minutes_played = $7',
        [stat.game_id, stat.user_id, stat.goals, stat.assists, 0, 0, stat.minutes_played]
      );
    }

    // Update user statistics
    console.log('Updating user statistics...');
    const statisticsService = require('../services/statisticsService');
    for (const user of users) {
      await statisticsService.updateUserStatistics(user.id);
    }

    // Insert sample announcements
    console.log('Inserting sample announcements...');
    const announcements = [
      {
        title: 'Championship Victory!',
        content: 'Congratulations to Daehan High School for winning the championship!',
        tag: 'games',
        author_id: 'user1',
        is_pinned: true
      },
      {
        title: 'Next Season Registration',
        content: 'Registration for the next season is now open. Please contact your team captain.',
        tag: 'other',
        author_id: 'user2'
      },
      {
        title: 'Training Schedule Update',
        content: 'Training sessions will be moved to evening hours during exam period.',
        tag: 'other',
        author_id: 'user3'
      }
    ];

    for (const announcement of announcements) {
      await client.query(
        'INSERT INTO announcements (title, content, tag, author_id, is_pinned) VALUES ($1, $2, $3, $4, $5)',
        [announcement.title, announcement.content, announcement.tag, announcement.author_id, announcement.is_pinned || false]
      );
    }

    // Commit transaction
    await client.query('COMMIT');
    console.log('✅ Sample data inserted successfully!');
    
    // Display summary
    const userCount = await client.query('SELECT COUNT(*) FROM users');
    const teamCount = await client.query('SELECT COUNT(*) FROM teams');
    const gameCount = await client.query('SELECT COUNT(*) FROM games');
    const statsCount = await client.query('SELECT COUNT(*) FROM game_stats');
    
    console.log('\n📊 Data Summary:');
    console.log(`👥 Users: ${userCount.rows[0].count}`);
    console.log(`🏆 Teams: ${teamCount.rows[0].count}`);
    console.log(`⚽ Games: ${gameCount.rows[0].count}`);
    console.log(`📈 Game Stats: ${statsCount.rows[0].count}`);
    
  } catch (error) {
    // Rollback transaction on error
    await client.query('ROLLBACK');
    console.error('❌ Error inserting sample data:', error);
    throw error;
  } finally {
    client.release();
  }
}

// Run the script
if (require.main === module) {
  insertSampleData()
    .then(() => {
      console.log('🎉 Sample data insertion completed!');
      process.exit(0);
    })
    .catch((error) => {
      console.error('💥 Failed to insert sample data:', error);
      process.exit(1);
    });
}

module.exports = insertSampleData;




