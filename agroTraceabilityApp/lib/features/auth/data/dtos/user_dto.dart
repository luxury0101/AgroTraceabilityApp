import 'package:agro_traceability/features/auth/domain/entities/user.dart';

class UserDto {
  final String id;
  final String fullName;
  final String email;
  final String role;

  const UserDto({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'email': email, 'role': role};
  }

  User toEntity() {
    return User(id: id, fullName: fullName, email: email, role: role);
  }
}
