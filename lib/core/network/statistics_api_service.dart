import '../../shared/models/comprehensive_statistics_model.dart';
import 'api_service.dart';

class StatisticsApiService {
  final ApiService _apiService;

  StatisticsApiService(this._apiService);

  // GET /api/statistics/top-scorers
  Future<List<TopScorer>> getTopScorers({int limit = 10, String? season}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/statistics/top-scorers', queryParameters: queryParams);
      
      if (response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => TopScorer.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting top scorers from API, using mock data: $e');
      return _getMockTopScorers(limit);
    }
  }

  // GET /api/statistics/top-assisters
  Future<List<TopAssister>> getTopAssisters({int limit = 10, String? season}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/statistics/top-assisters', queryParameters: queryParams);
      
      if (response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => TopAssister.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting top assisters from API, using mock data: $e');
      return _getMockTopAssisters(limit);
    }
  }

  // GET /api/statistics/teams/rankings
  Future<List<TeamRanking>> getTeamRankings({String? season}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/statistics/teams/rankings', queryParameters: queryParams);
      
      if (response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => TeamRanking.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting team rankings from API, using mock data: $e');
      return _getMockTeamRankings();
    }
  }

  // GET /api/statistics/players
  Future<List<PlayerStatistics>> getAllPlayersStats({String? season, int limit = 50}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/statistics/players', queryParameters: queryParams);
      
      if (response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => PlayerStatistics.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting players stats: $e');
      throw Exception('Failed to get players stats: $e');
    }
  }

  // GET /api/statistics/seasons/{season}
  Future<SeasonStatistics?> getSeasonStats(String season) async {
    try {
      final response = await _apiService.get('/statistics/seasons/$season');
      
      if (response['data'] != null) {
        return SeasonStatistics.fromJson(response['data']);
      }
      
      return null;
    } catch (e) {
      print('Error getting season stats: $e');
      throw Exception('Failed to get season stats: $e');
    }
  }

  // GET /api/statistics/players/{playerId}/games
  Future<List<GamePerformance>> getPlayerGameHistory(String playerId, {int limit = 20}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};

      final response = await _apiService.get('/statistics/players/$playerId/games', queryParameters: queryParams);
      
