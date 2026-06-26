import 'package:flutter/foundation.dart';

import '../models/app_role.dart';

class AppStateProvider extends ChangeNotifier {
  AppRole? _selectedRole;

  AppRole? get selectedRole => _selectedRole;

  void selectRole(AppRole role) {
    _selectedRole = role;
    notifyListeners();
  }
}
