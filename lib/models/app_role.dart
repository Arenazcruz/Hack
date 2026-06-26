enum AppRole { entrepreneur, tourist }

extension AppRoleLabel on AppRole {
  String get label {
    switch (this) {
      case AppRole.entrepreneur:
        return 'Emprendedor gastronomico';
      case AppRole.tourist:
        return 'Turista';
    }
  }
}
