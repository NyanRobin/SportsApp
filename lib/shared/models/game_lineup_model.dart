class GameLineup {
  final int gameId;
  final String teamName;
  final String formation;
  final List<PlayerLineup> startingEleven;
  final List<PlayerLineup> substitutes;
  final DateTime updatedAt;

  GameLineup({
    required this.gameId,
    required this.teamName,
    required this.formation,
    required this.startingEleven,
    required this.substitutes,
    required this.updatedAt,
  });

  factory GameLineup.fromJson(Map<String, dynamic> json) {
    return GameLineup(
      gameId: json['game_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      formation: json['formation'] ?? '4-4-2',
      startingEleven: (json['starting_eleven'] as List<dynamic>?)
          ?.map((player) => PlayerLineup.fromJson(player))
          .toList() ?? [],
      substitutes: (json['substitutes'] as List<dynamic>?)
          ?.map((player) => PlayerLineup.fromJson(player))
          .toList() ?? [],
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_id': gameId,
      'team_name': teamName,
      'formation': formation,
      'starting_eleven': startingEleven.map((player) => player.toJson()).toList(),
      'substitutes': substitutes.map((player) => player.toJson()).toList(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class PlayerLineup {
  final int playerId;
  final String playerName;
  final int jerseyNumber;
  final String position;
  final bool isCaptain;
  final bool isSubstituted;
  final int? minuteSubstituted;
  final String? substitutePlayerName;

  PlayerLineup({
    required this.playerId,
    required this.playerName,
    required this.jerseyNumber,
    required this.position,
    this.isCaptain = false,
    this.isSubstituted = false,
    this.minuteSubstituted,
    this.substitutePlayerName,
  });

  factory PlayerLineup.fromJson(Map<String, dynamic> json) {
    return PlayerLineup(
      playerId: json['player_id'] ?? 0,
      playerName: json['player_name'] ?? '',
      jerseyNumber: json['jersey_number'] ?? 0,
      position: json['position'] ?? '',
      isCaptain: json['is_captain'] ?? false,
      isSubstituted: json['is_substituted'] ?? false,
      minuteSubstituted: json['minute_substituted'],
      substitutePlayerName: json['substitute_player_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_id': playerId,
      'player_name': playerName,
      'jersey_number': jerseyNumber,
      'position': position,
      'is_captain': isCaptain,
      'is_substituted': isSubstituted,
      'minute_substituted': minuteSubstituted,
      'substitute_player_name': substitutePlayerName,
    };
  }

  // 포지션에 따른 색상 반환
  String get positionColor {
    switch (position.toUpperCase()) {
      case 'GK':
        return '#FF9800'; // Orange
      case 'CB':
      case 'LB':
      case 'RB':
      case 'LWB':
      case 'RWB':
        return '#2196F3'; // Blue
      case 'CM':
      case 'CDM':
      case 'CAM':
      case 'LM':
      case 'RM':
        return '#4CAF50'; // Green
      case 'LW':
      case 'RW':
      case 'CF':
      case 'ST':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  // 포지션 풀네임
  String get positionFullName {
    switch (position.toUpperCase()) {
      case 'GK':
        return 'Goalkeeper';
      case 'CB':
        return 'Center Back';
      case 'LB':
        return 'Left Back';
      case 'RB':
        return 'Right Back';
      case 'LWB':
        return 'Left Wing Back';
      case 'RWB':
        return 'Right Wing Back';
      case 'CM':
        return 'Central Midfielder';
      case 'CDM':
        return 'Defensive Midfielder';
      case 'CAM':
        return 'Attacking Midfielder';
      case 'LM':
        return 'Left Midfielder';
      case 'RM':
        return 'Right Midfielder';
      case 'LW':
        return 'Left Winger';
      case 'RW':
        return 'Right Winger';
      case 'CF':
        return 'Center Forward';
      case 'ST':
        return 'Striker';
      default:
        return position;
    }
  }
}



