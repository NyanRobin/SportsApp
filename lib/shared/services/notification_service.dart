import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Notification settings
  AppNotificationSettings _settings = const AppNotificationSettings();
  List<NotificationModel> _notifications = [];

  // Getters
  AppNotificationSettings get settings => _settings;
  List<NotificationModel> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Callback for notification taps
  Function(NotificationModel)? onNotificationTap;
  Function(String)? onFCMTokenReceived;

  Future<void> initialize() async {
    try {
      await _initializeLocalNotifications();
      await _initializeFirebaseMessaging();
      await _loadSettings();
      await _loadNotifications();
      print('NotificationService initialized successfully');
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  Future<void> _createNotificationChannels() async {
    const channels = [
      AndroidNotificationChannel(
        'game_updates',
        'Game Updates',
        description: 'Notifications about game results and schedules',
        importance: Importance.high,
        playSound: true,
      ),
      AndroidNotificationChannel(
        'announcements',
        'Announcements',
        description: 'Team and league announcements',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
      AndroidNotificationChannel(
        'achievements',
        'Achievements',
        description: 'Player achievements and milestones',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
      AndroidNotificationChannel(
        'system',
        'System Messages',
        description: 'App updates and system notifications',
        importance: Importance.low,
        playSound: false,
      ),
    ];

    for (final channel in channels) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Request permission
    await requestPermission();

    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
      onFCMTokenReceived?.call(token);
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((token) {
      print('FCM Token refreshed: $token');
      onFCMTokenReceived?.call(token);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Handle initial message if app was opened from notification
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  Future<void> requestPermission() async {
    try {
      // Request Firebase Messaging permission
      final messagingSettings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false,
      );

      print('Firebase Messaging permission: ${messagingSettings.authorizationStatus}');

      // Request system notification permission
      if (Platform.isAndroid) {
        final status = await Permission.notification.request();
        print('Android notification permission: $status');
      }

    } catch (e) {
      print('Error requesting notification permission: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Foreground message received: ${message.messageId}');
    
    final notification = _createNotificationFromRemoteMessage(message);
    await _saveNotification(notification);
    
    // Show local notification if enabled
    if (_settings.enabled && _shouldShowNotification(notification.type)) {
      await _showLocalNotification(notification);
    }
  }

  Future<void> _handleMessageTap(RemoteMessage message) async {
    print('Message tapped: ${message.messageId}');
    
    final notification = _createNotificationFromRemoteMessage(message);
    await markAsRead(notification.id);
    onNotificationTap?.call(notification);
  }

  NotificationModel _createNotificationFromRemoteMessage(RemoteMessage message) {
    return NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      type: message.data['type'] ?? 'system',
      data: message.data,
      timestamp: DateTime.now(),
      imageUrl: message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl,
      actionUrl: message.data['actionUrl'],
      priority: _parsePriority(message.data['priority']),
    );
  }

  NotificationPriority _parsePriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'low':
        return NotificationPriority.low;
      case 'high':
        return NotificationPriority.high;
      case 'urgent':
        return NotificationPriority.urgent;
      default:
        return NotificationPriority.normal;
    }
  }

  Future<void> _showLocalNotification(NotificationModel notification) async {
    if (!_isInQuietHours()) {
      final androidDetails = AndroidNotificationDetails(
        _getChannelId(notification.type),
        _getChannelName(notification.type),
        channelDescription: _getChannelDescription(notification.type),
        importance: _getImportance(notification.priority),
        priority: _getPriority(notification.priority),
        playSound: _settings.sound,
        enableVibration: _settings.vibration,
        styleInformation: notification.imageUrl != null 
            ? BigPictureStyleInformation(
                FilePathAndroidBitmap(notification.imageUrl!),
                largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
              )
            : const BigTextStyleInformation(''),
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        notification.id.hashCode,
        notification.title,
        notification.body,
        details,
        payload: jsonEncode(notification.toJson()),
      );
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final notificationData = jsonDecode(response.payload!);
        final notification = NotificationModel.fromJson(notificationData);
        markAsRead(notification.id);
        onNotificationTap?.call(notification);
      } catch (e) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  // Notification management
  Future<void> showLocalNotification({
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      data: data,
      timestamp: DateTime.now(),
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      priority: priority,
    );

    await _saveNotification(notification);
    
    if (_settings.enabled && _shouldShowNotification(type)) {
      await _showLocalNotification(notification);
    }
  }

  Future<void> scheduleNotification({
    required String title,
    required String body,
    required String type,
    required DateTime scheduledTime,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    // Note: This would require additional setup for scheduled notifications
    // For now, we'll just save it and show immediately if the time has passed
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      data: data,
      timestamp: scheduledTime,
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      priority: priority,
    );

    await _saveNotification(notification);
    
    if (scheduledTime.isBefore(DateTime.now()) || scheduledTime.isAtSameMomentAs(DateTime.now())) {
      if (_settings.enabled && _shouldShowNotification(type)) {
        await _showLocalNotification(notification);
      }
    }
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      await _saveNotifications();
    }
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    await _saveNotifications();
  }

  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    await _saveNotifications();
  }

  Future<void> clearAll() async {
    _notifications.clear();
    await _saveNotifications();
  }

  // Settings management
  Future<void> updateSettings(AppNotificationSettings newSettings) async {
    _settings = newSettings;
    await _saveSettings();
    
    // Update FCM topic subscriptions based on settings
    await _updateTopicSubscriptions();
  }

  Future<void> _updateTopicSubscriptions() async {
    const topics = ['game_updates', 'announcements', 'achievements', 'system_messages'];
    
    for (final topic in topics) {
      final shouldSubscribe = _shouldSubscribeToTopic(topic);
      try {
        if (shouldSubscribe) {
          await _firebaseMessaging.subscribeToTopic(topic);
          print('Subscribed to topic: $topic');
        } else {
          await _firebaseMessaging.unsubscribeFromTopic(topic);
          print('Unsubscribed from topic: $topic');
        }
      } catch (e) {
        print('Error updating subscription for topic $topic: $e');
      }
    }
  }

  bool _shouldSubscribeToTopic(String topic) {
    if (!_settings.enabled) return false;
    
    switch (topic) {
      case 'game_updates':
        return _settings.gameUpdates;
      case 'announcements':
        return _settings.announcements;
      case 'achievements':
        return _settings.achievements;
      case 'system_messages':
        return _settings.systemMessages;
      default:
        return false;
    }
  }

  bool _shouldShowNotification(String type) {
    if (!_settings.enabled) return false;
    
    switch (type) {
      case 'game':
        return _settings.gameUpdates;
      case 'announcement':
        return _settings.announcements;
      case 'achievement':
        return _settings.achievements;
      case 'system':
        return _settings.systemMessages;
      default:
        return true;
    }
  }

  bool _isInQuietHours() {
    final now = TimeOfDay.now();
    final start = _parseTimeOfDay(_settings.quietHoursStart);
    final end = _parseTimeOfDay(_settings.quietHoursEnd);
    
    if (start.hour < end.hour) {
      // Same day quiet hours (e.g., 14:00 - 18:00)
      return now.hour >= start.hour && now.hour < end.hour;
    } else {
      // Overnight quiet hours (e.g., 22:00 - 08:00)
      return now.hour >= start.hour || now.hour < end.hour;
    }
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  // Helper methods for notification details
  String _getChannelId(String type) {
    switch (type) {
      case 'game':
        return 'game_updates';
      case 'announcement':
        return 'announcements';
      case 'achievement':
        return 'achievements';
      default:
        return 'system';
    }
  }

  String _getChannelName(String type) {
    switch (type) {
      case 'game':
        return 'Game Updates';
      case 'announcement':
        return 'Announcements';
      case 'achievement':
        return 'Achievements';
      default:
        return 'System Messages';
    }
  }

  String _getChannelDescription(String type) {
    switch (type) {
      case 'game':
        return 'Notifications about game results and schedules';
      case 'announcement':
        return 'Team and league announcements';
      case 'achievement':
        return 'Player achievements and milestones';
      default:
        return 'App updates and system notifications';
    }
  }

  Importance _getImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.urgent:
        return Importance.max;
      default:
        return Importance.defaultImportance;
    }
  }

  Priority _getPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.urgent:
        return Priority.max;
      default:
        return Priority.defaultPriority;
    }
  }

  // Data persistence
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('notification_settings');
      if (settingsJson != null) {
        final data = jsonDecode(settingsJson);
        _settings = AppNotificationSettings.fromJson(data);
      }
    } catch (e) {
      print('Error loading notification settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_settings', jsonEncode(_settings.toJson()));
    } catch (e) {
      print('Error saving notification settings: $e');
    }
  }

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList('notifications') ?? [];
      _notifications = notificationsJson
          .map((json) => NotificationModel.fromJson(jsonDecode(json)))
          .toList();
      
      // Sort by timestamp (newest first)
      _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = _notifications
          .map((notification) => jsonEncode(notification.toJson()))
          .toList();
      await prefs.setStringList('notifications', notificationsJson);
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  Future<void> _saveNotification(NotificationModel notification) async {
    // Add to beginning of list (newest first)
    _notifications.insert(0, notification);
    
    // Keep only last 100 notifications to avoid storage bloat
    if (_notifications.length > 100) {
      _notifications = _notifications.take(100).toList();
    }
    
    await _saveNotifications();
  }

  // Test notifications
  Future<void> showTestNotification() async {
    await showLocalNotification(
      title: 'Test Notification',
      body: 'This is a test notification to verify the notification system is working.',
      type: 'system',
      priority: NotificationPriority.normal,
    );
  }

  Future<void> showGameNotification({
    required String homeTeam,
    required String awayTeam,
    required String result,
  }) async {
    await showLocalNotification(
      title: 'Game Result',
      body: '$homeTeam vs $awayTeam - $result',
      type: 'game',
      data: {
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'result': result,
      },
      priority: NotificationPriority.high,
    );
  }

  Future<void> showAchievementNotification({
    required String title,
    required String description,
  }) async {
    await showLocalNotification(
      title: 'Achievement Unlocked! 🏆',
      body: '$title - $description',
      type: 'achievement',
      data: {
        'achievement': title,
        'description': description,
      },
      priority: NotificationPriority.normal,
    );
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Background message received: ${message.messageId}');
  // Handle background message here if needed
}
