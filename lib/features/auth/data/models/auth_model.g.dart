// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) {
  return AuthModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    role: json['role'] as String,
    isActive: json['is_active'] as bool,
  );
}

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) {
  return <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'email': instance.email,
    'phone': instance.phone,
    'role': instance.role,
    'is_active': instance.isActive,
  };
}

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) {
  return LoginResponseModel(
    token: json['token'] as String,
    user: AuthModel.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) {
  return <String, dynamic>{
    'token': instance.token,
    'user': instance.user.toJson(),
  };
}
