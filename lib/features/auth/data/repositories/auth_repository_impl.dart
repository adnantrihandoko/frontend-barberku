import 'package:barberku_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:barberku_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barberku_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  AuthRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<AuthResult> loginWithPin({required String email, required String pin}) async {
    try {
      final response = await remoteDataSource.loginWithPin(email: email, pin: pin);
      await remoteDataSource.saveToken(response.token);
      await remoteDataSource.saveUser(response.user);
      
      return AuthResult(
        user: response.user.toEntity(),
        token: response.token,
      );
    } catch (e) {
      return AuthResult(error: e.toString());
    }
  }
  
  @override
  Future<void> logout() async {
    await remoteDataSource.deleteToken();
    await remoteDataSource.deleteUser();
  }
  
  @override
  Future<AuthEntity?> getCurrentUser() async {
    final userId = await remoteDataSource.storage.read(key: 'user_id');
    final userRole = await remoteDataSource.storage.read(key: 'user_role');
    
    if (userId == null || userRole == null) {
      return null;
    }
    
    return AuthEntity(
      id: userId,
      name: '',
      email: '',
      phone: '',
      role: _parseRole(userRole),
      isActive: true,
    );
  }
  
  @override
  Future<String?> getToken() async {
    return remoteDataSource.getToken();
  }
  
  @override
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
  
  UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'barber':
        return UserRole.barber;
      default:
        return UserRole.customer;
    }
  }
}
