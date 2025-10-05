import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class RealtimeService {
  static final RealtimeService _instance = RealtimeService._internal();
  factory RealtimeService() => _instance;
  RealtimeService._internal();

  bool _isConnected = false;
  String? _userId;
  
  // Stream controllers for different events
  final StreamController<Map<String, dynamic>> _notificationController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _messageController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _gameScoreController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<bool> _connectionStatusController = 
      StreamController<bool>.broadcast();

  // Streams
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<Map<String, dynamic>> get gameScoreStream => _gameScoreController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  bool get isConnected => _isConnected;
  String? get userId => _userId;

  /// Realtime 서비스 초기화
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString(AppConstants.userDataKey);
      
      if (AppConstants.useSupabaseFunctions) {
        // For Supabase Edge Functions, disable real-time features for now
        // Real-time updates can be implemented later with Supabase Realtime
        _isConnected = true;
        _connectionStatusController.add(true);
        print('🔌 Realtime service initialized (Edge Functions mode - polling only)');
        
        // Set up periodic polling for updates instead of WebSocket
        _startPollingUpdates();
      } else {
        // For local development, just set as connected
        _isConnected = true;
        _connectionStatusController.add(true);
        print('🔌 Realtime service initialized for local development');
      }
    } catch (e) {
      print('❌ Realtime service error: $e');
      _isConnected = false;
      _connectionStatusController.add(false);
    }
  }

  /// 주기적 업데이트 체크 (WebSocket 대체)
  void _startPollingUpdates() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_isConnected) {
        print('🔄 Checking for updates...');
        // This can be expanded to check for game score updates, new announcements, etc.
        // For now, just keep the connection alive
      }
    });
  }

  /// 연결 해제
  Future<void> disconnect() async {
    try {
      _isConnected = false;
      _connectionStatusController.add(false);
      print('🔌 Realtime service disconnected');
    } catch (e) {
      print('❌ Error disconnecting realtime service: $e');
    }
  }

  /// 재연결 시도
  Future<void> reconnect() async {
    await disconnect();
    await initialize();
  }

  /// 사용자 인증 및 연결
  Future<void> authenticateAndConnect(String userId, String token) async {
    try {
      _userId = userId;
      
      // Save user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userDataKey, userId);
      await prefs.setString(AppConstants.authTokenKey, token);
      
      if (!_isConnected) {
        await initialize();
      }
    } catch (e) {
      print('❌ Authentication error: $e');
    }
  }

  /// 메시지 전송 (Edge Functions 사용 시 비활성화)
  void sendMessage(String event, Map<String, dynamic> data) {
    if (AppConstants.useSupabaseFunctions) {
      print('📤 Message sending disabled in Edge Functions mode');
      return;
    }
    
    // Local development only
    print('📤 Local message: $event - $data');
  }

  /// 게임 스코어 업데이트 전송
  void sendGameScoreUpdate(String gameId, Map<String, dynamic> scoreData) {
    sendMessage('game_score_update', {
      'gameId': gameId,
      'scoreData': scoreData,
      'userId': _userId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// 채팅 메시지 전송
  void sendChatMessage(String message, {String? gameId}) {
    sendMessage('chat_message', {
      'message': message,
      'userId': _userId,
      'gameId': gameId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// 알림 전송
  void sendNotification(String title, String message, {String? targetUserId}) {
    sendMessage('notification', {
      'title': title,
      'message': message,
      'targetUserId': targetUserId,
      'fromUserId': _userId,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// 사용자 상태 업데이트
  void updateUserStatus(String status) {
    sendMessage('user_status', {
      'userId': _userId,
      'status': status,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// 수동 알림 추가 (테스트용)
  void addTestNotification(String message) {
    _notificationController.add({
      'type': 'test_notification',
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// 리소스 정리
  void dispose() {
    _notificationController.close();
    _messageController.close();
    _gameScoreController.close();
    _connectionStatusController.close();
    disconnect();
  }
}

// 실시간 메시지 모델
class RealtimeMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final String type;
  final String room;
  final DateTime timestamp;

  RealtimeMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.type,
    required this.room,
    required this.timestamp,
  });

  factory RealtimeMessage.fromJson(Map<String, dynamic> json) {
    return RealtimeMessage(
      id: json['id'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'chat',
      room: json['room'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'type': type,
      'room': room,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// 실시간 알림 모델
class RealtimeNotification {
  final String id;
  final String title;
  final String message;
  final String type;
  final Map<String, dynamic>? data;
  final DateTime timestamp;

  RealtimeNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.data,
    required this.timestamp,
  });

  factory RealtimeNotification.fromJson(Map<String, dynamic> json) {
    return RealtimeNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'data': data,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// 게임 스코어 업데이트 모델
class GameScoreUpdate {
  final String gameId;
  final int homeScore;
  final int awayScore;
  final String? scorer;
  final String? assist;
  final DateTime timestamp;

  GameScoreUpdate({
    required this.gameId,
    required this.homeScore,
    required this.awayScore,
    this.scorer,
    this.assist,
    required this.timestamp,
  });

  factory GameScoreUpdate.fromJson(Map<String, dynamic> json) {
    return GameScoreUpdate(
      gameId: json['gameId'] ?? '',
      homeScore: json['homeScore'] ?? 0,
      awayScore: json['awayScore'] ?? 0,
      scorer: json['scorer'],
      assist: json['assist'],
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'scorer': scorer,
      'assist': assist,
      'timestamp': timestamp.toIso8601String(),
    };
  }
} 