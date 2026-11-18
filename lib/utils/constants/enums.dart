enum EUserRole {
  superUser,
  admin,
}

extension EUserRoleExtension on EUserRole {
  String get value {
    switch (this) {
      case EUserRole.superUser:
        return "SUPER_USER";
      case EUserRole.admin:
        return "ADMIN";
    }
  }

  static EUserRole fromValue(String value) {
    switch (value) {
      case "SUPER_USER":
        return EUserRole.superUser;
      case "ADMIN":
        return EUserRole.admin;
      case "CLINICIAN":
      default:
        throw ArgumentError("Invalid role: $value");
    }
  }
}
