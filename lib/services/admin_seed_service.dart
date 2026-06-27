import '../models/user_profile.dart';
import 'auth_service.dart';
import 'firestore_service.dart';

class AdminSeedService {
  AdminSeedService({
    AuthService? authService,
    FirestoreService? firestoreService,
  }) : _authService = authService ?? AuthService(),
       _firestoreService = firestoreService ?? FirestoreService();

  static const adminEmail = 'admin@sumaqia.com';

  final AuthService _authService;
  final FirestoreService _firestoreService;

  Future<bool> ensureCurrentUserAdminIfAllowed() async {
    final user = _authService.currentUser;
    final email = user?.email?.trim().toLowerCase();

    if (user == null || email != adminEmail) {
      return false;
    }

    await _firestoreService.createUserProfile(
      UserProfile(
        uid: user.uid,
        name: 'Administrador SUMAQ IA',
        email: adminEmail,
        role: 'admin',
        city: 'La Paz',
        createdAt: DateTime.now(),
      ),
    );

    return true;
  }
}
