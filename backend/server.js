const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const { createServer } = require('http');
const { Server } = require('socket.io');
require('dotenv').config();

// Import database configuration
const { testConnection } = require('./src/config/database');

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: true, // 모든 origin 허용 (개발 환경)
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    credentials: true,
    allowedHeaders: ["Content-Type", "Authorization", "X-Requested-With", "Accept", "Origin"]
  }
});

// Middleware
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" }
}));

// CORS 설정을 더 포괄적으로
app.use(cors({
  origin: true, // 모든 origin 허용 (개발 환경)
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"],
  allowedHeaders: ["Content-Type", "Authorization", "X-Requested-With", "Accept", "Origin", "Cache-Control", "X-File-Name"],
  exposedHeaders: ["Content-Length", "X-Foo", "X-Bar"],
  maxAge: 86400 // 24시간
}));
app.use(morgan('combined'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// 추가 CORS 헤더 설정
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control, X-File-Name');
  res.header('Access-Control-Allow-Credentials', 'true');
  
  if (req.method === 'OPTIONS') {
    res.sendStatus(200);
  } else {
    next();
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Database status endpoint
app.get('/api/database/status', async (req, res) => {
  try {
    const isConnected = await testConnection();
    res.json({ 
      status: isConnected ? 'connected' : 'disconnected',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(500).json({ 
      status: 'error',
      message: error.message,
      timestamp: new Date().toISOString()
    });
  }
});

// Import services
const authService = require('./src/services/authService');
const gameService = require('./src/services/gameService');
const announcementService = require('./src/services/announcementService');
const statisticsService = require('./src/services/statisticsService');
const userService = require('./src/services/userService');
const RealtimeService = require('./src/services/realtimeService');

// Initialize realtime service
const realtimeService = new RealtimeService(io);

// Authentication API endpoints
app.post('/api/auth/firebase', async (req, res) => {
  try {
    const { idToken } = req.body;
    if (!idToken) {
      return res.status(400).json({ error: 'ID token is required' });
    }
    
    const result = await authService.authenticateUser(idToken);
    res.json(result);
  } catch (error) {
    console.error('Authentication error:', error);
    res.status(401).json({ error: error.message });
  }
});

app.post('/api/auth/refresh', async (req, res) => {
  try {
    const { refreshToken } = req.body;
    if (!refreshToken) {
      return res.status(400).json({ error: 'Refresh token is required' });
    }
    
    const result = await authService.refreshToken(refreshToken);
    res.json(result);
  } catch (error) {
    console.error('Token refresh error:', error);
    res.status(401).json({ error: error.message });
  }
});

app.post('/api/auth/logout', async (req, res) => {
  try {
    // 실제 구현에서는 토큰을 블랙리스트에 추가하거나 무효화
    res.json({ message: 'Logged out successfully' });
  } catch (error) {
    console.error('Logout error:', error);
    res.status(500).json({ error: 'Logout failed' });
  }
});

app.get('/api/auth/validate', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }
    
    const token = authHeader.substring(7);
    const decoded = authService.verifyJWTToken(token);
    res.json({ valid: true, user: decoded });
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
});

app.get('/api/auth/profile', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }
    
    const token = authHeader.substring(7);
    const decoded = authService.verifyJWTToken(token);
    const profile = await authService.getUserProfile(decoded.userId);
    res.json(profile);
  } catch (error) {
    console.error('Profile error:', error);
    res.status(401).json({ error: 'Failed to get profile' });
  }
});

