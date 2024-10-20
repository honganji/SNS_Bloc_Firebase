/* 
  Auth Repository - Outlines the possible auth operations for this app
 */

import 'package:sns_bloc_firebase/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithEmailPassword(String email, String pasword);
  Future<AppUser?> registerWithEmailPassword(
      String name, String email, String pasword);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
