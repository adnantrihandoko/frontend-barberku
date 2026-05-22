class SettingsModel {
  final int openHour;
  final int closeHour;
  final int maxQueueSize;

  const SettingsModel({
    this.openHour = 9,
    this.closeHour = 21,
    this.maxQueueSize = 50,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      openHour: (json['open_hour'] as num?)?.toInt() ?? 9,
      closeHour: (json['close_hour'] as num?)?.toInt() ?? 21,
      maxQueueSize: (json['max_queue_size'] as num?)?.toInt() ?? 50,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'open_hour': openHour,
      'close_hour': closeHour,
      'max_queue_size': maxQueueSize,
    };
  }
}