      if (response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => GamePerformance.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting player game history: $e');
      throw Exception('Failed to get player game history: $e');
    }
  }

  // 전체 통계 가져오기 (기존 API 호환성)
  Future<Map<String, dynamic>> getOverallStats({
    String? userId,
    int? teamId,
    String? season,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['user_id'] = userId;
      if (teamId != null) queryParams['team_id'] = teamId;
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/statistics', queryParameters: queryParams);
      return response;
    } catch (e) {
      throw Exception('Failed to get overall stats: $e');
    }
  }

  // 사용자 통계 가져오기 (기존 API 호환성)
  Future<Map<String, dynamic>?> getUserStats(String userId, {String? season}) async {
    try {
      final queryParams = <String, dynamic>{'user_id': userId};
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/statistics', queryParameters: queryParams);
      
      if (response['user_stats'] != null) {
        return response['user_stats'];
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get user stats: $e');
    }
  }

  // 팀 통계 가져오기 (기존 API 호환성)
  Future<Map<String, dynamic>?> getTeamStats(int teamId, {String? season}) async {
    try {
      final queryParams = <String, dynamic>{'team_id': teamId};
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/statistics', queryParameters: queryParams);
      
      if (response['team_stats'] != null) {
        return response['team_stats'];
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get team stats: $e');
    }
  }

  // Top scorers (기존 API 호환성)
  Future<List<Map<String, dynamic>>> getTopScorersLegacy({int limit = 10, String? season}) async {
    try {
      final topScorers = await getTopScorers(limit: limit, season: season);
      
      return topScorers.map((scorer) => {
        'name': scorer.user_name,
        'value': scorer.goals.toString(),
        'subtitle': '${scorer.total_games} games',
      }).toList();
    } catch (e) {
      throw Exception('Failed to get top scorers: $e');
    }
  }

  // Create/Update player statistics
  Future<bool> createPlayerStatistics(PlayerStatistics stats) async {
    try {
      await _apiService.post('/statistics/players', data: stats.toJson());
      return true;
    } catch (e) {
      throw Exception('Failed to create player statistics: $e');
    }
  }

  // Update player statistics
  Future<bool> updatePlayerStatistics(String playerId, PlayerStatistics stats) async {
    try {
      await _apiService.put('/statistics/players/$playerId', data: stats.toJson());
      return true;
    } catch (e) {
      throw Exception('Failed to update player statistics: $e');
    }
  }

  // Get detailed team rankings
  Future<List<TeamRanking>> getDetailedTeamRankings({String? season}) async {
    return getTeamRankings(season: season);
  }

  // Get player statistics with details
  Future<PlayerStatistics?> getPlayerStatistics(String playerId, {String? season}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/statistics/players/$playerId', queryParameters: queryParams);
      
      if (response['data'] != null) {
        return PlayerStatistics.fromJson(response['data']);
      }
      
      return null;
    } catch (e) {
      print('Error getting player statistics: $e');
      throw Exception('Failed to get player statistics: $e');
    }
  }

  // Get season statistics with comprehensive data
  Future<SeasonStatistics?> getSeasonStatistics(String season) async {
    return getSeasonStats(season);
  }

  // Get player game performances
  Future<List<GamePerformance>> getPlayerGamePerformances(String playerId, {String? season, int limit = 20}) async {
    return getPlayerGameHistory(playerId, limit: limit);
  }

  // Get statistics by position
  Future<Map<String, List<PlayerStatistics>>> getStatsByPosition({String? season}) async {
    try {
      final players = await getAllPlayersStats(season: season);
      final Map<String, List<PlayerStatistics>> statsByPosition = {};

      for (final player in players) {
        final position = player.position;
        if (!statsByPosition.containsKey(position)) {
          statsByPosition[position] = [];
        }
        statsByPosition[position]!.add(player);
      }

      return statsByPosition;
    } catch (e) {
      throw Exception('Failed to get stats by position: $e');
    }
  }

  // Get live statistics (placeholder for real-time data)
  Future<Map<String, dynamic>> getLiveStatistics() async {
    try {
      final response = await _apiService.get('/statistics/live');
      return response;
    } catch (e) {
      // Fallback to regular statistics if live endpoint is not available
      return getOverallStats();
    }
  }

  // Compare player statistics
  Future<Map<String, PlayerStatistics?>> comparePlayerStatistics(List<String> playerIds, {String? season}) async {
    try {
      final Map<String, PlayerStatistics?> comparison = {};
      
      for (final playerId in playerIds) {
        comparison[playerId] = await getPlayerStatistics(playerId, season: season);
      }
      
      return comparison;
    } catch (e) {
      throw Exception('Failed to compare player statistics: $e');
    }
  }

  // Mock data methods for fallback
  List<TopScorer> _getMockTopScorers(int limit) {
    final mockScorers = [
      TopScorer(
        rank: 1,
        user_id: '1',
        user_name: '김민석',
        is_student: true,
        grade_or_subject: '3학년',
        position: 'Forward',
        jersey_number: 10,
        team_name: '대한고등학교',
        goals: 15,
        assists: 8,
        total_games: 12,
        total_minutes: 1080,
        goals_per_game: 1.25,
      ),
      TopScorer(
        rank: 2,
        user_id: '2',
        user_name: '박지성',
        is_student: true,
        grade_or_subject: '2학년',
        position: 'Midfielder',
        jersey_number: 7,
        team_name: '강북고등학교',
        goals: 12,
        assists: 15,
        total_games: 11,
        total_minutes: 990,
        goals_per_game: 1.09,
      ),
      TopScorer(
        rank: 3,
        user_id: '3',
        user_name: '이준호',
        is_student: true,
        grade_or_subject: '3학년',
        position: 'Forward',
        jersey_number: 9,
        team_name: '서울고등학교',
        goals: 10,
        assists: 6,
        total_games: 10,
        total_minutes: 900,
        goals_per_game: 1.00,
      ),
    ];
    
    return mockScorers.take(limit).toList();
  }

  List<TopAssister> _getMockTopAssisters(int limit) {
    final mockAssisters = [
      TopAssister(
        rank: 1,
        user_id: '2',
        user_name: '박지성',
        is_student: true,
        grade_or_subject: '2학년',
        position: 'Midfielder',
        jersey_number: 7,
        team_name: '강북고등학교',
        assists: 15,
        goals: 12,
        total_games: 11,
        total_minutes: 990,
        assists_per_game: 1.36,
      ),
      TopAssister(
        rank: 2,
        user_id: '4',
        user_name: '최재원',
        is_student: true,
        grade_or_subject: '1학년',
        position: 'Midfielder',
        jersey_number: 8,
        team_name: '서울고등학교',
        assists: 12,
        goals: 5,
        total_games: 9,
        total_minutes: 810,
        assists_per_game: 1.33,
      ),
      TopAssister(
        rank: 3,
        user_id: '1',
        user_name: '김민석',
        is_student: true,
        grade_or_subject: '3학년',
        position: 'Forward',
        jersey_number: 10,
        team_name: '대한고등학교',
        assists: 8,
        goals: 15,
        total_games: 12,
        total_minutes: 1080,
        assists_per_game: 0.67,
      ),
    ];
    
    return mockAssisters.take(limit).toList();
  }

  List<TeamRanking> _getMockTeamRankings() {
    return [
      TeamRanking(
        team_id: 1,
        team_name: '대한고등학교',
        description: '대한고등학교 축구부',
        logo_url: null,
        rank: 1,
        total_games: 12,
        completed_games: 12,
        wins: 10,
        draws: 1,
        losses: 1,
        goals_for: 35,
        goals_against: 12,
        goal_difference: 23,
        points: 31,
        win_rate: 83.3,
        season: '2025',
      ),
      TeamRanking(
        team_id: 2,
        team_name: '강북고등학교',
        description: '강북고등학교 축구부',
        logo_url: null,
        rank: 2,
        total_games: 11,
        completed_games: 11,
        wins: 8,
        draws: 2,
        losses: 1,
        goals_for: 28,
        goals_against: 15,
        goal_difference: 13,
        points: 26,
        win_rate: 72.7,
        season: '2025',
      ),
      TeamRanking(
        team_id: 3,
        team_name: '서울고등학교',
        description: '서울고등학교 축구부',
        logo_url: null,
        rank: 3,
        total_games: 10,
        completed_games: 10,
        wins: 6,
        draws: 2,
        losses: 2,
        goals_for: 22,
        goals_against: 18,
        goal_difference: 4,
        points: 20,
        win_rate: 60.0,
        season: '2025',
      ),
    ];
  }
  Future<Map<String, PlayerStatistics>> comparePlayerStats(List<String> playerIds, {String? season}) async {
    try {
      final Map<String, PlayerStatistics> comparison = {};
      
      for (final playerId in playerIds) {
        final stats = await getPlayerStatistics(playerId, season: season);
        if (stats != null) {
          comparison[playerId] = stats;
        }
      }
      
      return comparison;
    } catch (e) {
      throw Exception('Failed to compare player stats: $e');
    }
  }

  // Compare team statistics
  Future<Map<int, TeamRanking>> compareTeamStats(List<int> teamIds, {String? season}) async {
    try {
      final rankings = await getTeamRankings(season: season);
      final Map<int, TeamRanking> comparison = {};
      
      for (final ranking in rankings) {
        if (teamIds.contains(ranking.team_id)) {
          comparison[ranking.team_id] = ranking;
        }
      }
      
      return comparison;
    } catch (e) {
      throw Exception('Failed to compare team stats: $e');
    }
  }

  // Export statistics data
  Future<Map<String, dynamic>> exportStats({
    String? season,
    String? format = 'json',
    List<String>? includeFields,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'format': format,
      };
      if (season != null) queryParams['season'] = season;
      if (includeFields != null) queryParams['fields'] = includeFields.join(',');

      final response = await _apiService.get('/statistics/export', queryParameters: queryParams);
      return response;
    } catch (e) {
      throw Exception('Failed to export stats: $e');
    }
  }
} 