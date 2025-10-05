import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type; // 'game', 'announcement', 'system', 'achievement'
  final Map<String, dynamic>? data;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String? actionUrl;
  final NotificationPriority priority;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.actionUrl,
    this.priority = NotificationPriority.normal,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    String? actionUrl,
    NotificationPriority? priority,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      priority: priority ?? this.priority,
    );
  }
}

enum NotificationPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

@JsonSerializable()
class AppNotificationSettings {
  final bool enabled;
  final bool gameUpdates;
  final bool announcements;
  final bool achievements;
  final bool systemMessages;
  final bool sound;
  final bool vibration;
  final String quietHoursStart; // "22:00"
  final String quietHoursEnd; // "08:00"

  const AppNotificationSettings({
    this.enabled = true,
    this.gameUpdates = true,
    this.announcements = true,
    this.achievements = true,
    this.systemMessages = true,
    this.sound = true,
    this.vibration = true,
    this.quietHoursStart = "22:00",
    this.quietHoursEnd = "08:00",
  });

  factory AppNotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppNotificationSettingsToJson(this);

  AppNotificationSettings copyWith({
    bool? enabled,
    bool? gameUpdates,
    bool? announcements,
    bool? achievements,
    bool? systemMessages,
    bool? sound,
    bool? vibration,
    String? quietHoursStart,
    String? quietHoursEnd,
  }) {
    return AppNotificationSettings(
      enabled: enabled ?? this.enabled,
      gameUpdates: gameUpdates ?? this.gameUpdates,
      announcements: announcements ?? this.announcements,
      achievements: achievements ?? this.achievements,
      systemMessages: systemMessages ?? this.systemMessages,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}

class NotificationAction {
  final String id;
  final String title;
  final String? icon;
  final bool requiresAuth;

  const NotificationAction({
    required this.id,
    required this.title,
    this.icon,
    this.requiresAuth = false,
  });
}
