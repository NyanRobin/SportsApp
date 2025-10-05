import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final int id;
  final String title;
  final int homeTeamId;
  final int awayTeamId;
  final String homeTeamName;
  final String awayTeamName;
  final DateTime gameDate;
  final String venue;
  final String status;
  final int homeScore;
  final int awayScore;
  final DateTime createdAt;

  Game({
    required this.id,
    required this.title,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.gameDate,
    required this.venue,
    required this.status,
    required this.homeScore,
    required this.awayScore,
    required this.createdAt,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      homeTeamId: json['home_team_id'] ?? 0,
      awayTeamId: json['away_team_id'] ?? 0,
      homeTeamName: json['home_team_name'] ?? '',
      awayTeamName: json['away_team_name'] ?? '',
      gameDate: DateTime.parse(json['game_date'] ?? DateTime.now().toIso8601String()),
      venue: json['venue'] ?? '',
      status: json['status'] ?? 'scheduled',
      homeScore: json['home_score'] ?? 0,
      awayScore: json['away_score'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'home_team_id': homeTeamId,
      'away_team_id': awayTeamId,
      'home_team_name': homeTeamName,
      'away_team_name': awayTeamName,
      'game_date': gameDate.toIso8601String(),
      'venue': venue,
      'status': status,
      'home_score': homeScore,
      'away_score': awayScore,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // 게임 상태에 따른 색상 반환
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'completed':
        return '#4CAF50'; // Green
      case 'live':
        return '#F44336'; // Red
      case 'scheduled':
        return '#2196F3'; // Blue
      case 'cancelled':
        return '#9E9E9E'; // Grey
      default:
        return '#2196F3';
    }
  }

  // 게임 상태 텍스트
  String get statusDisplayText {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'live':
        return 'Live';
      case 'scheduled':
        return 'Scheduled';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Scheduled';
    }
  }

  // 스코어 텍스트
  String get scoreText {
    return '$homeScore - $awayScore';
  }

  // 게임 날짜 포맷팅
  String get formattedDate {
    return '${gameDate.year}-${gameDate.month.toString().padLeft(2, '0')}-${gameDate.day.toString().padLeft(2, '0')}';
  }

  // 게임 시간 포맷팅
  String get formattedTime {
    return '${gameDate.hour.toString().padLeft(2, '0')}:${gameDate.minute.toString().padLeft(2, '0')}';
  }

  // 게임이 오늘인지 확인
  bool get isToday {
    final now = DateTime.now();
    return gameDate.year == now.year &&
           gameDate.month == now.month &&
           gameDate.day == now.day;
  }

  // 게임이 과거인지 확인
  bool get isPast {
    return gameDate.isBefore(DateTime.now());
  }

  // 게임이 미래인지 확인
  bool get isFuture {
    return gameDate.isAfter(DateTime.now());
  }
}
