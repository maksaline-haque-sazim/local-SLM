import 'package:flutter_getx_starter_template/utils/constants/enums.dart';

class AuthenticatedUser {
  final String id;
  final String email;
  final EUserRole role;

  AuthenticatedUser({
    required this.id,
    required this.email,
    required this.role,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      id: json['id'],
      email: json['phoneNumber'],
      role: EUserRoleExtension.fromValue(json['role'] as String),
    );
  }
}
