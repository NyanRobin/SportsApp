import '../../shared/models/user_profile_model.dart';
import '../../shared/models/comprehensive_profile_model.dart';
import 'api_service.dart';

class UserProfileApiService {
  final ApiService _apiService;

  UserProfileApiService(this._apiService);

  /// 사용자 프로필 조회
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _apiService.get('/users/$userId/profile');
      return UserProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// 현재 로그인한 사용자의 프로필 조회
  Future<UserProfile> getCurrentUserProfile() async {
    try {
      final response = await _apiService.get('/users/profile');
      return UserProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to get current user profile: $e');
    }
  }

  /// 사용자 프로필 업데이트
  Future<UserProfile> updateUserProfile(String userId, UserProfileUpdate updateData) async {
    try {
      final response = await _apiService.put('/users/$userId/profile', data: updateData.toJson());
      return UserProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// 현재 사용자 프로필 업데이트
  Future<UserProfile> updateCurrentUserProfile(UserProfileUpdate updateData) async {
    try {
      final response = await _apiService.put('/users/profile', data: updateData.toJson());
      return UserProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to update current user profile: $e');
    }
  }

  /// 프로필 이미지 업로드
  Future<String> uploadProfileImage(String filePath) async {
    try {
      final response = await _apiService.uploadFile('/users/profile/image', filePath, 'image');
      return response['image_url'];
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  /// 프로필 이미지 삭제
  Future<void> deleteProfileImage() async {
    try {
      await _apiService.delete('/users/profile/image');
    } catch (e) {
      throw Exception('Failed to delete profile image: $e');
    }
  }

  /// 사용자 목록 조회 (관리자용)
  Future<List<UserProfile>> getAllUsers({
    int? page,
    int? limit,
    String? search,
    String? role,
    String? department,
    bool? isActive,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;
      if (search != null) queryParams['search'] = search;
      if (role != null) queryParams['role'] = role;
      if (department != null) queryParams['department'] = department;
      if (isActive != null) queryParams['is_active'] = isActive;

      final response = await _apiService.get('/users', queryParameters: queryParams);
      final List<dynamic> usersJson = response['users'];
      return usersJson.map((json) => UserProfile.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get all users: $e');
    }
  }

  /// 사용자 역할 변경 (관리자용)
  Future<UserProfile> updateUserRole(String userId, String role) async {
    try {
      final response = await _apiService.put('/users/$userId/role', data: {'role': role});
      return UserProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to update user role: $e');
    }
  }

  /// 사용자 활성화/비활성화 (관리자용)
  Future<UserProfile> updateUserStatus(String userId, bool isActive) async {
    try {
      final response = await _apiService.put('/users/$userId/status', data: {'is_active': isActive});
      return UserProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to update user status: $e');
    }
  }

  /// 사용자 삭제 (관리자용)
  Future<void> deleteUser(String userId) async {
    try {
      await _apiService.delete('/users/$userId');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  /// 팀 멤버 조회
  Future<List<UserProfile>> getTeamMembers(String teamId) async {
    try {
      final response = await _apiService.get('/teams/$teamId/members');
      final List<dynamic> membersJson = response['members'];
      return membersJson.map((json) => UserProfile.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get team members: $e');
    }
  }

  /// 팀에 사용자 추가
  Future<void> addUserToTeam(String userId, String teamId) async {
    try {
      await _apiService.post('/teams/$teamId/members', data: {'user_id': userId});
    } catch (e) {
      throw Exception('Failed to add user to team: $e');
    }
  }

  /// 팀에서 사용자 제거
  Future<void> removeUserFromTeam(String userId, String teamId) async {
    try {
      await _apiService.delete('/teams/$teamId/members/$userId');
    } catch (e) {
      throw Exception('Failed to remove user from team: $e');
    }
  }

  /// 사용자 권한 조회
  Future<List<String>> getUserPermissions(String userId) async {
    try {
      final response = await _apiService.get('/users/$userId/permissions');
      final List<dynamic> permissionsJson = response['permissions'];
      return permissionsJson.map((json) => json.toString()).toList();
    } catch (e) {
      throw Exception('Failed to get user permissions: $e');
    }
  }

  /// 사용자 권한 업데이트 (관리자용)
  Future<List<String>> updateUserPermissions(String userId, List<String> permissions) async {
    try {
      final response = await _apiService.put('/users/$userId/permissions', 
          data: {'permissions': permissions});
      final List<dynamic> permissionsJson = response['permissions'];
      return permissionsJson.map((json) => json.toString()).toList();
    } catch (e) {
      throw Exception('Failed to update user permissions: $e');
    }
  }

  // 새로운 포괄적 프로필 API들

  /// 플레이어 프로필 상세 조회
  Future<PlayerProfile> getPlayerProfile(String playerId) async {
    try {
      final response = await _apiService.get('/players/$playerId/profile');
      return PlayerProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to get player profile: $e');
    }
  }

  /// 현재 플레이어 프로필 조회
  Future<PlayerProfile> getCurrentPlayerProfile() async {
    try {
      final response = await _apiService.get('/players/profile');
      return PlayerProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to get current player profile: $e');
    }
  }

  /// 플레이어 프로필 업데이트
  Future<PlayerProfile> updatePlayerProfile(String playerId, ProfileUpdateRequest updateData) async {
    try {
      final response = await _apiService.put('/players/$playerId/profile', 
          data: updateData.toJson());
      return PlayerProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to update player profile: $e');
    }
  }

  /// 현재 플레이어 프로필 업데이트
  Future<PlayerProfile> updateCurrentPlayerProfile(ProfileUpdateRequest updateData) async {
    try {
      final response = await _apiService.put('/players/profile', 
          data: updateData.toJson());
      return PlayerProfile.fromJson(response['profile']);
    } catch (e) {
      throw Exception('Failed to update current player profile: $e');
    }
  }

  /// 플레이어 게임 기록 조회
  Future<List<GameHistory>> getPlayerGameHistory(String playerId, {
    String? season,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (season != null) queryParams['season'] = season;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await _apiService.get('/players/$playerId/games', 
          queryParameters: queryParams);
      
      final List<dynamic> gamesJson = response['games'];
      return gamesJson.map((json) => GameHistory.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get player game history: $e');
    }
  }

  /// 플레이어 업적 조회
  Future<List<Achievement>> getPlayerAchievements(String playerId, {
    String? category,
    bool? isPublic,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;
      if (isPublic != null) queryParams['is_public'] = isPublic;

      final response = await _apiService.get('/players/$playerId/achievements', 
          queryParameters: queryParams);
      
      final List<dynamic> achievementsJson = response['achievements'];
      return achievementsJson.map((json) => Achievement.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get player achievements: $e');
    }
  }

  /// 플레이어 검색
  Future<List<PlayerProfile>> searchPlayers(ProfileSearchFilter filter) async {
    try {
      final response = await _apiService.get('/players/search', 
          queryParameters: filter.toQueryParams());
      
      final List<dynamic> playersJson = response['players'];
      return playersJson.map((json) => PlayerProfile.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search players: $e');
    }
  }

  /// 플레이어 순위 조회
  Future<List<PlayerProfile>> getPlayerRankings({
    String category = 'goals', // goals, assists, rating, etc.
    String? season,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'category': category,
        'limit': limit,
      };
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/players/rankings', 
          queryParameters: queryParams);
      
      final List<dynamic> playersJson = response['players'];
      return playersJson.map((json) => PlayerProfile.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get player rankings: $e');
    }
  }

  /// 업적 추가 (시스템/관리자용)
  Future<Achievement> addAchievement(String playerId, Achievement achievement) async {
    try {
      final response = await _apiService.post('/players/$playerId/achievements', 
          data: achievement.toJson());
      return Achievement.fromJson(response['achievement']);
    } catch (e) {
      throw Exception('Failed to add achievement: $e');
    }
  }

  /// 게임 기록 추가
  Future<GameHistory> addGameHistory(String playerId, GameHistory gameHistory) async {
    try {
      final response = await _apiService.post('/players/$playerId/games', 
          data: gameHistory.toJson());
      return GameHistory.fromJson(response['game']);
    } catch (e) {
      throw Exception('Failed to add game history: $e');
    }
  }

  /// 플레이어 통계 업데이트
  Future<PlayerStats> updatePlayerStats(String playerId, PlayerStats stats) async {
    try {
      final response = await _apiService.put('/players/$playerId/stats', 
          data: stats.toJson());
      return PlayerStats.fromJson(response['stats']);
    } catch (e) {
      throw Exception('Failed to update player stats: $e');
    }
  }

  /// 팀 멤버 상세 조회
  Future<List<TeamMember>> getTeamMembersDetailed(String teamId) async {
    try {
      final response = await _apiService.get('/teams/$teamId/members/detailed');
      final List<dynamic> membersJson = response['members'];
      return membersJson.map((json) => TeamMember.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get detailed team members: $e');
    }
  }

  /// 플레이어 비교
  Future<Map<String, dynamic>> comparePlayers(List<String> playerIds, {
    String? season,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'player_ids': playerIds.join(','),
      };
      if (season != null) queryParams['season'] = season;

      final response = await _apiService.get('/players/compare', 
          queryParameters: queryParams);
      return response;
    } catch (e) {
      throw Exception('Failed to compare players: $e');
    }
  }

  /// 플레이어 성과 분석
  Future<Map<String, dynamic>> getPlayerAnalytics(String playerId, {
    String? season,
    String? period, // month, quarter, season
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (season != null) queryParams['season'] = season;
      if (period != null) queryParams['period'] = period;

      final response = await _apiService.get('/players/$playerId/analytics', 
          queryParameters: queryParams);
      return response;
    } catch (e) {
      throw Exception('Failed to get player analytics: $e');
    }
  }

  /// 비밀번호 변경
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      await _apiService.put('/users/password', data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      });
    } catch (e) {
      throw Exception('Failed to change password: $e');
    }
  }

  /// 계정 삭제 요청
  Future<void> requestAccountDeletion(String reason) async {
    try {
      await _apiService.post('/users/deletion-request', data: {'reason': reason});
    } catch (e) {
      throw Exception('Failed to request account deletion: $e');
    }
  }
} 