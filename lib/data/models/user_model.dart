// lib/data/models/user_model.dart

class UserModel {
  final int? id;
  final String username;
  final String password;
  final String fullName;
  final String role; // 'admin' or 'employee'
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.role,
    required this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  // Convert to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'full_name': fullName,
      'role': role,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Create from Map (database)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      fullName: map['full_name'],
      role: map['role'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Copy with method
  UserModel copyWith({
    int? id,
    String? username,
    String? password,
    String? fullName,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // For display (hide password)
  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, fullName: $fullName, role: $role)';
  }
}
