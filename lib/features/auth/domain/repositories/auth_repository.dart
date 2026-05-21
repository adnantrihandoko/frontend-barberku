import 'package:barberku_app/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthResult> loginWithPin({required String email, required String pin});
  Future<void> logout();
  Future<AuthEntity?> getCurrentUser();
  Future<String?> getToken();
  Future<bool> isAuthenticated();
}

class AuthResult {
  final AuthEntity? user;
  final String? token;
  final String? error;
  
  const AuthResult({this.user, this.token, this.error});
  
  bool get isSuccess => user != null && token != null;
}
