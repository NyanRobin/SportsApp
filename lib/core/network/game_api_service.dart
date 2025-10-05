import '../../shared/models/game_model.dart';
import '../../shared/models/game_timeline_model.dart';
import '../../shared/models/game_lineup_model.dart';
import '../../shared/models/game_stats_model.dart';
import '../../shared/models/game_highlights_model.dart';
import 'api_service.dart';

class GameApiService {
  final ApiService _apiService;

  GameApiService(this._apiService);

  // 모든 게임 목록 가져오기
  Future<List<Game>> getAllGames() async {
    try {
      final response = await _apiService.get('/games');
      
      if (response['games'] != null) {
        final List<dynamic> gamesJson = response['games'];
        return gamesJson.map((json) => Game.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Failed to get games from API, using mock data: $e');
      return _getMockGames();
    }
  }

  // Mock 게임 데이터 생성
  List<Game> _getMockGames() {
    return [
      Game(
        id: 1,
        title: '대한고등학교 vs 강북고등학교',
        homeTeamId: 1,
        awayTeamId: 2,
        homeTeamName: '대한고등학교',
        awayTeamName: '강북고등학교',
        homeScore: 3,
        awayScore: 1,
        gameDate: DateTime.now().subtract(const Duration(hours: 2)),
        venue: '대한고등학교 운동장',
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Game(
        id: 2,
        title: '서울고등학교 vs 대한고등학교',
        homeTeamId: 3,
        awayTeamId: 1,
        homeTeamName: '서울고등학교',
        awayTeamName: '대한고등학교',
        homeScore: 2,
        awayScore: 2,
        gameDate: DateTime.now().subtract(const Duration(days: 1)),
        venue: '서울고등학교 운동장',
        status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Game(
        id: 3,
        title: '강북고등학교 vs 서울고등학교',
        homeTeamId: 2,
        awayTeamId: 3,
        homeTeamName: '강북고등학교',
        awayTeamName: '서울고등학교',
        homeScore: 0,
        awayScore: 0,
        gameDate: DateTime.now().add(const Duration(days: 3)),
        venue: '강북고등학교 운동장',
        status: 'scheduled',
        createdAt: DateTime.now(),
      ),
      Game(
        id: 4,
        title: '대한고등학교 vs 대구고등학교',
        homeTeamId: 1,
        awayTeamId: 4,
        homeTeamName: '대한고등학교',
        awayTeamName: '대구고등학교',
        homeScore: 0,
        awayScore: 0,
        gameDate: DateTime.now().add(const Duration(days: 7)),
        venue: '대한고등학교 운동장',
        status: 'scheduled',
        createdAt: DateTime.now(),
      ),
    ];
  }

  // 특정 게임 가져오기
  Future<Game?> getGameById(int gameId) async {
    try {
      final response = await _apiService.get('/games/$gameId');
      
      if (response['game'] != null) {
        return Game.fromJson(response['game']);
      }
      
      return null;
    } catch (e) {
      print('Failed to get game from API, using mock data: $e');
      // Return mock game by ID
      final mockGames = _getMockGames();
      try {
        return mockGames.firstWhere((game) => game.id == gameId);
      } catch (e) {
        return mockGames.isNotEmpty ? mockGames.first : null;
      }
    }
  }

  // 게임 생성
  Future<Game> createGame(Map<String, dynamic> gameData) async {
    try {
      final response = await _apiService.post('/games', data: gameData);
      
      if (response['game'] != null) {
        return Game.fromJson(response['game']);
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to create game: $e');
    }
  }

  // 게임 업데이트
  Future<Game> updateGame(int gameId, Map<String, dynamic> gameData) async {
    try {
      final response = await _apiService.put('/games/$gameId', data: gameData);
      
      if (response['game'] != null) {
        return Game.fromJson(response['game']);
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Failed to update game: $e');
    }
  }

  // 게임 삭제
  Future<void> deleteGame(int gameId) async {
    try {
      await _apiService.delete('/games/$gameId');
    } catch (e) {
      throw Exception('Failed to delete game: $e');
    }
  }

  // 게임 통계 가져오기
  Future<Map<String, dynamic>> getGameStats(int gameId) async {
    try {
      final response = await _apiService.get('/games/$gameId/stats');
      return response;
    } catch (e) {
      throw Exception('Failed to get game stats: $e');
    }
  }

  // 게임 통계 추가
  Future<void> addGameStats(int gameId, Map<String, dynamic> statsData) async {
    try {
      await _apiService.post('/games/$gameId/stats', data: statsData);
    } catch (e) {
      throw Exception('Failed to add game stats: $e');
    }
  }

  // 필터링된 게임 목록 가져오기
  Future<List<Game>> getFilteredGames({
    String? status,
    String? team,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (status != null) queryParams['status'] = status;
      if (team != null) queryParams['team'] = team;
      if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
      if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
      
      final response = await _apiService.get('/games', queryParameters: queryParams);
      
      if (response['games'] != null) {
        final List<dynamic> gamesJson = response['games'];
        return gamesJson.map((json) => Game.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get filtered games: $e');
    }
  }

  // 오늘의 게임 가져오기
  Future<List<Game>> getTodayGames() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      
      return await getFilteredGames(
        startDate: startOfDay,
        endDate: endOfDay,
      );
    } catch (e) {
      throw Exception('Failed to get today\'s games: $e');
    }
  }

  // 이번 주 게임 가져오기
  Future<List<Game>> getThisWeekGames() async {
    try {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      
      return await getFilteredGames(
        startDate: startOfWeek,
        endDate: endOfWeek,
      );
    } catch (e) {
      throw Exception('Failed to get this week\'s games: $e');
    }
  }

  // 팀별 게임 가져오기
  Future<List<Game>> getTeamGames(String teamName) async {
    try {
      return await getFilteredGames(team: teamName);
    } catch (e) {
      throw Exception('Failed to get team games: $e');
    }
  }

  // 게임 타임라인 가져오기
  Future<List<GameTimelineEvent>> getGameTimeline(int gameId) async {
    try {
      final response = await _apiService.get('/games/$gameId/timeline');
      
      if (response['timeline'] != null) {
        final List<dynamic> timelineJson = response['timeline'];
        return timelineJson.map((json) => GameTimelineEvent.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get game timeline: $e');
    }
  }

  // 게임 라인업 가져오기
  Future<Map<String, GameLineup>> getGameLineup(int gameId) async {
    try {
      final response = await _apiService.get('/games/$gameId/lineup');
      
      final Map<String, GameLineup> lineups = {};
      
      if (response['home_team'] != null) {
        lineups['home'] = GameLineup.fromJson(response['home_team']);
      }
      
      if (response['away_team'] != null) {
        lineups['away'] = GameLineup.fromJson(response['away_team']);
      }
      
      return lineups;
    } catch (e) {
      throw Exception('Failed to get game lineup: $e');
    }
  }

  // 게임 통계 가져오기 (기존 메서드 수정)
  Future<GameStats?> getGameStatistics(int gameId) async {
    try {
      final response = await _apiService.get('/games/$gameId/statistics');
      
      if (response['statistics'] != null) {
        return GameStats.fromJson(response['statistics']);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get game statistics: $e');
    }
  }

  // 게임 하이라이트 가져오기
  Future<List<GameHighlight>> getGameHighlights(int gameId) async {
    try {
      final response = await _apiService.get('/games/$gameId/highlights');
      
      if (response['highlights'] != null) {
        final List<dynamic> highlightsJson = response['highlights'];
        return highlightsJson.map((json) => GameHighlight.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to get game highlights: $e');
    }
  }

  // 게임 상세 정보 모두 가져오기 (단일 요청으로 모든 데이터)
  Future<Map<String, dynamic>> getGameDetails(int gameId) async {
    try {
      final response = await _apiService.get('/games/$gameId/details');
      
      return {
        'game': response['game'] != null ? Game.fromJson(response['game']) : null,
        'timeline': response['timeline'] != null 
            ? (response['timeline'] as List<dynamic>)
                .map((json) => GameTimelineEvent.fromJson(json))
                .toList() 
            : <GameTimelineEvent>[],
        'lineup': response['lineup'] != null 
            ? {
                'home': response['lineup']['home_team'] != null 
                    ? GameLineup.fromJson(response['lineup']['home_team']) 
                    : null,
                'away': response['lineup']['away_team'] != null 
                    ? GameLineup.fromJson(response['lineup']['away_team']) 
                    : null,
              }
            : <String, GameLineup?>{},
        'statistics': response['statistics'] != null 
            ? GameStats.fromJson(response['statistics']) 
            : null,
        'highlights': response['highlights'] != null 
            ? (response['highlights'] as List<dynamic>)
                .map((json) => GameHighlight.fromJson(json))
                .toList() 
            : <GameHighlight>[],
      };
    } catch (e) {
      print('Failed to get game details from API, using mock data: $e');
      return _getMockGameDetails(gameId);
    }
  }

  // Mock 게임 상세 데이터 생성
  Map<String, dynamic> _getMockGameDetails(int gameId) {
    final game = _getMockGames().firstWhere(
      (g) => g.id == gameId,
      orElse: () => _getMockGames().first,
    );

    return {
      'game': game,
      'timeline': [
        GameTimelineEvent(
          id: 1,
          gameId: gameId,
          eventType: 'kickoff',
          minute: 0,
          description: '경기 시작',
          playerName: null,
          teamName: null,
          createdAt: DateTime.now(),
        ),
        GameTimelineEvent(
          id: 2,
          gameId: gameId,
          eventType: 'goal',
          minute: 23,
          description: '김민석 선제골',
          playerName: '김민석',
          teamName: game.homeTeamName,
          createdAt: DateTime.now(),
        ),
        if (game.awayScore > 0)
          GameTimelineEvent(
            id: 3,
            gameId: gameId,
            eventType: 'goal',
            minute: 35,
            description: '박지성 동점골',
            playerName: '박지성',
            teamName: game.awayTeamName,
            createdAt: DateTime.now(),
          ),
        GameTimelineEvent(
          id: 4,
          gameId: gameId,
          eventType: 'fulltime',
          minute: 90,
          description: '경기 종료',
          playerName: null,
          teamName: null,
          createdAt: DateTime.now(),
        ),
      ],
      'lineup': {
        'home': GameLineup(
          gameId: gameId,
          teamName: game.homeTeamName,
          formation: '4-4-2',
          startingEleven: [
            PlayerLineup(
              playerId: 1,
              playerName: '김민석',
              position: 'Forward',
              jerseyNumber: 10,
              isCaptain: true,
            ),
            PlayerLineup(
              playerId: 2,
              playerName: '정태우',
              position: 'Defender',
              jerseyNumber: 4,
            ),
          ],
          substitutes: [],
          updatedAt: DateTime.now(),
        ),
        'away': GameLineup(
          gameId: gameId,
          teamName: game.awayTeamName,
          formation: '4-3-3',
          startingEleven: [
            PlayerLineup(
              playerId: 3,
              playerName: '박지성',
              position: 'Midfielder',
              jerseyNumber: 7,
              isCaptain: true,
            ),
          ],
          substitutes: [],
          updatedAt: DateTime.now(),
        ),
      },
      'statistics': GameStats(
        gameId: gameId,
        homeTeam: TeamStats(
          teamName: game.homeTeamName,
          possession: 55,
          shots: 15,
          shotsOnTarget: 8,
          corners: 6,
          fouls: 12,
          yellowCards: 2,
          redCards: 0,
          passes: 420,
          passAccuracy: 84,
          saves: 3,
          offsides: 2,
        ),
        awayTeam: TeamStats(
          teamName: game.awayTeamName,
          possession: 45,
          shots: 12,
          shotsOnTarget: 5,
          corners: 4,
          fouls: 15,
          yellowCards: 3,
          redCards: 0,
          passes: 380,
          passAccuracy: 78,
          saves: 5,
          offsides: 1,
        ),
        updatedAt: DateTime.now(),
      ),
      'highlights': [
        GameHighlight(
          id: 1,
          gameId: gameId,
          title: '김민석 첫 번째 골',
          description: '23분 멋진 슈팅으로 선제골',
          highlightType: 'goal',
          minute: 23,
          playerName: '김민석',
          teamName: game.homeTeamName,
          videoUrl: null,
          thumbnailUrl: null,
          duration: 30,
          createdAt: DateTime.now(),
        ),
        if (game.awayScore > 0)
          GameHighlight(
            id: 2,
            gameId: gameId,
            title: '박지성 동점골',
            description: '35분 강력한 중거리 슈팅',
            highlightType: 'goal',
            minute: 35,
            playerName: '박지성',
            teamName: game.awayTeamName,
            videoUrl: null,
            thumbnailUrl: null,
            duration: 25,
            createdAt: DateTime.now(),
          ),
      ],
    };
  }
} 