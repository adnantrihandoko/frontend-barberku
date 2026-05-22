class HistoryModel {
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
  final int? rating;
  final String? review;

  const HistoryModel({
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
    this.rating,
    this.review,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
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
      calledAt: json['called_at'] != null ? DateTime.parse(json['called_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      rating: (json['rating'] as num?)?.toInt(),
      review: json['review'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'queue_number': queueNumber,
      'customer_id': customerId,
      'customer_name': customerName,
      'barber_id': barberId,
      'service_id': serviceId,
      'service_name': serviceName,
      'status': status,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'called_at': calledAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'rating': rating,
      'review': review,
    };
  }
}
