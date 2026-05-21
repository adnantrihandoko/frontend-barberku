import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:barberku_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:barberku_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:barberku_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barberku_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:barberku_app/features/auth/domain/usecases/auth_usecases.dart';

final storageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(storageProvider);
  return AuthRemoteDataSource(dio: dio, storage: storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

final loginWithPinProvider = Provider<LoginWithPin>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginWithPin(repository);
});

final logoutProvider = Provider<Logout>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return Logout(repository);
});

final isAuthenticatedProvider = Provider<IsAuthenticated>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return IsAuthenticated(repository);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final loginUseCase = ref.watch(loginWithPinProvider);
  final logoutUseCase = ref.watch(logoutProvider);
  final isAuthenticatedUseCase = ref.watch(isAuthenticatedProvider);
  return AuthNotifier(
    login: loginUseCase,
    logout: logoutUseCase,
    isAuthenticated: isAuthenticatedUseCase,
  );
});

class AuthState {
  final AuthEntity? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  
  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });
  
  AuthState copyWith({
    AuthEntity? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginWithPin _login;
  final Logout _logout;
  final IsAuthenticated _isAuthenticated;
  
  AuthNotifier({
    required LoginWithPin login,
    required Logout logout,
    required IsAuthenticated isAuthenticated,
  })  : _login = login,
        _logout = logout,
        _isAuthenticated = isAuthenticated,
        super(const AuthState()) {
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    final isAuth = await _isAuthenticated();
    state = state.copyWith(isAuthenticated: isAuth);
  }
  
  Future<void> loginWithPin({required String email, required String pin}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await _login(email: email, pin: pin);
    
    if (result.isSuccess) {
      state = AuthState(
        user: result.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = AuthState(
        error: result.error ?? 'Login gagal',
        isLoading: false,
      );
    }
  }
  
  Future<void> performLogout() async {
    state = state.copyWith(isLoading: true);
    await _logout();
    state = const AuthState(isAuthenticated: false);
  }
}
