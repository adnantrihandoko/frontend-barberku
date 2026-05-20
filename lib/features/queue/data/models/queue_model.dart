import 'package:json_annotation/json_annotation.dart';
import 'package:barberku_app/features/queue/domain/entities/queue_entity.dart';

part 'queue_model.g.dart';

@JsonSerializable()
class QueueModel {
  final String id;
  @JsonKey(name: 'queue_number')
  final int queueNumber;
  @JsonKey(name: 'customer_id')
  final String customerId;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'barber_id')
  final String? barberId;
  @JsonKey(name: 'service_id')
  final String serviceId;
  @JsonKey(name: 'service_name')
  final String serviceName;
  final String status;
  final int position;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'called_at')
  final DateTime? calledAt;
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  
  const QueueModel({
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
  
  factory QueueModel.fromJson(Map<String, dynamic> json) => _$QueueModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$QueueModelToJson(this);
  
  QueueEntity toEntity() {
    return QueueEntity(
      id: id,
      queueNumber: queueNumber,
      customerId: customerId,
      customerName: customerName,
      barberId: barberId,
      serviceId: serviceId,
      serviceName: serviceName,
      status: status,
      position: position,
      createdAt: createdAt,
      calledAt: calledAt,
      completedAt: completedAt,
    );
  }
  
  factory QueueModel.fromEntity(QueueEntity entity) {
    return QueueModel(
      id: entity.id,
      queueNumber: entity.queueNumber,
      customerId: entity.customerId,
      customerName: entity.customerName,
      barberId: entity.barberId,
      serviceId: entity.serviceId,
      serviceName: entity.serviceName,
      status: entity.status,
      position: entity.position,
      createdAt: entity.createdAt,
      calledAt: entity.calledAt,
      completedAt: entity.completedAt,
    );
  }
}
