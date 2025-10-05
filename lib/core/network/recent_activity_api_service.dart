import '../../shared/models/recent_activity_model.dart';
import 'api_service.dart';

class RecentActivityApiService {
  final ApiService _apiService;

  RecentActivityApiService(this._apiService);

  // Get recent activities for a user
  Future<List<RecentActivity>> getRecentActivities({
    String? userId,
    int limit = 10,
    DateTime? since,
    List<ActivityType>? types,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
      };
      
      if (userId != null) {
        queryParams['user_id'] = userId;
      }
      
      if (since != null) {
        queryParams['since'] = since.toIso8601String();
      }
      
      if (types != null && types.isNotEmpty) {
        queryParams['types'] = types.map((t) => t.name).join(',');
      }

      final response = await _apiService.get('/activities/recent', queryParameters: queryParams);
      
      if (response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => RecentActivity.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting recent activities: $e');
      throw Exception('Failed to get recent activities: $e');
    }
  }

  // Get activities by type
  Future<List<RecentActivity>> getActivitiesByType({
    required ActivityType type,
    String? userId,
    int limit = 20,
    DateTime? since,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'type': type.name,
        'limit': limit,
      };
      
      if (userId != null) {
        queryParams['user_id'] = userId;
      }
      
      if (since != null) {
        queryParams['since'] = since.toIso8601String();
      }

      final response = await _apiService.get('/activities/by-type', queryParameters: queryParams);
      
      if (response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => RecentActivity.fromJson(json)).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting activities by type: $e');
      throw Exception('Failed to get activities by type: $e');
    }
  }

  // Create a new activity
  Future<RecentActivity> createActivity(RecentActivity activity) async {
    try {
      final response = await _apiService.post('/activities', data: activity.toJson());
      
      if (response['data'] != null) {
        return RecentActivity.fromJson(response['data']);
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      print('Error creating activity: $e');
      throw Exception('Failed to create activity: $e');
    }
  }

  // Update activity status
  Future<RecentActivity> updateActivityStatus({
    required String activityId,
    required ActivityStatus status,
  }) async {
    try {
      final response = await _apiService.put('/activities/$activityId/status', data: {
        'status': status.name,
      });
      
      if (response['data'] != null) {
        return RecentActivity.fromJson(response['data']);
      }
      
      throw Exception('Invalid response format');
    } catch (e) {
      print('Error updating activity status: $e');
      throw Exception('Failed to update activity status: $e');
    }
  }

  // Delete activity
  Future<void> deleteActivity(String activityId) async {
    try {
      await _apiService.delete('/activities/$activityId');
    } catch (e) {
      print('Error deleting activity: $e');
      throw Exception('Failed to delete activity: $e');
    }
  }

  // Mark activity as read
  Future<void> markActivityAsRead(String activityId) async {
    try {
      await _apiService.put('/activities/$activityId/read', data: {});
    } catch (e) {
      print('Error marking activity as read: $e');
      throw Exception('Failed to mark activity as read: $e');
    }
  }

  // Get activity statistics
  Future<Map<String, dynamic>> getActivityStatistics({
    String? userId,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (userId != null) {
        queryParams['user_id'] = userId;
      }
      
      if (from != null) {
        queryParams['from'] = from.toIso8601String();
      }
      
      if (to != null) {
        queryParams['to'] = to.toIso8601String();
      }

      final response = await _apiService.get('/activities/statistics', queryParameters: queryParams);
      
      return response['data'] ?? {};
    } catch (e) {
      print('Error getting activity statistics: $e');
      throw Exception('Failed to get activity statistics: $e');
    }
  }

  // Generate mock data for development/testing
  List<RecentActivity> generateMockActivities() {
    final now = DateTime.now();
    
    return [
      RecentActivity.gameResult(
        gameId: 'game_001',
        homeTeam: '대한고등학교',
        awayTeam: '강북고등학교',
        result: '3-1 승리',
        timestamp: now.subtract(const Duration(hours: 2)),
        status: ActivityStatus.completed,
      ),
      RecentActivity.training(
        trainingId: 'training_001',
        title: '개인 훈련 세션',
        duration: 90,
        timestamp: now.subtract(const Duration(days: 1)),
        status: ActivityStatus.completed,
      ),
      RecentActivity.achievement(
        achievementId: 'achievement_001',
        title: '시즌 10골 달성!',
        description: '축하합니다! 이번 시즌 10골을 달성했습니다.',
        timestamp: now.subtract(const Duration(days: 1, hours: 5)),
      ),
      RecentActivity.meeting(
        meetingId: 'meeting_001',
        title: '팀 회의',
        description: '전술 토론 및 다음 경기 준비',
        timestamp: now.subtract(const Duration(days: 2)),
        status: ActivityStatus.completed,
      ),
      RecentActivity.announcement(
        announcementId: 'announcement_001',
        title: '새로운 공지사항',
        preview: '이번 주 훈련 일정이 변경되었습니다.',
        timestamp: now.subtract(const Duration(days: 3)),
      ),
      RecentActivity.statisticsUpdate(
        updateId: 'stats_001',
        title: '통계 업데이트',
        description: '이번 주 개인 기록이 업데이트되었습니다.',
        timestamp: now.subtract(const Duration(days: 4)),
      ),
      RecentActivity.profileUpdate(
        updateId: 'profile_001',
        title: '프로필 수정',
        description: '프로필 정보가 업데이트되었습니다.',
        timestamp: now.subtract(const Duration(days: 5)),
      ),
      RecentActivity.gameResult(
        gameId: 'game_002',
        homeTeam: '서울고등학교',
        awayTeam: '대한고등학교',
        result: '2-2 무승부',
        timestamp: now.subtract(const Duration(days: 7)),
        status: ActivityStatus.completed,
      ),
      RecentActivity.training(
        trainingId: 'training_002',
        title: '팀 훈련',
        duration: 120,
        timestamp: now.subtract(const Duration(days: 8)),
        status: ActivityStatus.completed,
      ),
      RecentActivity.gameResult(
        gameId: 'game_003',
        homeTeam: '대한고등학교',
        awayTeam: '부산고등학교',
        result: '4-0 승리',
        timestamp: now.subtract(const Duration(days: 14)),
        status: ActivityStatus.completed,
      ),
    ];
  }

  // Get recent activities with fallback to mock data
  Future<List<RecentActivity>> getRecentActivitiesWithFallback({
    String? userId,
    int limit = 10,
    DateTime? since,
    List<ActivityType>? types,
  }) async {
    try {
      // Try to get real data first
      final activities = await getRecentActivities(
        userId: userId,
        limit: limit,
        since: since,
        types: types,
      );
      
      if (activities.isNotEmpty) {
        return activities;
      }
      
      // Fall back to mock data if no real data
      return generateMockActivities().take(limit).toList();
    } catch (e) {
      print('Falling back to mock data due to error: $e');
      return generateMockActivities().take(limit).toList();
    }
  }
}
