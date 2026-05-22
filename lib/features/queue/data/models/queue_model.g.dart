// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueModel _$QueueModelFromJson(Map<String, dynamic> json) => QueueModel(
      id: json['id'] as String,
      queueNumber: (json['queue_number'] as num).toInt(),
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String,
      barberId: json['barber_id'] as String?,
      serviceId: json['service_id'] as String,
      serviceName: json['service_name'] as String,
      status: json['status'] as String,
      position: (json['position'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      calledAt: json['called_at'] == null
          ? null
          : DateTime.parse(json['called_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$QueueModelToJson(QueueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'queue_number': instance.queueNumber,
      'customer_id': instance.customerId,
      'customer_name': instance.customerName,
      'barber_id': instance.barberId,
      'service_id': instance.serviceId,
      'service_name': instance.serviceName,
      'status': instance.status,
      'position': instance.position,
      'created_at': instance.createdAt.toIso8601String(),
      'called_at': instance.calledAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };
