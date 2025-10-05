// 종합 통계 모델들

class TopScorer {
  final int rank;
  final String user_id;
  final String user_name;
  final bool is_student;
  final String? grade_or_subject;
  final String? position;
  final int? jersey_number;
  final String? team_name;
  final int goals;
  final int assists;
  final int total_games;
  final int total_minutes;
  final double goals_per_game;

  TopScorer({
    required this.rank,
    required this.user_id,
    required this.user_name,
    this.is_student = false,
    this.grade_or_subject,
    this.position,
    this.jersey_number,
    this.team_name,
    this.goals = 0,
    this.assists = 0,
    this.total_games = 0,
    this.total_minutes = 0,
    this.goals_per_game = 0.0,
  });

  factory TopScorer.fromJson(Map<String, dynamic> json) {
    return TopScorer(
      rank: json['rank'] ?? 0,
      user_id: json['user_id'] ?? '',
      user_name: json['user_name'] ?? '',
      is_student: json['is_student'] ?? false,
      grade_or_subject: json['grade_or_subject'],
      position: json['position'],
      jersey_number: json['jersey_number'],
      team_name: json['team_name'],
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      total_games: json['total_games'] ?? 0,
      total_minutes: json['total_minutes'] ?? 0,
      goals_per_game: (json['goals_per_game'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'user_id': user_id,
      'user_name': user_name,
      'is_student': is_student,
      'grade_or_subject': grade_or_subject,
      'position': position,
      'jersey_number': jersey_number,
      'team_name': team_name,
      'goals': goals,
      'assists': assists,
      'total_games': total_games,
      'total_minutes': total_minutes,
      'goals_per_game': goals_per_game,
    };
  }
}

class TopAssister {
  final int rank;
  final String user_id;
  final String user_name;
  final bool is_student;
  final String? grade_or_subject;
  final String? position;
  final int? jersey_number;
  final String? team_name;
  final int goals;
  final int assists;
  final int total_games;
  final int total_minutes;
  final double assists_per_game;

  TopAssister({
    required this.rank,
    required this.user_id,
    required this.user_name,
    this.is_student = false,
    this.grade_or_subject,
    this.position,
    this.jersey_number,
    this.team_name,
    this.goals = 0,
    this.assists = 0,
    this.total_games = 0,
    this.total_minutes = 0,
    this.assists_per_game = 0.0,
  });

  factory TopAssister.fromJson(Map<String, dynamic> json) {
    return TopAssister(
      rank: json['rank'] ?? 0,
      user_id: json['user_id'] ?? '',
      user_name: json['user_name'] ?? '',
      is_student: json['is_student'] ?? false,
      grade_or_subject: json['grade_or_subject'],
      position: json['position'],
      jersey_number: json['jersey_number'],
      team_name: json['team_name'],
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      total_games: json['total_games'] ?? 0,
      total_minutes: json['total_minutes'] ?? 0,
      assists_per_game: (json['assists_per_game'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'user_id': user_id,
      'user_name': user_name,
      'is_student': is_student,
      'grade_or_subject': grade_or_subject,
      'position': position,
      'jersey_number': jersey_number,
      'team_name': team_name,
      'goals': goals,
      'assists': assists,
      'total_games': total_games,
      'total_minutes': total_minutes,
      'assists_per_game': assists_per_game,
    };
  }
}

class PlayerStatistics {
  final String playerId;
  final String playerName;
  final String teamName;
  final String position;
  final int totalGames;
  final int minutesPlayed;
  final int goals;
  final int assists;
  final int shots;
  final int shotsOnTarget;
  final int passes;
  final int passesCompleted;
  final int tackles;
  final int interceptions;
  final int yellowCards;
  final int redCards;
  final int fouls;
  final double averageRating;
  final String season;

  PlayerStatistics({
    required this.playerId,
    required this.playerName,
    required this.teamName,
    required this.position,
    this.totalGames = 0,
    this.minutesPlayed = 0,
    this.goals = 0,
    this.assists = 0,
    this.shots = 0,
    this.shotsOnTarget = 0,
    this.passes = 0,
    this.passesCompleted = 0,
    this.tackles = 0,
    this.interceptions = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.fouls = 0,
    this.averageRating = 0.0,
    this.season = '2025',
  });

  factory PlayerStatistics.fromJson(Map<String, dynamic> json) {
    return PlayerStatistics(
      playerId: json['user_id'] ?? json['player_id'] ?? '',
      playerName: json['user_name'] ?? json['player_name'] ?? '',
      teamName: json['team_name'] ?? '',
      position: json['position'] ?? '',
      totalGames: json['total_games'] ?? 0,
      minutesPlayed: json['minutes_played'] ?? 0,
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      shots: json['shots'] ?? 0,
      shotsOnTarget: json['shots_on_target'] ?? 0,
      passes: json['passes'] ?? 0,
      passesCompleted: json['passes_completed'] ?? 0,
      tackles: json['tackles'] ?? 0,
      interceptions: json['interceptions'] ?? 0,
      yellowCards: json['yellow_cards'] ?? 0,
      redCards: json['red_cards'] ?? 0,
      fouls: json['fouls'] ?? 0,
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      season: json['season'] ?? '2025',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_id': playerId,
      'player_name': playerName,
      'team_name': teamName,
      'position': position,
      'total_games': totalGames,
      'minutes_played': minutesPlayed,
      'goals': goals,
      'assists': assists,
      'shots': shots,
      'shots_on_target': shotsOnTarget,
      'passes': passes,
      'passes_completed': passesCompleted,
      'tackles': tackles,
      'interceptions': interceptions,
      'yellow_cards': yellowCards,
      'red_cards': redCards,
      'fouls': fouls,
      'average_rating': averageRating,
      'season': season,
    };
  }

  // 계산된 통계
  double get goalsPerGame => totalGames > 0 ? goals / totalGames : 0.0;
  double get assistsPerGame => totalGames > 0 ? assists / totalGames : 0.0;
  double get passAccuracy => passes > 0 ? (passesCompleted / passes) * 100 : 0.0;
  double get shotsAccuracy => shots > 0 ? (shotsOnTarget / shots) * 100 : 0.0;
  double get minutesPerGame => totalGames > 0 ? minutesPlayed / totalGames : 0.0;
}

class TeamRanking {
  final int team_id;
  final String team_name;
  final String? description;
  final String? logo_url;
  final int rank;
  final int total_games;
  final int completed_games;
  final int wins;
  final int draws;
  final int losses;
  final int goals_for;
  final int goals_against;
  final int goal_difference;
  final int points;
  final double win_rate;
  final String season;

  TeamRanking({
    required this.team_id,
    required this.team_name,
    this.description,
    this.logo_url,
    required this.rank,
    this.total_games = 0,
    this.completed_games = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goals_for = 0,
    this.goals_against = 0,
    this.goal_difference = 0,
    this.points = 0,
    this.win_rate = 0.0,
    this.season = '2025',
  });

  factory TeamRanking.fromJson(Map<String, dynamic> json) {
    return TeamRanking(
      team_id: json['team_id'] ?? 0,
      team_name: json['team_name'] ?? '',
      description: json['description'],
      logo_url: json['logo_url'],
      rank: json['rank'] ?? 0,
      total_games: json['total_games'] ?? 0,
      completed_games: json['completed_games'] ?? 0,
      wins: json['wins'] ?? 0,
      draws: json['draws'] ?? 0,
      losses: json['losses'] ?? 0,
      goals_for: json['goals_for'] ?? 0,
      goals_against: json['goals_against'] ?? 0,
      goal_difference: json['goal_difference'] ?? 0,
      points: json['points'] ?? 0,
      win_rate: (json['win_rate'] ?? 0.0).toDouble(),
      season: json['season'] ?? '2025',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': team_id,
      'team_name': team_name,
      'description': description,
      'logo_url': logo_url,
      'rank': rank,
      'total_games': total_games,
      'completed_games': completed_games,
      'wins': wins,
      'draws': draws,
      'losses': losses,
      'goals_for': goals_for,
      'goals_against': goals_against,
      'goal_difference': goal_difference,
      'points': points,
      'win_rate': win_rate,
      'season': season,
    };
  }

  // Legacy getters for backward compatibility
  int get teamId => team_id;
  String get teamName => team_name;
  int get position => rank;
  int get gamesPlayed => total_games;
  int get goalsFor => goals_for;
  int get goalsAgainst => goals_against;
  int get goalDifference => goal_difference;
  double get winRate => win_rate;
  double get averageGoalsFor => total_games > 0 ? goals_for / total_games : 0.0;
  double get averageGoalsAgainst => total_games > 0 ? goals_against / total_games : 0.0;
}

class SeasonStatistics {
  final String season;
  final int totalGames;
  final int totalGoals;
  final int totalPlayers;
  final int totalTeams;
  final PlayerStatistics? topScorer;
  final PlayerStatistics? topAssister;
  final TeamRanking? topTeam;
  final double averageGoalsPerGame;
  final DateTime lastUpdated;

  SeasonStatistics({
    required this.season,
    this.totalGames = 0,
    this.totalGoals = 0,
    this.totalPlayers = 0,
    this.totalTeams = 0,
    this.topScorer,
    this.topAssister,
    this.topTeam,
    this.averageGoalsPerGame = 0.0,
    required this.lastUpdated,
  });

  factory SeasonStatistics.fromJson(Map<String, dynamic> json) {
    return SeasonStatistics(
      season: json['season'] ?? '2025',
      totalGames: json['total_games'] ?? 0,
      totalGoals: json['total_goals'] ?? 0,
      totalPlayers: json['total_players'] ?? 0,
      totalTeams: json['total_teams'] ?? 0,
      topScorer: json['top_scorer'] != null 
          ? PlayerStatistics.fromJson(json['top_scorer']) 
          : null,
      topAssister: json['top_assister'] != null 
          ? PlayerStatistics.fromJson(json['top_assister']) 
          : null,
      topTeam: json['top_team'] != null 
          ? TeamRanking.fromJson(json['top_team']) 
          : null,
      averageGoalsPerGame: (json['average_goals_per_game'] ?? 0.0).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'season': season,
      'total_games': totalGames,
      'total_goals': totalGoals,
      'total_players': totalPlayers,
      'total_teams': totalTeams,
      'top_scorer': topScorer?.toJson(),
      'top_assister': topAssister?.toJson(),
      'top_team': topTeam?.toJson(),
      'average_goals_per_game': averageGoalsPerGame,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class GamePerformance {
  final int gameId;
  final String gameTitle;
  final DateTime gameDate;
  final String playerName;
  final String teamName;
  final int minutesPlayed;
  final int goals;
  final int assists;
  final int shots;
  final int passes;
  final int tackles;
  final double rating;
  final bool isWin;

  GamePerformance({
    required this.gameId,
    required this.gameTitle,
    required this.gameDate,
    required this.playerName,
    required this.teamName,
    this.minutesPlayed = 0,
    this.goals = 0,
    this.assists = 0,
    this.shots = 0,
    this.passes = 0,
    this.tackles = 0,
    this.rating = 0.0,
    this.isWin = false,
  });

  factory GamePerformance.fromJson(Map<String, dynamic> json) {
    return GamePerformance(
      gameId: json['game_id'] ?? 0,
      gameTitle: json['game_title'] ?? '',
      gameDate: DateTime.parse(json['game_date'] ?? DateTime.now().toIso8601String()),
      playerName: json['player_name'] ?? '',
      teamName: json['team_name'] ?? '',
      minutesPlayed: json['minutes_played'] ?? 0,
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      shots: json['shots'] ?? 0,
      passes: json['passes'] ?? 0,
      tackles: json['tackles'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isWin: json['is_win'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_id': gameId,
      'game_title': gameTitle,
      'game_date': gameDate.toIso8601String(),
      'player_name': playerName,
      'team_name': teamName,
      'minutes_played': minutesPlayed,
      'goals': goals,
      'assists': assists,
      'shots': shots,
      'passes': passes,
      'tackles': tackles,
      'rating': rating,
      'is_win': isWin,
    };
  }
}

class StatisticsFilter {
  final String? season;
  final String? position;
  final String? teamName;
  final String? category; // 'goals', 'assists', 'passes', etc.
  final int limit;
  final String sortBy;
  final bool ascending;

  StatisticsFilter({
    this.season,
    this.position,
    this.teamName,
    this.category,
    this.limit = 10,
    this.sortBy = 'goals',
    this.ascending = false,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{
      'limit': limit,
      'sort_by': sortBy,
      'ascending': ascending,
    };
    
    if (season != null) params['season'] = season;
    if (position != null) params['position'] = position;
    if (teamName != null) params['team_name'] = teamName;
    if (category != null) params['category'] = category;
    
    return params;
  }
}
