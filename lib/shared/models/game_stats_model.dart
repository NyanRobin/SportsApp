class GameStats {
  final int gameId;
  final TeamStats homeTeam;
  final TeamStats awayTeam;
  final DateTime updatedAt;

  GameStats({
    required this.gameId,
    required this.homeTeam,
    required this.awayTeam,
    required this.updatedAt,
  });

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      gameId: json['game_id'] ?? 0,
      homeTeam: TeamStats.fromJson(json['home_team'] ?? {}),
      awayTeam: TeamStats.fromJson(json['away_team'] ?? {}),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_id': gameId,
      'home_team': homeTeam.toJson(),
      'away_team': awayTeam.toJson(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class TeamStats {
  final String teamName;
  final int possession;
  final int shots;
  final int shotsOnTarget;
  final int corners;
  final int fouls;
  final int yellowCards;
  final int redCards;
  final int offsides;
  final int saves;
  final int passes;
  final int passAccuracy;
  final double distanceCovered;

  TeamStats({
    required this.teamName,
    this.possession = 0,
    this.shots = 0,
    this.shotsOnTarget = 0,
    this.corners = 0,
    this.fouls = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.offsides = 0,
    this.saves = 0,
    this.passes = 0,
    this.passAccuracy = 0,
    this.distanceCovered = 0.0,
  });

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
      teamName: json['team_name'] ?? '',
      possession: json['possession'] ?? 0,
      shots: json['shots'] ?? 0,
      shotsOnTarget: json['shots_on_target'] ?? 0,
      corners: json['corners'] ?? 0,
      fouls: json['fouls'] ?? 0,
      yellowCards: json['yellow_cards'] ?? 0,
      redCards: json['red_cards'] ?? 0,
      offsides: json['offsides'] ?? 0,
      saves: json['saves'] ?? 0,
      passes: json['passes'] ?? 0,
      passAccuracy: json['pass_accuracy'] ?? 0,
      distanceCovered: (json['distance_covered'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_name': teamName,
      'possession': possession,
      'shots': shots,
      'shots_on_target': shotsOnTarget,
      'corners': corners,
      'fouls': fouls,
      'yellow_cards': yellowCards,
      'red_cards': redCards,
      'offsides': offsides,
      'saves': saves,
      'passes': passes,
      'pass_accuracy': passAccuracy,
      'distance_covered': distanceCovered,
    };
  }
}

class StatItem {
  final String label;
  final dynamic homeValue;
  final dynamic awayValue;
  final String? unit;
  final bool isPercentage;

  StatItem({
    required this.label,
    required this.homeValue,
    required this.awayValue,
    this.unit,
    this.isPercentage = false,
  });

  String get formattedHomeValue {
    if (isPercentage) {
      return '$homeValue%';
    }
    if (unit != null) {
      return '$homeValue $unit';
    }
    return homeValue.toString();
  }

  String get formattedAwayValue {
    if (isPercentage) {
      return '$awayValue%';
    }
    if (unit != null) {
      return '$awayValue $unit';
    }
    return awayValue.toString();
  }

  // 통계 비교를 위한 백분율 계산
  double get homePercentage {
    final total = (homeValue as num) + (awayValue as num);
    if (total == 0) return 0.5;
    return (homeValue as num) / total;
  }

  double get awayPercentage {
    return 1.0 - homePercentage;
  }
}



