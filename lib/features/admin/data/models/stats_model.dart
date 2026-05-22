class StatsModel {
  final int totalServed;
  final int totalCanceled;
  final double avgWaitTimeMin;
  final double avgServiceTimeMin;
  final double totalRevenue;

  const StatsModel({
    this.totalServed = 0,
    this.totalCanceled = 0,
    this.avgWaitTimeMin = 0,
    this.avgServiceTimeMin = 0,
    this.totalRevenue = 0,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalServed: (json['total_served'] as num?)?.toInt() ?? 0,
      totalCanceled: (json['total_canceled'] as num?)?.toInt() ?? 0,
      avgWaitTimeMin: (json['avg_wait_time_min'] as num?)?.toDouble() ?? 0,
      avgServiceTimeMin: (json['avg_service_time_min'] as num?)?.toDouble() ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_served': totalServed,
      'total_canceled': totalCanceled,
      'avg_wait_time_min': avgWaitTimeMin,
      'avg_service_time_min': avgServiceTimeMin,
      'total_revenue': totalRevenue,
    };
  }
}
