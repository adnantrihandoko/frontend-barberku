import 'package:json_annotation/json_annotation.dart';
import 'package:barberku_app/features/auth/domain/entities/auth_entity.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  const AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
  });
  
  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
  
  AuthEntity toEntity() {
    return AuthEntity(
      id: id,
      name: name,
      email: email,
      phone: phone,
      role: _parseRole(role),
      isActive: isActive,
    );
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

@JsonSerializable()
class LoginResponseModel {
  final String token;
  final AuthModel user;
  
  const LoginResponseModel({
    required this.token,
    required this.user,
  });
  
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
