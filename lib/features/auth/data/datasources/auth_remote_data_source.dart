import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:barberku_app/core/constants/app_constants.dart';
import 'package:barberku_app/core/utils/logger.dart';
import 'package:barberku_app/features/auth/data/models/auth_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final FlutterSecureStorage storage;
  
  AuthRemoteDataSource({required this.dio, required this.storage});
  
  Future<LoginResponseModel> loginWithPin({required String email, required String pin}) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/api/v1/auth/login',
        data: {'email': email, 'pin': pin},
      );
      
      final data = response.data['data'] as Map<String, dynamic>;
      return LoginResponseModel.fromJson(data);
    } on DioException catch (e) {
      AppLogger.e('Login failed: ${e.response?.data}');
      throw Exception(e.response?.data['error'] ?? 'Login gagal');
    }
  }
  
  Future<void> saveToken(String token) async {
    await storage.write(key: AppConstants.keyAuthToken, value: token);
  }
  
  Future<String?> getToken() async {
    return storage.read(key: AppConstants.keyAuthToken);
  }
  
  Future<void> deleteToken() async {
    await storage.delete(key: AppConstants.keyAuthToken);
  }
  
  Future<void> saveUser(AuthModel user) async {
    await storage.write(key: AppConstants.keyUserId, value: user.id);
    await storage.write(key: AppConstants.keyUserRole, value: user.role);
  }
  
  Future<void> deleteUser() async {
    await storage.delete(key: AppConstants.keyUserId);
    await storage.delete(key: AppConstants.keyUserRole);
  }
}
