class BarberModel {
  final String id;
  final String name;
  final String specialty;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BarberModel({
    required this.id,
    required this.name,
    this.specialty = '',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory BarberModel.fromJson(Map<String, dynamic> json) {
    return BarberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: (json['specialty'] as String?) ?? '',
      isActive: (json['is_active'] as bool?) ?? true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'is_active': isActive,
    };
  }
}
