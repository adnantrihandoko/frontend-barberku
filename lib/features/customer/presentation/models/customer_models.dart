class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
  });
}

class BarberModel {
  final String id;
  final String name;
  final String specialty;
  final bool isActive;

  const BarberModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.isActive = true,
  });
}

final dummyServices = [
  const ServiceModel(
    id: '1',
    name: 'Potong Rambut',
    description: 'Potong rambut standar dengan gaya modern',
    price: 35000,
    durationMinutes: 30,
  ),
  const ServiceModel(
    id: '2',
    name: 'Cuci & Potong',
    description: 'Cuci rambut terlebih dahulu, lalu potong',
    price: 50000,
    durationMinutes: 45,
  ),
  const ServiceModel(
    id: '3',
    name: 'Potong Jenggot',
    description: 'Merapikan dan membentuk jenggot',
    price: 25000,
    durationMinutes: 20,
  ),
  const ServiceModel(
    id: '4',
    name: 'Pewarnaan',
    description: 'Mewarnai rambut dengan pilihan warna',
    price: 150000,
    durationMinutes: 90,
  ),
];

final dummyBarbers = [
  const BarberModel(id: '1', name: 'Andi', specialty: 'Senior Barber'),
  const BarberModel(id: '2', name: 'Budi', specialty: 'Hair Stylist'),
  const BarberModel(id: '3', name: 'Candra', specialty: 'Junior Barber'),
];
