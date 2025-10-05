class GameHighlight {
  final int id;
  final int gameId;
  final String title;
  final String description;
  final int minute;
  final String highlightType;
  final String? playerName;
  final String? teamName;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int duration; // in seconds
  final DateTime createdAt;

  GameHighlight({
    required this.id,
    required this.gameId,
    required this.title,
    required this.description,
    required this.minute,
    required this.highlightType,
    this.playerName,
    this.teamName,
    this.videoUrl,
    this.thumbnailUrl,
    this.duration = 0,
    required this.createdAt,
  });

  factory GameHighlight.fromJson(Map<String, dynamic> json) {
    return GameHighlight(
      id: json['id'] ?? 0,
      gameId: json['game_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      minute: json['minute'] ?? 0,
      highlightType: json['highlight_type'] ?? '',
      playerName: json['player_name'],
      teamName: json['team_name'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      duration: json['duration'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'title': title,
      'description': description,
      'minute': minute,
      'highlight_type': highlightType,
      'player_name': playerName,
      'team_name': teamName,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'duration': duration,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // 하이라이트 타입에 따른 아이콘
  String get typeIcon {
    switch (highlightType.toLowerCase()) {
      case 'goal':
        return 'goal';
      case 'save':
        return 'save';
      case 'skill':
        return 'skill';
      case 'tackle':
        return 'tackle';
      case 'assist':
        return 'assist';
      case 'miss':
        return 'miss';
      case 'foul':
        return 'foul';
      case 'card':
        return 'card';
      default:
        return 'highlight';
    }
  }

  // 하이라이트 타입에 따른 색상
  String get typeColor {
    switch (highlightType.toLowerCase()) {
      case 'goal':
        return '#4CAF50'; // Green
      case 'save':
        return '#2196F3'; // Blue
      case 'skill':
        return '#9C27B0'; // Purple
      case 'tackle':
        return '#FF9800'; // Orange
      case 'assist':
        return '#00BCD4'; // Cyan
      case 'miss':
        return '#F44336'; // Red
      case 'foul':
        return '#795548'; // Brown
      case 'card':
        return '#FFC107'; // Amber
      default:
        return '#607D8B'; // Blue Grey
    }
  }

  // 시간 표시 포맷
  String get displayMinute {
    if (minute == 0) return "1'";
    if (minute == 45) return "45+2'";
    if (minute >= 90) return "90+${minute - 90}'";
    return "$minute'";
  }

  // 지속 시간 포맷 (예: 1:23)
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // 하이라이트 타입 표시명
  String get typeDisplayName {
    switch (highlightType.toLowerCase()) {
      case 'goal':
        return 'Goal';
      case 'save':
        return 'Great Save';
      case 'skill':
        return 'Skill Move';
      case 'tackle':
        return 'Tackle';
      case 'assist':
        return 'Assist';
      case 'miss':
        return 'Missed Chance';
      case 'foul':
        return 'Foul';
      case 'card':
        return 'Card';
      default:
        return 'Highlight';
    }
  }
}



