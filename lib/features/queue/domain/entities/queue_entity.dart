import 'package:equatable/equatable.dart';

class QueueEntity extends Equatable {
  final String id;
  final int queueNumber;
  final String customerId;
  final String customerName;
  final String? barberId;
  final String serviceId;
  final String serviceName;
  final String status;
  final int position;
  final DateTime createdAt;
  final DateTime? calledAt;
  final DateTime? completedAt;
  
  const QueueEntity({
    required this.id,
    required this.queueNumber,
    required this.customerId,
    required this.customerName,
    this.barberId,
    required this.serviceId,
    required this.serviceName,
    required this.status,
    required this.position,
    required this.createdAt,
    this.calledAt,
    this.completedAt,
  });

  @override
  List<Object?> get props => [
        id,
        queueNumber,
        customerId,
        customerName,
        barberId,
        serviceId,
        serviceName,
        status,
        position,
        createdAt,
        calledAt,
        completedAt,
      ];
  
  QueueEntity copyWith({
    String? id,
    int? queueNumber,
    String? customerId,
    String? customerName,
    String? barberId,
    String? serviceId,
    String? serviceName,
    String? status,
    int? position,
    DateTime? createdAt,
    DateTime? calledAt,
    DateTime? completedAt,
  }) {
    return QueueEntity(
      id: id ?? this.id,
      queueNumber: queueNumber ?? this.queueNumber,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      barberId: barberId ?? this.barberId,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      status: status ?? this.status,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      calledAt: calledAt ?? this.calledAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
