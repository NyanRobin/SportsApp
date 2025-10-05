class GameTimelineEvent {
  final int id;
  final int gameId;
  final String eventType;
  final int minute;
  final String? playerName;
  final String? teamName;
  final String? description;
  final String? additionalInfo;
  final DateTime createdAt;

  GameTimelineEvent({
    required this.id,
    required this.gameId,
    required this.eventType,
    required this.minute,
    this.playerName,
    this.teamName,
    this.description,
    this.additionalInfo,
    required this.createdAt,
  });

  factory GameTimelineEvent.fromJson(Map<String, dynamic> json) {
    return GameTimelineEvent(
      id: json['id'] ?? 0,
      gameId: json['game_id'] ?? 0,
      eventType: json['event_type'] ?? '',
      minute: json['minute'] ?? 0,
      playerName: json['player_name'],
      teamName: json['team_name'],
      description: json['description'],
      additionalInfo: json['additional_info'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'event_type': eventType,
      'minute': minute,
      'player_name': playerName,
      'team_name': teamName,
      'description': description,
      'additional_info': additionalInfo,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // 이벤트 타입에 따른 아이콘 반환
  String get eventIcon {
    switch (eventType.toLowerCase()) {
      case 'goal':
        return 'goal';
      case 'yellow_card':
        return 'yellow_card';
      case 'red_card':
        return 'red_card';
      case 'substitution':
        return 'substitution';
      case 'kick_off':
        return 'kick_off';
      case 'half_time':
        return 'half_time';
      case 'full_time':
        return 'full_time';
      case 'corner':
        return 'corner';
      case 'offside':
        return 'offside';
      case 'foul':
        return 'foul';
      default:
        return 'default';
    }
  }

  // 이벤트 타입에 따른 색상 반환
  String get eventColor {
    switch (eventType.toLowerCase()) {
      case 'goal':
        return '#4CAF50'; // Green
      case 'yellow_card':
        return '#FFC107'; // Amber
      case 'red_card':
        return '#F44336'; // Red
      case 'substitution':
        return '#2196F3'; // Blue
      case 'kick_off':
      case 'half_time':
      case 'full_time':
        return '#9E9E9E'; // Grey
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
}



