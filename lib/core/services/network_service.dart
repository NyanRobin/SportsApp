import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'local_storage_service.dart';
import '../constants/app_constants.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final LocalStorageService _localStorage = LocalStorageService();
  final Connectivity _connectivity = Connectivity();
  final Dio _dio = Dio();
  
  StreamController<bool>? _networkStatusController;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  bool _isOnline = true;
  Timer? _pingTimer;

  Stream<bool> get networkStatusStream => _networkStatusController?.stream ?? Stream.value(true);
  bool get isOnline => _isOnline;

  Future<void> initialize() async {
    _networkStatusController = StreamController<bool>.broadcast();
    
    // Check initial connectivity
    await _checkInitialConnectivity();
    
    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
      onError: (error) => print('Connectivity error: $error'),
    );
    
    // Start periodic ping to check actual internet connectivity
    _startPeriodicPing();
  }

  Future<void> _checkInitialConnectivity() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    await _updateNetworkStatus(connectivityResult != ConnectivityResult.none);
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    final isConnected = results.isNotEmpty && results.first != ConnectivityResult.none;
    await _updateNetworkStatus(isConnected);
  }

  Future<void> _updateNetworkStatus(bool isConnected) async {
    if (_isOnline != isConnected) {
      _isOnline = isConnected;
      await _localStorage.setNetworkStatus(isConnected);
      _networkStatusController?.add(isConnected);
      
      if (isConnected) {
        print('🌐 Network connected');
        // Trigger sync when coming back online
        _triggerOfflineSync();
      } else {
        print('📴 Network disconnected');
      }
    }
  }

  Future<void> _startPeriodicPing() async {
    // Skip ping in production/Edge Functions mode to avoid CORS issues
    if (AppConstants.useSupabaseFunctions) {
      print('🔌 Network ping disabled in Edge Functions mode');
      return;
    }
    
    _pingTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_isOnline) {
        await _pingServer();
      }
    });
  }

  Future<void> _pingServer() async {
    try {
      // Use HTTP request instead of InternetAddress.lookup for web compatibility
      final response = await _dio.get(
        'https://www.google.com',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          validateStatus: (status) => true, // Accept any status code
        ),
      );
      
      // If we get any response (even error), internet is available
      if (!_isOnline) {
        await _updateNetworkStatus(true);
      }
    } catch (e) {
      // No internet connection
      if (_isOnline) {
        await _updateNetworkStatus(false);
      }
      print('📡 Ping failed: $e');
    }
  }

  Future<void> _triggerOfflineSync() async {
    // This will be implemented to sync offline queue
    print('🔄 Triggering offline sync...');
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await _dio.get(
        'https://www.google.com',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          validateStatus: (status) => true, // Accept any status code
        ),
      );
      return result.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkServerConnection() async {
    try {
      final client = Dio(); // Changed from HttpClient to Dio for consistency
      final response = await client.get(
        'http://localhost:3000/health',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          validateStatus: (status) => true, // Accept any status code
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _pingTimer?.cancel();
    _networkStatusController?.close();
  }
} 