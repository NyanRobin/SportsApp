import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';
import 'firestore_service.dart';
import 'storage_service.dart';
import 'notification_service.dart';
import '../../core/network/api_service.dart';
import '../../core/network/auth_api_service.dart';
import '../../core/network/game_api_service.dart';
import '../../core/network/announcement_api_service.dart';
import '../../core/network/statistics_api_service.dart';
import '../../core/network/user_profile_api_service.dart';
import '../../core/network/recent_activity_api_service.dart';
import '../../core/services/realtime_service.dart';
import '../../core/services/local_storage_service.dart';
import '../../core/services/network_service.dart';
import '../../core/services/sync_service.dart';
import '../../core/providers/app_state.dart';

/// Service locator for Firebase services
class ServiceLocator {
  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._internal();
  
  // Factory constructor
  factory ServiceLocator() => _instance;
  
  // Services
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();
  final ApiService _apiService = ApiService();
  late final AuthApiService _authApiService;
  late final GameApiService _gameApiService;
  late final AnnouncementApiService _announcementApiService;
  late final StatisticsApiService _statisticsApiService;
  late final UserProfileApiService _userProfileApiService;
  late final RecentActivityApiService _recentActivityApiService;
  final RealtimeService _realtimeService = RealtimeService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final NetworkService _networkService = NetworkService();
  final SyncService _syncService = SyncService();
  final AppState _appState = AppState();
  
  bool _isInitialized = false;

  // Private constructor
  ServiceLocator._internal() {
    if (!_isInitialized) {
      _authApiService = AuthApiService(_apiService);
      _gameApiService = GameApiService(_apiService);
      _announcementApiService = AnnouncementApiService(_apiService);
      _statisticsApiService = StatisticsApiService(_apiService);
      _userProfileApiService = UserProfileApiService(_apiService);
      _recentActivityApiService = RecentActivityApiService(_apiService);
      _authService.initialize(_authApiService, _appState);
      _initializeServices();
      _isInitialized = true;
    }
  }

  Future<void> _initializeServices() async {
    await _localStorageService.initialize();
    await _networkService.initialize();
    await _syncService.initialize();
    await _notificationService.initialize();
  }
  
  // Getters for services
  AuthService get authService => _authService;
  FirestoreService get firestoreService => _firestoreService;
  StorageService get storageService => _storageService;
  NotificationService get notificationService => _notificationService;
  ApiService get apiService => _apiService;
  AuthApiService get authApiService => _authApiService;
  GameApiService get gameApiService => _gameApiService;
  AnnouncementApiService get announcementApiService => _announcementApiService;
  StatisticsApiService get statisticsApiService => _statisticsApiService;
  UserProfileApiService get userProfileApiService => _userProfileApiService;
  RecentActivityApiService get recentActivityApiService => _recentActivityApiService;
  RealtimeService get realtimeService => _realtimeService;
  LocalStorageService get localStorageService => _localStorageService;
  NetworkService get networkService => _networkService;
  SyncService get syncService => _syncService;
  AppState get appState => _appState;
  
  // Static getters for convenience
  static AuthService getAuthService(BuildContext context) {
    return Provider.of<AuthService>(context, listen: false);
  }
  
  static FirestoreService getFirestoreService(BuildContext context) {
    return Provider.of<FirestoreService>(context, listen: false);
  }
  
  static StorageService getStorageService(BuildContext context) {
    return Provider.of<StorageService>(context, listen: false);
  }
  
  static ApiService getApiService(BuildContext context) {
    return Provider.of<ApiService>(context, listen: false);
  }
  
  static AppState getAppState(BuildContext context) {
    return Provider.of<AppState>(context, listen: false);
  }
  
  static AuthApiService getAuthApiService(BuildContext context) {
    return Provider.of<AuthApiService>(context, listen: false);
  }
  
  static GameApiService getGameApiService(BuildContext context) {
    return Provider.of<GameApiService>(context, listen: false);
  }
  
  static AnnouncementApiService getAnnouncementApiService(BuildContext context) {
    return Provider.of<AnnouncementApiService>(context, listen: false);
  }
  
  static StatisticsApiService getStatisticsApiService(BuildContext context) {
    return Provider.of<StatisticsApiService>(context, listen: false);
  }

  static UserProfileApiService getUserProfileApiService(BuildContext context) {
    return Provider.of<ServiceLocator>(context, listen: false)._userProfileApiService;
  }

  static RecentActivityApiService getRecentActivityApiService(BuildContext context) {
    return Provider.of<ServiceLocator>(context, listen: false)._recentActivityApiService;
  }

  static RealtimeService getRealtimeService(BuildContext context) {
    return Provider.of<ServiceLocator>(context, listen: false)._realtimeService;
  }

  static LocalStorageService getLocalStorageService(BuildContext context) {
    return Provider.of<ServiceLocator>(context, listen: false)._localStorageService;
  }

  static NetworkService getNetworkService(BuildContext context) {
    return Provider.of<ServiceLocator>(context, listen: false)._networkService;
  }

  static SyncService getSyncService(BuildContext context) {
    return Provider.of<ServiceLocator>(context, listen: false)._syncService;
  }

  static NotificationService getNotificationService(BuildContext context) {
    return Provider.of<ServiceLocator>(context, listen: false)._notificationService;
  }
  
  // Provider list for MultiProvider
  List<SingleChildWidget> get providers => [
    Provider<ServiceLocator>.value(value: this),
    ChangeNotifierProvider<AuthService>.value(value: _authService),
    ChangeNotifierProvider<FirestoreService>.value(value: _firestoreService),
    ChangeNotifierProvider<StorageService>.value(value: _storageService),
    Provider<NotificationService>.value(value: _notificationService),
    Provider<ApiService>.value(value: _apiService),
    Provider<AuthApiService>.value(value: _authApiService),
    Provider<GameApiService>.value(value: _gameApiService),
    Provider<AnnouncementApiService>.value(value: _announcementApiService),
    Provider<StatisticsApiService>.value(value: _statisticsApiService),
    Provider<UserProfileApiService>.value(value: _userProfileApiService),
    Provider<RealtimeService>.value(value: _realtimeService),
    Provider<LocalStorageService>.value(value: _localStorageService),
    Provider<NetworkService>.value(value: _networkService),
    Provider<SyncService>.value(value: _syncService),
    ChangeNotifierProvider<AppState>.value(value: _appState),
  ];
}
