import 'dart:async';
import 'local_storage_service.dart';
import 'network_service.dart';
import '../network/api_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final LocalStorageService _localStorage = LocalStorageService();
  final NetworkService _networkService = NetworkService();
  late final ApiService _apiService;

  StreamController<bool>? _syncStatusController;
  bool _isSyncing = false;

  Stream<bool> get syncStatusStream => _syncStatusController?.stream ?? Stream.value(false);
  bool get isSyncing => _isSyncing;

  Future<void> initialize() async {
    _apiService = ApiService();
    _syncStatusController = StreamController<bool>.broadcast();
    
    // Listen to network status changes
    _networkService.networkStatusStream.listen((isOnline) {
      if (isOnline) {
        _syncOfflineQueue();
      }
    });
  }

  Future<void> _syncOfflineQueue() async {
    if (_isSyncing) return;
    
    _isSyncing = true;
    _syncStatusController?.add(true);
    
    try {
      final queue = _localStorage.getOfflineQueue();
      if (queue.isEmpty) {
        print('📋 No offline operations to sync');
        return;
      }

      print('🔄 Syncing ${queue.length} offline operations...');
      
      for (final operation in queue) {
        await _processOfflineOperation(operation);
      }
      
      // Clear the queue after successful sync
      await _localStorage.clearOfflineQueue();
      print('✅ Offline sync completed successfully');
      
    } catch (e) {
      print('❌ Offline sync failed: $e');
    } finally {
      _isSyncing = false;
      _syncStatusController?.add(false);
    }
  }

  Future<void> _processOfflineOperation(Map<String, dynamic> operation) async {
    final operationType = operation['operation'] as String;
    final data = operation['data'] as Map<String, dynamic>;
    
    try {
      switch (operationType) {
        case 'create_game':
          await _apiService.post('/games', data: data);
          break;
        case 'update_game':
          await _apiService.put('/games/${data['id']}', data: data);
          break;
        case 'delete_game':
          await _apiService.delete('/games/${data['id']}');
          break;
        case 'create_announcement':
          await _apiService.post('/announcements', data: data);
          break;
        case 'update_announcement':
          await _apiService.put('/announcements/${data['id']}', data: data);
          break;
        case 'delete_announcement':
          await _apiService.delete('/announcements/${data['id']}');
          break;
        case 'update_user_profile':
          await _apiService.put('/users/profile', data: data);
          break;
        default:
          print('⚠️ Unknown offline operation: $operationType');
      }
    } catch (e) {
      print('❌ Failed to process offline operation $operationType: $e');
      // Keep the operation in queue for retry
      rethrow;
    }
  }

  // Add operations to offline queue
  Future<void> addOfflineOperation(String operation, Map<String, dynamic> data) async {
    await _localStorage.addToOfflineQueue(operation, data);
    print('📝 Added offline operation: $operation');
  }

  // Manual sync trigger
  Future<void> syncNow() async {
    if (_networkService.isOnline) {
      await _syncOfflineQueue();
    } else {
      print('📴 Cannot sync: offline');
    }
  }

  // Cache management
  Future<void> refreshCache() async {
    if (!_networkService.isOnline) {
      print('📴 Cannot refresh cache: offline');
      return;
    }

    try {
      // Refresh games cache
      final gamesResponse = await _apiService.get('/games');
      if (gamesResponse['games'] != null) {
        await _localStorage.storeGames(gamesResponse['games']);
      }
      
      // Refresh announcements cache
      final announcementsResponse = await _apiService.get('/announcements');
      if (announcementsResponse['announcements'] != null) {
        await _localStorage.storeAnnouncements(announcementsResponse['announcements']);
      }
      
      // Refresh user profile cache
      final profileResponse = await _apiService.get('/users/profile');
      if (profileResponse['profile'] != null) {
        await _localStorage.storeUserProfile(profileResponse['profile']);
      }
      
      print('🔄 Cache refreshed successfully');
    } catch (e) {
      print('❌ Cache refresh failed: $e');
    }
  }

  // Get cached data with fallback
  Future<List<Map<String, dynamic>>> getGamesWithCache() async {
    if (_networkService.isOnline) {
      try {
        final response = await _apiService.get('/games');
        if (response['games'] != null) {
          await _localStorage.storeGames(response['games']);
          return response['games'];
        }
      } catch (e) {
        print('⚠️ Failed to fetch games from API, using cache: $e');
      }
    }
    
    final cachedGames = _localStorage.getCachedGames();
    if (cachedGames != null && _localStorage.isCacheValid(_localStorage.getGamesCacheTimestamp())) {
      return cachedGames;
    }
    
    return [];
  }

  Future<List<Map<String, dynamic>>> getAnnouncementsWithCache() async {
    if (_networkService.isOnline) {
      try {
        final response = await _apiService.get('/announcements');
        if (response['announcements'] != null) {
          await _localStorage.storeAnnouncements(response['announcements']);
          return response['announcements'];
        }
      } catch (e) {
        print('⚠️ Failed to fetch announcements from API, using cache: $e');
      }
    }
    
    final cachedAnnouncements = _localStorage.getCachedAnnouncements();
    if (cachedAnnouncements != null && _localStorage.isCacheValid(_localStorage.getAnnouncementsCacheTimestamp())) {
      return cachedAnnouncements;
    }
    
    return [];
  }

  Future<Map<String, dynamic>?> getUserProfileWithCache() async {
    if (_networkService.isOnline) {
      try {
        final response = await _apiService.get('/users/profile');
        if (response['profile'] != null) {
          await _localStorage.storeUserProfile(response['profile']);
          return response['profile'];
        }
      } catch (e) {
        print('⚠️ Failed to fetch user profile from API, using cache: $e');
      }
    }
    
    final cachedProfile = _localStorage.getCachedUserProfile();
    if (cachedProfile != null && _localStorage.isCacheValid(_localStorage.getProfileCacheTimestamp())) {
      return cachedProfile;
    }
    
    return null;
  }

  void dispose() {
    _syncStatusController?.close();
  }
} 