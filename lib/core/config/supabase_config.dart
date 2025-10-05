import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class SupabaseConfig {
  // Supabase project configuration
  static const String supabaseUrl = 'https://ayqcfpldgsfntwlurkca.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF5cWNmcGxkZ3NmbnR3bHVya2NhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDYwNzEyNjQsImV4cCI6MjAyMTY0NzI2NH0.vK9AV8W6Ff1qVWZfUPVHEV2KLHK8F5N-oR5_CtgN7RM';
  
  // Edge Functions base URL
  static const String functionsUrl = '$supabaseUrl/functions/v1';
  
  // Storage bucket name
  static const String storageBucket = 'fieldsync-uploads';
  
  /// Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: true, // Set to false in production
    );
  }
  
  /// Get Supabase client instance
  static SupabaseClient get client => Supabase.instance.client;
  
  /// Get authenticated user
  static User? get currentUser => client.auth.currentUser;
  
  /// Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;
  
  /// Get auth headers for API calls
  static Map<String, String> getAuthHeaders() {
    final accessToken = client.auth.currentSession?.accessToken;
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'apikey': supabaseAnonKey,
    };
  }
  
  /// Edge Functions endpoints
  static const String usersFunction = '$functionsUrl/users';
  static const String gamesFunction = '$functionsUrl/games';
  static const String announcementsFunction = '$functionsUrl/announcements';
  static const String statisticsFunction = '$functionsUrl/statistics';
  static const String activitiesFunction = '$functionsUrl/activities';
  
  /// Database table names
  static const String userProfilesTable = 'user_profiles';
  static const String teamsTable = 'teams';
  static const String gamesTable = 'games';
  static const String gameEventsTable = 'game_events';
  static const String playerGameStatsTable = 'player_game_stats';
  static const String userStatisticsTable = 'user_statistics';
  static const String announcementsTable = 'announcements';
  static const String notificationsTable = 'notifications';
  static const String recentActivitiesTable = 'recent_activities';
  static const String teamStatisticsTable = 'team_statistics';
  static const String chatMessagesTable = 'chat_messages';
  
  /// Storage buckets
  static const String avatarsBucket = 'avatars';
  static const String teamLogosBucket = 'team-logos';
  static const String gamePhotosBucket = 'game-photos';
  static const String documentsBucket = 'documents';
  
  /// Real-time channels
  static const String gamesChannel = 'games';
  static const String chatChannel = 'chat';
  static const String notificationsChannel = 'notifications';
  static const String activitiesChannel = 'activities';
}

/// Supabase service extensions
extension SupabaseExtensions on SupabaseClient {
  /// Get user profile by user ID
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await from(SupabaseConfig.userProfilesTable)
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response;
  }
  
  /// Get current user profile
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = auth.currentUser;
    if (user == null) return null;
    
    return await getUserProfile(user.id);
  }
  
  /// Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await from(SupabaseConfig.userProfilesTable)
        .update(data)
        .eq('user_id', userId);
  }
  
  /// Get team games
  Future<List<Map<String, dynamic>>> getTeamGames(String teamId) async {
    final response = await from(SupabaseConfig.gamesTable)
        .select('*, home_team:teams!home_team_id(name), away_team:teams!away_team_id(name)')
        .or('home_team_id.eq.$teamId,away_team_id.eq.$teamId')
        .order('game_date', ascending: false);
    return response;
  }
  
  /// Get user notifications
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId, {int limit = 20}) async {
    final response = await from(SupabaseConfig.notificationsTable)
        .select()
        .eq('user_id', userId)
        .order('sent_at', ascending: false)
        .limit(limit);
    return response;
  }
  
  /// Subscribe to real-time updates
  RealtimeChannel subscribeToTable(String table, {
    String? filter,
    void Function(Map<String, dynamic>)? onInsert,
    void Function(Map<String, dynamic>)? onUpdate,
    void Function(Map<String, dynamic>)? onDelete,
  }) {
    final realtimeChannel = realtime.channel('${table}_changes');
    
    realtimeChannel.onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: table,
      callback: (payload) {
        switch (payload.eventType) {
          case PostgresChangeEvent.insert:
            if (onInsert != null) {
              onInsert(payload.newRecord);
            }
            break;
          case PostgresChangeEvent.update:
            if (onUpdate != null) {
              onUpdate(payload.newRecord);
            }
            break;
          case PostgresChangeEvent.delete:
            if (onDelete != null) {
              onDelete(payload.oldRecord);
            }
            break;
          case PostgresChangeEvent.all:
            // Handle all events case
            break;
        }
      },
    );
    
    realtimeChannel.subscribe();
    return realtimeChannel;
  }
}

/// Authentication helpers
class SupabaseAuth {
  static SupabaseClient get _client => SupabaseConfig.client;
  
  /// Sign in with email and password
  static Future<AuthResponse> signInWithEmailAndPassword(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  /// Sign up with email and password
  static Future<AuthResponse> signUpWithEmailAndPassword(String email, String password, {
    Map<String, dynamic>? metadata,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }
  
  /// Sign out
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  /// Reset password
  static Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }
  
  /// Update user metadata
  static Future<UserResponse> updateUser({
    String? email,
    String? password,
    Map<String, dynamic>? data,
  }) async {
    return await _client.auth.updateUser(
      UserAttributes(
        email: email,
        password: password,
        data: data,
      ),
    );
  }
}

/// Storage helpers
class SupabaseStorage {
  static SupabaseClient get _client => SupabaseConfig.client;
  
  /// Upload file to storage
  static Future<String> uploadFile(String bucket, String path, List<int> fileBytes, {
    String? contentType,
  }) async {
    final bytes = Uint8List.fromList(fileBytes);
    await _client.storage.from(bucket).uploadBinary(path, bytes);
    return _client.storage.from(bucket).getPublicUrl(path);
  }
  
  /// Delete file from storage
  static Future<void> deleteFile(String bucket, String path) async {
    await _client.storage.from(bucket).remove([path]);
  }
  
  /// Get public URL for file
  static String getPublicUrl(String bucket, String path) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }
  
  /// Create signed URL for private file
  static Future<String> createSignedUrl(String bucket, String path, int expiresIn) async {
    return await _client.storage.from(bucket).createSignedUrl(path, expiresIn);
  }
}
