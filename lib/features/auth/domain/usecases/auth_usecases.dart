import 'package:barberku_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barberku_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithPin {
  final AuthRepository repository;
  
  LoginWithPin(this.repository);
  
  Future<AuthResult> call({required String email, required String pin}) async {
    return repository.loginWithPin(email: email, pin: pin);
  }
}

class Logout {
  final AuthRepository repository;
  
  Logout(this.repository);
  
  Future<void> call() async {
    return repository.logout();
  }
}

class GetCurrentUser {
  final AuthRepository repository;
  
  GetCurrentUser(this.repository);
  
  Future<AuthEntity?> call() async {
    return repository.getCurrentUser();
  }
}

class IsAuthenticated {
  final AuthRepository repository;
  
  IsAuthenticated(this.repository);
  
  Future<bool> call() async {
    return repository.isAuthenticated();
  }
}

class GetToken {
  final AuthRepository repository;
  
  GetToken(this.repository);
  
  Future<String?> call() async {
    return repository.getToken();
  }
}
