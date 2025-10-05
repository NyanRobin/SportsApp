// 포괄적인 프로필 관련 모델들

class PlayerProfile {
  final String playerId;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String position;
  final String teamId;
  final String teamName;
  final bool isActive;
  final PlayerPersonalInfo personalInfo;
  final PlayerStats stats;
  final List<GameHistory> recentGames;
  final List<Achievement> achievements;
  final List<String> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlayerProfile({
    required this.playerId,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    required this.position,
    required this.teamId,
    required this.teamName,
    this.isActive = true,
    required this.personalInfo,
    required this.stats,
    this.recentGames = const [],
    this.achievements = const [],
    this.permissions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlayerProfile.fromJson(Map<String, dynamic> json) {
    return PlayerProfile(
      playerId: json['player_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      profileImageUrl: json['profile_image_url'],
      position: json['position'] ?? '',
      teamId: json['team_id'] ?? '',
      teamName: json['team_name'] ?? '',
      isActive: json['is_active'] ?? true,
      personalInfo: PlayerPersonalInfo.fromJson(json['personal_info'] ?? {}),
      stats: PlayerStats.fromJson(json['stats'] ?? {}),
      recentGames: (json['recent_games'] as List<dynamic>?)
          ?.map((game) => GameHistory.fromJson(game))
          .toList() ?? [],
      achievements: (json['achievements'] as List<dynamic>?)
          ?.map((achievement) => Achievement.fromJson(achievement))
          .toList() ?? [],
      permissions: List<String>.from(json['permissions'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_id': playerId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'position': position,
      'team_id': teamId,
      'team_name': teamName,
      'is_active': isActive,
      'personal_info': personalInfo.toJson(),
      'stats': stats.toJson(),
      'recent_games': recentGames.map((game) => game.toJson()).toList(),
      'achievements': achievements.map((achievement) => achievement.toJson()).toList(),
      'permissions': permissions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class PlayerPersonalInfo {
  final bool isStudent;
  final String? gradeOrSubject;
  final String? studentId;
  final String? department;
  final String? role;
  final DateTime? birthDate;
  final String? height;
  final String? weight;
  final String? nationality;
  final String? emergencyContact;
  final String? emergencyPhone;

  PlayerPersonalInfo({
    this.isStudent = true,
    this.gradeOrSubject,
    this.studentId,
    this.department,
    this.role,
    this.birthDate,
    this.height,
    this.weight,
    this.nationality,
    this.emergencyContact,
    this.emergencyPhone,
  });

  factory PlayerPersonalInfo.fromJson(Map<String, dynamic> json) {
    return PlayerPersonalInfo(
      isStudent: json['is_student'] ?? true,
      gradeOrSubject: json['grade_or_subject'],
      studentId: json['student_id'],
      department: json['department'],
      role: json['role'],
      birthDate: json['birth_date'] != null ? DateTime.parse(json['birth_date']) : null,
      height: json['height'],
      weight: json['weight'],
      nationality: json['nationality'],
      emergencyContact: json['emergency_contact'],
      emergencyPhone: json['emergency_phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_student': isStudent,
      'grade_or_subject': gradeOrSubject,
      'student_id': studentId,
      'department': department,
      'role': role,
      'birth_date': birthDate?.toIso8601String(),
      'height': height,
      'weight': weight,
      'nationality': nationality,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
    };
  }

  int? get age {
    if (birthDate == null) return null;
    final now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month || 
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }
}

class PlayerStats {
  final int totalGames;
  final int goals;
  final int assists;
  final int minutesPlayed;
  final int yellowCards;
  final int redCards;
  final int shotsOnTarget;
  final int shotsTotal;
  final int passesCompleted;
  final int passesTotal;
  final int tackles;
  final int interceptions;
  final int saves;
  final int cleanSheets;
  final double averageRating;
  final String season;

  PlayerStats({
    this.totalGames = 0,
    this.goals = 0,
    this.assists = 0,
    this.minutesPlayed = 0,
    this.yellowCards = 0,
    this.redCards = 0,
    this.shotsOnTarget = 0,
    this.shotsTotal = 0,
    this.passesCompleted = 0,
    this.passesTotal = 0,
    this.tackles = 0,
    this.interceptions = 0,
    this.saves = 0,
    this.cleanSheets = 0,
    this.averageRating = 0.0,
    this.season = '2025',
  });

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      totalGames: json['total_games'] ?? 0,
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      minutesPlayed: json['minutes_played'] ?? 0,
      yellowCards: json['yellow_cards'] ?? 0,
      redCards: json['red_cards'] ?? 0,
      shotsOnTarget: json['shots_on_target'] ?? 0,
      shotsTotal: json['shots_total'] ?? 0,
      passesCompleted: json['passes_completed'] ?? 0,
      passesTotal: json['passes_total'] ?? 0,
      tackles: json['tackles'] ?? 0,
      interceptions: json['interceptions'] ?? 0,
      saves: json['saves'] ?? 0,
      cleanSheets: json['clean_sheets'] ?? 0,
      averageRating: (json['average_rating'] ?? 0.0).toDouble(),
      season: json['season'] ?? '2025',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_games': totalGames,
      'goals': goals,
      'assists': assists,
      'minutes_played': minutesPlayed,
      'yellow_cards': yellowCards,
      'red_cards': redCards,
      'shots_on_target': shotsOnTarget,
      'shots_total': shotsTotal,
      'passes_completed': passesCompleted,
      'passes_total': passesTotal,
      'tackles': tackles,
      'interceptions': interceptions,
      'saves': saves,
      'clean_sheets': cleanSheets,
      'average_rating': averageRating,
      'season': season,
    };
  }

  // 계산된 통계
  double get goalsPerGame => totalGames > 0 ? goals / totalGames : 0.0;
  double get assistsPerGame => totalGames > 0 ? assists / totalGames : 0.0;
  double get minutesPerGame => totalGames > 0 ? minutesPlayed / totalGames : 0.0;
  double get passAccuracy => passesTotal > 0 ? (passesCompleted / passesTotal) * 100 : 0.0;
  double get shotAccuracy => shotsTotal > 0 ? (shotsOnTarget / shotsTotal) * 100 : 0.0;
}

class GameHistory {
  final int gameId;
  final String gameTitle;
  final String opponent;
  final DateTime gameDate;
  final String result; // W 2-1, D 1-1, L 0-2
  final int goals;
  final int assists;
  final int minutesPlayed;
  final double rating;
  final bool isHomeGame;
  final String? motm; // Man of the Match
  final List<String> events; // goals, assists, cards, etc.

  GameHistory({
    required this.gameId,
    required this.gameTitle,
    required this.opponent,
    required this.gameDate,
    required this.result,
    this.goals = 0,
    this.assists = 0,
    this.minutesPlayed = 0,
    this.rating = 0.0,
    this.isHomeGame = true,
    this.motm,
    this.events = const [],
  });

  factory GameHistory.fromJson(Map<String, dynamic> json) {
    return GameHistory(
      gameId: json['game_id'] ?? 0,
      gameTitle: json['game_title'] ?? '',
      opponent: json['opponent'] ?? '',
      gameDate: DateTime.parse(json['game_date'] ?? DateTime.now().toIso8601String()),
      result: json['result'] ?? '',
      goals: json['goals'] ?? 0,
      assists: json['assists'] ?? 0,
      minutesPlayed: json['minutes_played'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isHomeGame: json['is_home_game'] ?? true,
      motm: json['motm'],
      events: List<String>.from(json['events'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'game_id': gameId,
      'game_title': gameTitle,
      'opponent': opponent,
      'game_date': gameDate.toIso8601String(),
      'result': result,
      'goals': goals,
      'assists': assists,
      'minutes_played': minutesPlayed,
      'rating': rating,
      'is_home_game': isHomeGame,
      'motm': motm,
      'events': events,
    };
  }

  bool get isWin => result.startsWith('W');
  bool get isDraw => result.startsWith('D');
  bool get isLoss => result.startsWith('L');
  
  String get formattedDate {
    return '${gameDate.month}/${gameDate.day}/${gameDate.year}';
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String category; // tournament, personal, team, seasonal
  final DateTime achievedDate;
  final String iconType; // trophy, star, medal, etc.
  final String? imageUrl;
  final bool isPublic;
  final Map<String, dynamic>? metadata;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.achievedDate,
    this.iconType = 'trophy',
    this.imageUrl,
    this.isPublic = true,
    this.metadata,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'personal',
      achievedDate: DateTime.parse(json['achieved_date'] ?? DateTime.now().toIso8601String()),
      iconType: json['icon_type'] ?? 'trophy',
      imageUrl: json['image_url'],
      isPublic: json['is_public'] ?? true,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'achieved_date': achievedDate.toIso8601String(),
      'icon_type': iconType,
      'image_url': imageUrl,
      'is_public': isPublic,
      'metadata': metadata,
    };
  }

  String get formattedDate {
    return '${achievedDate.month}/${achievedDate.day}/${achievedDate.year}';
  }
}

class TeamMember {
  final String playerId;
  final String name;
  final String position;
  final String? profileImageUrl;
  final bool isActive;
  final String role; // player, captain, vice_captain
  final int jerseyNumber;
  final PlayerStats? stats;

  TeamMember({
    required this.playerId,
    required this.name,
    required this.position,
    this.profileImageUrl,
    this.isActive = true,
    this.role = 'player',
    this.jerseyNumber = 0,
    this.stats,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      playerId: json['player_id'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? '',
      profileImageUrl: json['profile_image_url'],
      isActive: json['is_active'] ?? true,
      role: json['role'] ?? 'player',
      jerseyNumber: json['jersey_number'] ?? 0,
      stats: json['stats'] != null ? PlayerStats.fromJson(json['stats']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_id': playerId,
      'name': name,
      'position': position,
      'profile_image_url': profileImageUrl,
      'is_active': isActive,
      'role': role,
      'jersey_number': jerseyNumber,
      'stats': stats?.toJson(),
    };
  }

  bool get isCaptain => role == 'captain';
  bool get isViceCaptain => role == 'vice_captain';
}

class ProfileUpdateRequest {
  final String? name;
  final String? phoneNumber;
  final String? position;
  final String? profileImageUrl;
  final PlayerPersonalInfo? personalInfo;

  ProfileUpdateRequest({
    this.name,
    this.phoneNumber,
    this.position,
    this.profileImageUrl,
    this.personalInfo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (position != null) data['position'] = position;
    if (profileImageUrl != null) data['profile_image_url'] = profileImageUrl;
    if (personalInfo != null) data['personal_info'] = personalInfo!.toJson();
    
    return data;
  }

  bool get isEmpty => 
    name == null && 
    phoneNumber == null && 
    position == null && 
    profileImageUrl == null && 
    personalInfo == null;
}

class ProfileSearchFilter {
  final String? name;
  final String? position;
  final String? teamId;
  final String? role;
  final bool? isActive;
  final String? season;
  final int limit;
  final int offset;

  ProfileSearchFilter({
    this.name,
    this.position,
    this.teamId,
    this.role,
    this.isActive,
    this.season,
    this.limit = 20,
    this.offset = 0,
  });

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {
      'limit': limit,
      'offset': offset,
    };
    
    if (name != null) params['name'] = name;
    if (position != null) params['position'] = position;
    if (teamId != null) params['team_id'] = teamId;
    if (role != null) params['role'] = role;
    if (isActive != null) params['is_active'] = isActive;
    if (season != null) params['season'] = season;
    
    return params;
  }
}



