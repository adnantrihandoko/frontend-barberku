class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;

  const ServiceModel({required this.id, required this.name, this.description = '', required this.price, required this.durationMinutes});
}

class BarberModel {
  final String id;
  final String name;
  final String specialty;
  final bool isActive;

  const BarberModel({required this.id, required this.name, this.specialty = '', this.isActive = true});
}
