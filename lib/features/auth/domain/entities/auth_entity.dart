import 'package:equatable/equatable.dart';

enum UserRole { admin, barber, customer }

class AuthEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final bool isActive;
  
  const AuthEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, email, phone, role, isActive];
  
  bool get isAdmin => role == UserRole.admin;
  bool get isBarber => role == UserRole.barber;
}
