class UserModel {
  final String uid;
  final String email;
  final String name;
  final String? phone;
  final bool isStudent;
  final String gradeOrSubject;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  
  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.isStudent,
    required this.gradeOrSubject,
    this.createdAt,
    this.updatedAt,
  });
  
  // Create from Firestore document
  factory UserModel.fromMap(String uid, Map<String, dynamic> data) {
    return UserModel(
      uid: uid,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      isStudent: data['isStudent'] ?? true,
      gradeOrSubject: data['gradeOrSubject'] ?? '',
      createdAt: data['createdAt'] != null 
          ? (data['createdAt'] as dynamic).toDate() 
          : null,
      updatedAt: data['updatedAt'] != null 
          ? (data['updatedAt'] as dynamic).toDate() 
          : null,
    );
  }
  
  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'isStudent': isStudent,
      'gradeOrSubject': gradeOrSubject,
      // createdAt and updatedAt are handled by the service
    };
  }
  
  // Create a copy with updated fields
  UserModel copyWith({
    String? email,
    String? name,
    String? phone,
    bool? isStudent,
    String? gradeOrSubject,
  }) {
    return UserModel(
      uid: this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isStudent: isStudent ?? this.isStudent,
      gradeOrSubject: gradeOrSubject ?? this.gradeOrSubject,
      createdAt: this.createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
