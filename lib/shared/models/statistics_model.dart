class UserStats {
  final String userId;
  final String userName;
  final int totalGames;
  final int wins;
  final int losses;
  final int draws;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final double winRate;
  final String position;
  final String teamName;

  UserStats({
    required this.userId,
    required this.userName,
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
    required this.winRate,
    required this.position,
    required this.teamName,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      totalGames: json['total_games'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      draws: json['draws'] ?? 0,
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      yellowCards: json['yellow_cards'] ?? 0,
      redCards: json['red_cards'] ?? 0,
      winRate: (json['win_rate'] ?? 0.0).toDouble(),
      position: json['position'] ?? '',
      teamName: json['team_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'total_games': totalGames,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'goals': goals,
      'assists': assists,
      'yellow_cards': yellowCards,
      'red_cards': redCards,
      'win_rate': winRate,
      'position': position,
      'team_name': teamName,
    };
  }
}

class TeamStats {
  final int teamId;
  final String teamName;
  final int totalGames;
  final int wins;
  final int losses;
  final int draws;
  final int goalsFor;
  final int goalsAgainst;
  final int goalDifference;
  final int points;
  final double winRate;
  final int rank;

  TeamStats({
    required this.teamId,
    required this.teamName,
    required this.totalGames,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.goalDifference,
    required this.points,
    required this.winRate,
    required this.rank,
  });

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      totalGames: json['total_games'] ?? 0,
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
      draws: json['draws'] ?? 0,
      goalsFor: json['goals_for'] ?? 0,
      goalsAgainst: json['goals_against'] ?? 0,
      goalDifference: json['goal_difference'] ?? 0,
      points: json['points'] ?? 0,
      winRate: (json['win_rate'] ?? 0.0).toDouble(),
      rank: json['rank'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'team_name': teamName,
      'total_games': totalGames,
      'wins': wins,
      'losses': losses,
      'draws': draws,
      'goals_for': goalsFor,
      'goals_against': goalsAgainst,
      'goal_difference': goalDifference,
      'points': points,
      'win_rate': winRate,
      'rank': rank,
    };
  }
}

class TopScorer {
  final String userId;
  final String userName;
  final String teamName;
  final int goals;
  final int assists;
  final int totalGames;
  final double goalsPerGame;

  TopScorer({
    required this.userId,
    required this.userName,
    required this.teamName,
    required this.goals,
    required this.assists,
    required this.totalGames,
    required this.goalsPerGame,
  });

  factory TopScorer.fromJson(Map<String, dynamic> json) {
    return TopScorer(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      teamName: json['team_name'] ?? '',
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      totalGames: json['total_games'] ?? 0,
      goalsPerGame: (json['goals_per_game'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'team_name': teamName,
      'goals': goals,
      'assists': assists,
      'total_games': totalGames,
      'goals_per_game': goalsPerGame,
    };
  }
}

class TopAssister {
  final String userId;
  final String userName;
  final String teamName;
  final int assists;
  final int goals;
  final int totalGames;
  final double assistsPerGame;

  TopAssister({
    required this.userId,
    required this.userName,
    required this.teamName,
    required this.assists,
    required this.goals,
    required this.totalGames,
    required this.assistsPerGame,
  });

  factory TopAssister.fromJson(Map<String, dynamic> json) {
    return TopAssister(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      teamName: json['team_name'] ?? '',
      assists: json['assists'] ?? 0,
      goals: json['goals'] ?? 0,
      totalGames: json['total_games'] ?? 0,
      assistsPerGame: (json['assists_per_game'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'team_name': teamName,
      'assists': assists,
      'goals': goals,
      'total_games': totalGames,
      'assists_per_game': assistsPerGame,
    };
  }
}

class GameStats {
  final int gameId;
  final String gameTitle;
  final DateTime gameDate;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final List<PlayerPerformance> homeTeamStats;
  final List<PlayerPerformance> awayTeamStats;
  final List<GameEvent> events;

  GameStats({
    required this.gameId,
    required this.gameTitle,
    required this.gameDate,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.homeTeamStats,
    required this.awayTeamStats,
    required this.events,
  });

  factory GameStats.fromJson(Map<String, dynamic> json) {
    return GameStats(
      gameId: json['game_id'] ?? 0,
      gameTitle: json['game_title'] ?? '',
      gameDate: DateTime.parse(json['game_date'] ?? DateTime.now().toIso8601String()),
      homeTeam: json['home_team'] ?? '',
      awayTeam: json['away_team'] ?? '',
      homeScore: json['home_score'] ?? 0,
      awayScore: json['away_score'] ?? 0,
      homeTeamStats: json['home_team_stats'] != null
          ? (json['home_team_stats'] as List)
              .map((stat) => PlayerPerformance.fromJson(stat))
              .toList()
          : [],
      awayTeamStats: json['away_team_stats'] != null
          ? (json['away_team_stats'] as List)
              .map((stat) => PlayerPerformance.fromJson(stat))
              .toList()
          : [],
      events: json['events'] != null
          ? (json['events'] as List)
              .map((event) => GameEvent.fromJson(event))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_id': gameId,
      'game_title': gameTitle,
      'game_date': gameDate.toIso8601String(),
      'home_team': homeTeam,
      'away_team': awayTeam,
      'home_score': homeScore,
      'away_score': awayScore,
      'home_team_stats': homeTeamStats.map((stat) => stat.toJson()).toList(),
      'away_team_stats': awayTeamStats.map((stat) => stat.toJson()).toList(),
      'events': events.map((event) => event.toJson()).toList(),
    };
  }
}

class PlayerPerformance {
  final String userId;
  final String userName;
  final String position;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final int minutesPlayed;
  final double rating;

  PlayerPerformance({
    required this.userId,
    required this.userName,
    required this.position,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
    required this.minutesPlayed,
    required this.rating,
  });

  factory PlayerPerformance.fromJson(Map<String, dynamic> json) {
    return PlayerPerformance(
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      position: json['position'] ?? '',
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      yellowCards: json['yellow_cards'] ?? 0,
      redCards: json['red_cards'] ?? 0,
      minutesPlayed: json['minutes_played'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'position': position,
      'goals': goals,
      'assists': assists,
      'yellow_cards': yellowCards,
      'red_cards': redCards,
      'minutes_played': minutesPlayed,
      'rating': rating,
    };
  }
}

class GameEvent {
  final int id;
  final String type; // goal, assist, yellow_card, red_card, substitution
  final String minute;
  final String playerName;
  final String teamName;
  final String? description;

  GameEvent({
    required this.id,
    required this.type,
    required this.minute,
    required this.playerName,
    required this.teamName,
    this.description,
  });

  factory GameEvent.fromJson(Map<String, dynamic> json) {
    return GameEvent(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      minute: json['minute'] ?? '',
      playerName: json['player_name'] ?? '',
      teamName: json['team_name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'minute': minute,
      'player_name': playerName,
      'team_name': teamName,
      'description': description,
    };
  }
} 