import 'package:flutter/cupertino.dart';

enum ActivityType {
  game,
  training,
  meeting,
  achievement,
  announcement,
  statistics,
  profile,
}

enum ActivityStatus {
  completed,
  ongoing,
  scheduled,
  cancelled,
}

class RecentActivity {
  final String id;
  final String title;
  final String subtitle;
  final ActivityType type;
  final ActivityStatus status;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final String? imageUrl;
  final String? actionUrl;

  RecentActivity({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.status,
    required this.timestamp,
    this.metadata,
    this.imageUrl,
    this.actionUrl,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    return RecentActivity(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      type: _parseActivityType(json['type']),
      status: _parseActivityStatus(json['status']),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      metadata: json['metadata'],
      imageUrl: json['image_url'],
      actionUrl: json['action_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'type': type.name,
      'status': status.name,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
      'image_url': imageUrl,
      'action_url': actionUrl,
    };
  }

  static ActivityType _parseActivityType(String? type) {
    switch (type?.toLowerCase()) {
      case 'game':
        return ActivityType.game;
      case 'training':
        return ActivityType.training;
      case 'meeting':
        return ActivityType.meeting;
      case 'achievement':
        return ActivityType.achievement;
      case 'announcement':
        return ActivityType.announcement;
      case 'statistics':
        return ActivityType.statistics;
      case 'profile':
        return ActivityType.profile;
      default:
        return ActivityType.game;
    }
  }

  static ActivityStatus _parseActivityStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return ActivityStatus.completed;
      case 'ongoing':
        return ActivityStatus.ongoing;
      case 'scheduled':
        return ActivityStatus.scheduled;
      case 'cancelled':
        return ActivityStatus.cancelled;
      default:
        return ActivityStatus.completed;
    }
  }

  // Helper getters for UI
  IconData get icon {
    switch (type) {
      case ActivityType.game:
        return CupertinoIcons.sportscourt_fill;
      case ActivityType.training:
        return CupertinoIcons.person_fill;
      case ActivityType.meeting:
        return CupertinoIcons.group_solid;
      case ActivityType.achievement:
        return CupertinoIcons.star_fill;
      case ActivityType.announcement:
        return CupertinoIcons.speaker_2_fill;
      case ActivityType.statistics:
        return CupertinoIcons.chart_bar_fill;
      case ActivityType.profile:
        return CupertinoIcons.person_circle_fill;
    }
  }

  Color get iconColor {
    switch (type) {
      case ActivityType.game:
        return const Color(0xFF007AFF); // System Blue
      case ActivityType.training:
        return const Color(0xFF30D158); // System Green
      case ActivityType.meeting:
        return const Color(0xFFFF9500); // System Orange
      case ActivityType.achievement:
        return const Color(0xFFFFD60A); // System Yellow
      case ActivityType.announcement:
        return const Color(0xFFFF3B30); // System Red
      case ActivityType.statistics:
        return const Color(0xFF5AC8FA); // System Cyan
      case ActivityType.profile:
        return const Color(0xFF8E8E93); // System Gray
    }
  }

  Color get statusColor {
    switch (status) {
      case ActivityStatus.completed:
        return const Color(0xFF30D158); // System Green
      case ActivityStatus.ongoing:
        return const Color(0xFFFF9500); // System Orange
      case ActivityStatus.scheduled:
        return const Color(0xFF007AFF); // System Blue
      case ActivityStatus.cancelled:
        return const Color(0xFF8E8E93); // System Gray
    }
  }

  String get statusText {
    switch (status) {
      case ActivityStatus.completed:
        return '완료';
      case ActivityStatus.ongoing:
        return '진행중';
      case ActivityStatus.scheduled:
        return '예정';
      case ActivityStatus.cancelled:
        return '취소됨';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  // Factory methods for common activities
  factory RecentActivity.gameResult({
    required String gameId,
    required String homeTeam,
    required String awayTeam,
    required String result,
    required DateTime timestamp,
    ActivityStatus status = ActivityStatus.completed,
  }) {
    return RecentActivity(
      id: 'game_$gameId',
      title: '$homeTeam vs $awayTeam',
      subtitle: '$result • ${status.name}',
      type: ActivityType.game,
      status: status,
      timestamp: timestamp,
      metadata: {
        'game_id': gameId,
        'home_team': homeTeam,
        'away_team': awayTeam,
        'result': result,
      },
      actionUrl: '/game-detail/$gameId',
    );
  }

  factory RecentActivity.training({
    required String trainingId,
    required String title,
    required int duration,
    required DateTime timestamp,
    ActivityStatus status = ActivityStatus.completed,
  }) {
    return RecentActivity(
      id: 'training_$trainingId',
      title: title,
      subtitle: '${duration}분 훈련 • ${status.name}',
      type: ActivityType.training,
      status: status,
      timestamp: timestamp,
      metadata: {
        'training_id': trainingId,
        'duration': duration,
      },
    );
  }

  factory RecentActivity.achievement({
    required String achievementId,
    required String title,
    required String description,
    required DateTime timestamp,
  }) {
    return RecentActivity(
      id: 'achievement_$achievementId',
      title: title,
      subtitle: description,
      type: ActivityType.achievement,
      status: ActivityStatus.completed,
      timestamp: timestamp,
      metadata: {
        'achievement_id': achievementId,
      },
    );
  }

  factory RecentActivity.announcement({
    required String announcementId,
    required String title,
    required String preview,
    required DateTime timestamp,
  }) {
    return RecentActivity(
      id: 'announcement_$announcementId',
      title: title,
      subtitle: preview,
      type: ActivityType.announcement,
      status: ActivityStatus.completed,
      timestamp: timestamp,
      metadata: {
        'announcement_id': announcementId,
      },
      actionUrl: '/announcements',
    );
  }

  factory RecentActivity.statisticsUpdate({
    required String updateId,
    required String title,
    required String description,
    required DateTime timestamp,
  }) {
    return RecentActivity(
      id: 'stats_$updateId',
      title: title,
      subtitle: description,
      type: ActivityType.statistics,
      status: ActivityStatus.completed,
      timestamp: timestamp,
      metadata: {
        'update_id': updateId,
      },
      actionUrl: '/statistics',
    );
  }

  factory RecentActivity.profileUpdate({
    required String updateId,
    required String title,
    required String description,
    required DateTime timestamp,
  }) {
    return RecentActivity(
      id: 'profile_$updateId',
      title: title,
      subtitle: description,
      type: ActivityType.profile,
      status: ActivityStatus.completed,
      timestamp: timestamp,
      metadata: {
        'update_id': updateId,
      },
      actionUrl: '/profile',
    );
  }

  factory RecentActivity.meeting({
    required String meetingId,
    required String title,
    required String description,
    required DateTime timestamp,
    ActivityStatus status = ActivityStatus.completed,
  }) {
    return RecentActivity(
      id: 'meeting_$meetingId',
      title: title,
      subtitle: description,
      type: ActivityType.meeting,
      status: status,
      timestamp: timestamp,
      metadata: {
        'meeting_id': meetingId,
      },
    );
  }
}




