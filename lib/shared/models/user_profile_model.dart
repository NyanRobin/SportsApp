import 'statistics_model.dart';

class UserProfile {
  final String userId;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? position;
  final String? teamId;
  final String? teamName;
  final bool isStudent;
  final String? gradeOrSubject;
  final String? studentId;
  final String? department;
  final String? role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserStats? stats;
  final List<String>? permissions;

  UserProfile({
    required this.userId,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profileImageUrl,
    this.position,
    this.teamId,
    this.teamName,
    required this.isStudent,
    this.gradeOrSubject,
    this.studentId,
    this.department,
    this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.stats,
    this.permissions,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] ?? json['userId'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phone_number'] ?? json['phoneNumber'],
      profileImageUrl: json['profile_image_url'] ?? json['profileImageUrl'],
      position: json['position'],
      teamId: json['team_id'] ?? json['teamId'],
      teamName: json['team_name'] ?? json['teamName'],
      isStudent: json['is_student'] ?? json['isStudent'] ?? false,
      gradeOrSubject: json['grade_or_subject'] ?? json['gradeOrSubject'],
      studentId: json['student_id'] ?? json['studentId'],
      department: json['department'],
      role: json['role'],
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      createdAt: DateTime.parse(json['created_at'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? json['updatedAt'] ?? DateTime.now().toIso8601String()),
      stats: json['stats'] != null ? UserStats.fromJson(json['stats']) : null,
      permissions: json['permissions'] != null 
          ? List<String>.from(json['permissions']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'position': position,
      'team_id': teamId,
      'team_name': teamName,
      'is_student': isStudent,
      'grade_or_subject': gradeOrSubject,
      'student_id': studentId,
      'department': department,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'stats': stats?.toJson(),
      'permissions': permissions,
    };
  }

  UserProfile copyWith({
    String? userId,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    String? position,
    String? teamId,
    String? teamName,
    bool? isStudent,
    String? gradeOrSubject,
    String? studentId,
    String? department,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserStats? stats,
    List<String>? permissions,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      position: position ?? this.position,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      isStudent: isStudent ?? this.isStudent,
      gradeOrSubject: gradeOrSubject ?? this.gradeOrSubject,
      studentId: studentId ?? this.studentId,
      department: department ?? this.department,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
      permissions: permissions ?? this.permissions,
    );
  }

  // Utility getters
  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  
  String get userType => isStudent ? 'Student' : 'Staff';
  
  String get fullInfo {
    if (isStudent) {
      return '$name - ${gradeOrSubject ?? 'Student'}';
    } else {
      return '$name - ${department ?? 'Staff'}';
    }
  }

  bool get hasTeam => teamId != null && teamName != null;
  
  bool get hasProfileImage => profileImageUrl != null && profileImageUrl!.isNotEmpty;
  
  bool get canEditProfile => permissions?.contains('edit_profile') ?? false;
  
  bool get isAdmin => permissions?.contains('admin') ?? false;
  
  bool get isCoach => role == 'coach' || (permissions?.contains('coach') ?? false);
  
  bool get isPlayer => role == 'player' || (permissions?.contains('player') ?? false);
}

class UserProfileUpdate {
  final String? name;
  final String? phoneNumber;
  final String? position;
  final String? gradeOrSubject;
  final String? studentId;
  final String? department;
  final String? profileImageUrl;

  UserProfileUpdate({
    this.name,
    this.phoneNumber,
    this.position,
    this.gradeOrSubject,
    this.studentId,
    this.department,
    this.profileImageUrl,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (position != null) data['position'] = position;
    if (gradeOrSubject != null) data['grade_or_subject'] = gradeOrSubject;
    if (studentId != null) data['student_id'] = studentId;
    if (department != null) data['department'] = department;
    if (profileImageUrl != null) data['profile_image_url'] = profileImageUrl;
    
    return data;
  }

  bool get isEmpty => 
    name == null && 
    phoneNumber == null && 
    position == null && 
    gradeOrSubject == null && 
    studentId == null && 
    department == null && 
    profileImageUrl == null;
} 