app.put('/api/auth/profile', async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: 'No token provided' });
    }
    
    const token = authHeader.substring(7);
    const decoded = authService.verifyJWTToken(token);
    const updatedProfile = await authService.updateUserProfile(decoded.userId, req.body);
    res.json(updatedProfile);
  } catch (error) {
    console.error('Profile update error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

// Users API endpoints
app.get('/api/users', async (req, res) => {
  try {
    const filters = {
      page: parseInt(req.query.page) || 1,
      limit: parseInt(req.query.limit) || 10,
      search: req.query.search,
      role: req.query.role,
      department: req.query.department,
      isActive: req.query.is_active === 'true' ? true : req.query.is_active === 'false' ? false : undefined
    };
    
    const result = await userService.getAllUsers(filters);
    res.json({ 
      message: 'Users retrieved successfully',
      ...result
    });
  } catch (error) {
    console.error('Error getting users:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/users/profile', async (req, res) => {
  try {
    // In a real implementation, you would get the user ID from the JWT token
    const userId = req.query.user_id || 'user1'; // Mock user ID for now
    const profile = await userService.getCurrentUserProfile(userId);
    
    if (!profile) {
      return res.status(404).json({ error: 'Profile not found' });
    }
    
    res.json({ 
      message: 'Profile retrieved successfully',
      profile
    });
  } catch (error) {
    console.error('Error getting profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/users/:userId/profile', async (req, res) => {
  try {
    const profile = await userService.getUserProfile(req.params.userId);
    
    if (!profile) {
      return res.status(404).json({ error: 'Profile not found' });
    }
    
    res.json({ 
      message: 'Profile retrieved successfully',
      profile
    });
  } catch (error) {
    console.error('Error getting profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.put('/api/users/profile', async (req, res) => {
  try {
    // In a real implementation, you would get the user ID from the JWT token
    const userId = req.query.user_id || 'user1'; // Mock user ID for now
    const updatedProfile = await userService.updateUserProfile(userId, req.body);
    
    res.json({ 
      message: 'Profile updated successfully',
      profile: updatedProfile
    });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.put('/api/users/:userId/profile', async (req, res) => {
  try {
    const updatedProfile = await userService.updateUserProfile(req.params.userId, req.body);
    
    res.json({ 
      message: 'Profile updated successfully',
      profile: updatedProfile
    });
  } catch (error) {
    console.error('Error updating profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Games API endpoints
app.get('/api/games', async (req, res) => {
  try {
    const games = await gameService.getAllGames();
    res.json({ 
      message: 'Games retrieved successfully',
      games
    });
  } catch (error) {
    console.error('Error getting games:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/games/:id', async (req, res) => {
  try {
    const game = await gameService.getGameById(req.params.id);
    if (!game) {
      return res.status(404).json({ error: 'Game not found' });
    }
    res.json({ 
      message: 'Game retrieved successfully',
      game
    });
  } catch (error) {
    console.error('Error getting game:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Add game details endpoint
app.get('/api/games/:id/details', async (req, res) => {
  try {
    const gameId = req.params.id;
    
    // Get basic game info
    const game = await gameService.getGameById(gameId);
    if (!game) {
      return res.status(404).json({ error: 'Game not found' });
    }

    // Mock additional details for now
    const details = {
      game: game,
      timeline: [
        {
          id: 1,
          minute: 0,
          type: 'kickoff',
          description: '경기 시작',
          player: null,
          team: null
        },
        {
          id: 2,
          minute: 23,
          type: 'goal',
          description: '김민석 선제골',
          player: {
            id: 1,
            name: '김민석',
            position: 'Forward',
            jerseyNumber: 10
          },
          team: {
            id: 1,
            name: game.home_team
          }
        },
        {
          id: 3,
          minute: 90,
          type: 'fulltime',
          description: '경기 종료',
          player: null,
          team: null
        }
      ],
      lineup: {
        home_team: {
          name: game.home_team,
          players: [
            {
              id: 1,
              name: '김민석',
              position: 'Forward',
              jerseyNumber: 10,
              isStarter: true
            },
            {
              id: 2,
              name: '정태우',
              position: 'Defender',
              jerseyNumber: 4,
              isStarter: true
            }
          ]
        },
        away_team: {
          name: game.away_team,
          players: [
            {
              id: 3,
              name: '박지성',
              position: 'Midfielder',
              jerseyNumber: 7,
              isStarter: true
            }
          ]
        }
      },
      statistics: {
        home_team: {
          players: [
            {
              player: {
                id: 1,
                name: '김민석',
                position: 'Forward',
                jerseyNumber: 10
              },
              goals: 2,
              assists: 1,
              shots: 5,
              shotsOnTarget: 3,
              passes: 45,
              passesCompleted: 38,
              tackles: 2,
              fouls: 1,
              yellowCards: 0,
              redCards: 0,
              minutesPlayed: 90,
              rating: 8.5
            }
          ]
        },
        away_team: {
          players: [
            {
              player: {
                id: 3,
                name: '박지성',
                position: 'Midfielder',
                jerseyNumber: 7
              },
              goals: 1,
              assists: 0,
              shots: 3,
              shotsOnTarget: 2,
              passes: 48,
              passesCompleted: 42,
              tackles: 3,
              fouls: 2,
              yellowCards: 0,
              redCards: 0,
              minutesPlayed: 90,
              rating: 7.5
            }
          ]
        }
      },
      highlights: [
        {
          id: '1',
          title: '김민석 첫 번째 골',
          description: '23분 멋진 슈팅으로 선제골',
          type: 'goal',
          minute: 23,
          videoUrl: null,
          thumbnailUrl: null
        },
        {
          id: '2',
          title: '박지성 동점골',
          description: '35분 강력한 중거리 슈팅',
          type: 'goal',
          minute: 35,
          videoUrl: null,
          thumbnailUrl: null
        }
      ]
    };

    res.json({
      message: 'Game details retrieved successfully',
      ...details
    });
  } catch (error) {
    console.error('Error getting game details:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/games', async (req, res) => {
  try {
    const game = await gameService.createGame(req.body);
    res.status(201).json({ 
      message: 'Game created successfully',
      game
    });
  } catch (error) {
    console.error('Error creating game:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Announcements API endpoints
app.get('/api/announcements', async (req, res) => {
  try {
    const filters = {
      tag: req.query.tag,
      search: req.query.search
    };
    const announcements = await announcementService.getAllAnnouncements(filters);
    res.json({ 
      message: 'Announcements retrieved successfully',
      announcements
    });
  } catch (error) {
    console.error('Error getting announcements:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/announcements/:id', async (req, res) => {
  try {
    const announcement = await announcementService.getAnnouncementById(req.params.id);
    if (!announcement) {
      return res.status(404).json({ error: 'Announcement not found' });
    }
    res.json({ 
      message: 'Announcement retrieved successfully',
      announcement
    });
  } catch (error) {
    console.error('Error getting announcement:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Statistics API endpoints
app.get('/api/statistics', async (req, res) => {
  try {
    const { user_id, team_id, season } = req.query;
    
    let statistics = {};
    
    if (user_id) {
      statistics.user = await statisticsService.getUserStats(user_id, season);
    }
    
    if (team_id) {
      statistics.team = await statisticsService.getTeamStats(team_id, season);
    }
    
    if (!user_id && !team_id) {
      statistics.topScorers = await statisticsService.getTopScorers(10, season);
      statistics.topAssisters = await statisticsService.getTopAssisters(10, season);
      statistics.teamRankings = await statisticsService.getTeamRankings(season);
    }
    
    res.json({ 
      message: 'Statistics retrieved successfully',
      statistics
    });
  } catch (error) {
    console.error('Error getting statistics:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/statistics/top-scorers', async (req, res) => {
  try {
    const { limit = 10, season } = req.query;
    const topScorers = await statisticsService.getTopScorers(parseInt(limit), season);
    res.json({ 
      message: 'Top scorers retrieved successfully',
      data: topScorers
    });
  } catch (error) {
    console.error('Error getting top scorers:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/statistics/top-assisters', async (req, res) => {
  try {
    const { limit = 10, season } = req.query;
    const topAssisters = await statisticsService.getTopAssisters(parseInt(limit), season);
    res.json({ 
      message: 'Top assisters retrieved successfully',
      data: topAssisters
    });
  } catch (error) {
    console.error('Error getting top assisters:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/statistics/team-rankings', async (req, res) => {
  try {
    const { season } = req.query;
    const teamRankings = await statisticsService.getTeamRankings(season);
    res.json({ 
      message: 'Team rankings retrieved successfully',
      data: teamRankings
    });
  } catch (error) {
    console.error('Error getting team rankings:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/statistics/teams/rankings - alias for team-rankings
app.get('/api/statistics/teams/rankings', async (req, res) => {
  try {
    const { season } = req.query;
    const teamRankings = await statisticsService.getTeamRankings(season);
    res.json({ 
      message: 'Team rankings retrieved successfully',
      data: teamRankings
    });
  } catch (error) {
    console.error('Error getting team rankings:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/statistics/players - Get all players with statistics
app.get('/api/statistics/players', async (req, res) => {
  try {
    const { season, limit = 50 } = req.query;
    const players = await statisticsService.getAllPlayersStats(season, parseInt(limit));
    res.json({ 
      message: 'Players statistics retrieved successfully',
      data: players
    });
  } catch (error) {
    console.error('Error getting players statistics:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/statistics/seasons/{season} - Get season summary statistics
app.get('/api/statistics/seasons/:season', async (req, res) => {
  try {
    const { season } = req.params;
    const seasonStats = await statisticsService.getSeasonStats(season);
    res.json({ 
      message: 'Season statistics retrieved successfully',
      data: seasonStats
    });
  } catch (error) {
    console.error('Error getting season statistics:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// GET /api/statistics/players/{playerId}/games - Get player's game history
app.get('/api/statistics/players/:playerId/games', async (req, res) => {
  try {
    const { playerId } = req.params;
    const { limit = 20 } = req.query;
    const gameHistory = await statisticsService.getPlayerGameHistory(playerId, parseInt(limit));
    res.json({ 
      message: 'Player game history retrieved successfully',
      data: gameHistory
    });
  } catch (error) {
    console.error('Error getting player game history:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Recent Activities API endpoints
app.get('/api/activities/recent', async (req, res) => {
  try {
    const { user_id, limit = 10, since, types } = req.query;
    
    // For now, return mock data since we don't have activity tracking implemented yet
    const mockActivities = generateMockActivities(parseInt(limit));
    
    // Filter by user_id if provided
    let filteredActivities = mockActivities;
    if (user_id) {
      // In real implementation, filter by user_id from database
      filteredActivities = mockActivities.filter(activity => 
        activity.metadata && activity.metadata.user_id === user_id
      );
      
      // If no user-specific activities, still return some sample data
      if (filteredActivities.length === 0) {
        filteredActivities = mockActivities.slice(0, 3);
      }
    }
    
    // Filter by types if provided
    if (types) {
      const typeList = types.split(',');
      filteredActivities = filteredActivities.filter(activity => 
        typeList.includes(activity.type)
      );
    }
    
    // Filter by since date if provided
    if (since) {
      const sinceDate = new Date(since);
      filteredActivities = filteredActivities.filter(activity => 
        new Date(activity.timestamp) >= sinceDate
      );
    }
    
    res.json({
      message: 'Recent activities retrieved successfully',
      data: filteredActivities.slice(0, parseInt(limit))
    });
  } catch (error) {
    console.error('Error getting recent activities:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/activities/by-type', async (req, res) => {
  try {
    const { type, user_id, limit = 20, since } = req.query;
    
    if (!type) {
      return res.status(400).json({ error: 'Activity type is required' });
    }
    
    // For now, return mock data filtered by type
    const mockActivities = generateMockActivities(50);
    let filteredActivities = mockActivities.filter(activity => activity.type === type);
    
    // Filter by user_id if provided
    if (user_id) {
      filteredActivities = filteredActivities.filter(activity => 
        activity.metadata && activity.metadata.user_id === user_id
      );
    }
    
    // Filter by since date if provided
    if (since) {
      const sinceDate = new Date(since);
      filteredActivities = filteredActivities.filter(activity => 
        new Date(activity.timestamp) >= sinceDate
      );
    }
    
    res.json({
      message: 'Activities retrieved successfully',
      data: filteredActivities.slice(0, parseInt(limit))
    });
  } catch (error) {
    console.error('Error getting activities by type:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/activities', async (req, res) => {
  try {
    const activityData = req.body;
    
    // In real implementation, save to database
    // For now, just return the activity with an id
    const activity = {
      id: `activity_${Date.now()}`,
      ...activityData,
      timestamp: activityData.timestamp || new Date().toISOString()
    };
    
    res.status(201).json({
      message: 'Activity created successfully',
      data: activity
    });
  } catch (error) {
    console.error('Error creating activity:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.put('/api/activities/:id/status', async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    
    if (!status) {
      return res.status(400).json({ error: 'Status is required' });
    }
    
    // In real implementation, update in database
    // For now, just return mock updated activity
    const updatedActivity = {
      id,
      status,
      updated_at: new Date().toISOString()
    };
    
    res.json({
      message: 'Activity status updated successfully',
      data: updatedActivity
    });
  } catch (error) {
    console.error('Error updating activity status:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.delete('/api/activities/:id', async (req, res) => {
  try {
    const { id } = req.params;
    
    // In real implementation, delete from database
    
    res.json({
      message: 'Activity deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting activity:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.patch('/api/activities/:id/read', async (req, res) => {
  try {
    const { id } = req.params;
    
    // In real implementation, mark as read in database
    
    res.json({
      message: 'Activity marked as read'
    });
  } catch (error) {
    console.error('Error marking activity as read:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/activities/statistics', async (req, res) => {
  try {
    const { user_id, from, to } = req.query;
    
    // Mock statistics data
    const statistics = {
      total_activities: 42,
      activities_by_type: {
        game: 15,
        training: 12,
        meeting: 8,
        achievement: 4,
        announcement: 3
      },
      most_active_day: 'Monday',
      completion_rate: 89.5,
      recent_streak: 7
    };
    
    res.json({
      message: 'Activity statistics retrieved successfully',
      data: statistics
    });
  } catch (error) {
    console.error('Error getting activity statistics:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Helper function to generate mock activities
function generateMockActivities(limit = 10) {
  const now = new Date();
  const activities = [];
  
  const activityTypes = [
    {
      type: 'game',
      titles: ['대한고등학교 vs 강북고등학교', '서울고등학교 vs 대한고등학교', '대한고등학교 vs 부산고등학교'],
      subtitles: ['3-1 승리', '2-2 무승부', '4-0 승리', '1-2 패배'],
      status: 'completed'
    },
    {
      type: 'training',
      titles: ['개인 훈련 세션', '팀 훈련', '골키퍼 훈련', '체력 훈련'],
      subtitles: ['90분 훈련', '120분 훈련', '60분 훈련', '패스 연습'],
      status: 'completed'
    },
    {
      type: 'meeting',
      titles: ['팀 회의', '전술 회의', '코치진 회의', '학부모 회의'],
      subtitles: ['전술 토론', '다음 경기 준비', '선수 평가', '일정 조정'],
      status: 'completed'
    },
    {
      type: 'achievement',
      titles: ['시즌 10골 달성!', '연속 5경기 출전', '팀 MVP 선정', '베스트 11 선발'],
      subtitles: ['축하합니다!', '꾸준한 출전', '뛰어난 활약', '시즌 최고 성과'],
      status: 'completed'
    },
    {
      type: 'announcement',
      titles: ['훈련 일정 변경', '경기 일정 공지', '팀 이벤트 안내', '시설 사용 안내'],
      subtitles: ['이번 주 일정 변경', '다음 주 경기', '팀 dinner 모임', '새로운 시설 오픈'],
      status: 'completed'
    }
  ];
  
  for (let i = 0; i < limit; i++) {
    const activityType = activityTypes[Math.floor(Math.random() * activityTypes.length)];
    const title = activityType.titles[Math.floor(Math.random() * activityType.titles.length)];
    const subtitle = activityType.subtitles[Math.floor(Math.random() * activityType.subtitles.length)];
    
    // Generate timestamp (random time in the past 30 days)
    const daysAgo = Math.floor(Math.random() * 30);
    const hoursAgo = Math.floor(Math.random() * 24);
    const timestamp = new Date(now.getTime() - (daysAgo * 24 + hoursAgo) * 60 * 60 * 1000);
    
    activities.push({
      id: `activity_${Date.now()}_${i}`,
      title,
      subtitle,
      type: activityType.type,
      status: activityType.status,
      timestamp: timestamp.toISOString(),
      metadata: {
        user_id: 'mock_user_id',
        activity_index: i,
        generated: true
      },
      action_url: activityType.type === 'game' ? `/game-detail/game_${i}` : 
                  activityType.type === 'announcement' ? '/announcements' :
                  activityType.type === 'achievement' ? '/statistics' : null
    });
  }
  
  // Sort by timestamp (newest first)
  activities.sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp));
  
  return activities;
}

// Realtime API endpoints
app.get('/api/realtime/status', (req, res) => {
  try {
    const status = {
      connectedUsers: realtimeService.getConnectedUsersCount(),
      timestamp: new Date().toISOString()
    };
    res.json({ 
      message: 'Realtime status retrieved successfully',
      status
    });
  } catch (error) {
    console.error('Error getting realtime status:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/realtime/notification', async (req, res) => {
  try {
    const { userId, notification } = req.body;
    if (userId && notification) {
      realtimeService.sendNotification(userId, notification);
      res.json({ message: 'Notification sent successfully' });
    } else {
      res.status(400).json({ error: 'User ID and notification are required' });
    }
  } catch (error) {
    console.error('Error sending notification:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/realtime/team-notification', async (req, res) => {
  try {
    const { teamId, notification } = req.body;
    if (teamId && notification) {
      realtimeService.sendTeamNotification(teamId, notification);
      res.json({ message: 'Team notification sent successfully' });
    } else {
      res.status(400).json({ error: 'Team ID and notification are required' });
    }
  } catch (error) {
    console.error('Error sending team notification:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.post('/api/realtime/game-score-update', async (req, res) => {
  try {
    const { gameId, scoreData } = req.body;
    if (gameId && scoreData) {
      realtimeService.broadcastGameScoreUpdate(gameId, scoreData);
      res.json({ message: 'Game score update broadcasted successfully' });
    } else {
      res.status(400).json({ error: 'Game ID and score data are required' });
    }
  } catch (error) {
    console.error('Error broadcasting game score update:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

const PORT = process.env.PORT || 3001;

httpServer.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🔗 Health check: http://localhost:${PORT}/health`);
  console.log(`🔌 WebSocket server ready on port ${PORT}`);
}); 