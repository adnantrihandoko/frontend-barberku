class AppConstants {
  AppConstants._();

  static const String appName = 'BarberKu';
  
  // API Configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  static const String wsUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://localhost:8080/ws',
  );
  
  // API Endpoints
  static const String apiQueue = '/api/v1/queue';
  static const String apiAuth = '/api/v1/auth';
  static const String apiServices = '/api/v1/services';
  static const String apiBarbers = '/api/v1/barbers';
  static const String apiHistory = '/api/v1/history';
  static const String apiSettings = '/api/v1/settings';
  static const String apiStats = '/api/v1/stats';
  
  // WebSocket Events
  static const String wsEventQueueUpdate = 'queue_update';
  static const String wsEventCalled = 'called';
  static const String wsEventCanceled = 'canceled';
  
  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyThemeMode = 'theme_mode';
  static const String keyCancelCount = 'cancel_count';
  static const String keyLastCancelDate = 'last_cancel_date';
  static const String keyCooldownUntil = 'cooldown_until';
  
  // Animation Durations
  static const Duration animationShort = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationLong = Duration(milliseconds: 500);
  
  // Pagination
  static const int defaultPageSize = 20;
  
  // Queue Status
  static const String queueStatusWaiting = 'waiting';
  static const String queueStatusCalled = 'called';
  static const String queueStatusInProgress = 'in_progress';
  static const String queueStatusCompleted = 'completed';
  static const String queueStatusCanceled = 'canceled';
  static const String queueStatusSkipped = 'skipped';
  
  // User Roles
  static const String roleCustomer = 'customer';
  static const String roleAdmin = 'admin';
  static const String roleBarber = 'barber';
}
