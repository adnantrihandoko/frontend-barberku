import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:barberku_app/features/admin/data/models/service_model.dart';
import 'package:barberku_app/features/admin/data/models/barber_model.dart';
import 'package:barberku_app/features/admin/data/models/settings_model.dart';
import 'package:barberku_app/features/admin/data/models/stats_model.dart';
import 'package:barberku_app/features/auth/presentation/providers/auth_provider.dart';

final adminRemoteDataSourceProvider = Provider<AdminRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AdminRemoteDataSource(dio: dio);
});

final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return dataSource.getServices();
});

final barbersProvider = FutureProvider<List<BarberModel>>((ref) async {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return dataSource.getBarbers();
});

final createServiceProvider = Provider<CreateService>((ref) {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return CreateService(dataSource, ref);
});

final updateServiceProvider = Provider<UpdateService>((ref) {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return UpdateService(dataSource, ref);
});

final deleteServiceProvider = Provider<DeleteService>((ref) {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return DeleteService(dataSource, ref);
});

final createBarberProvider = Provider<CreateBarber>((ref) {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return CreateBarber(dataSource, ref);
});

final updateBarberProvider = Provider<UpdateBarber>((ref) {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return UpdateBarber(dataSource, ref);
});

final deleteBarberProvider = Provider<DeleteBarber>((ref) {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return DeleteBarber(dataSource, ref);
});

final settingsProvider = FutureProvider<SettingsModel>((ref) async {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return dataSource.getSettings();
});

final updateSettingsProvider = Provider<UpdateSettings>((ref) {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return UpdateSettings(dataSource, ref);
});

final statsProvider = FutureProvider<StatsModel>((ref) async {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return dataSource.getStats();
});

class CreateService {
  final AdminRemoteDataSource dataSource;
  final Ref ref;
  CreateService(this.dataSource, this.ref);

  Future<void> call({required String name, required String description, required double price, required int duration}) async {
    await dataSource.createService(name: name, description: description, price: price, duration: duration);
    ref.invalidate(servicesProvider);
  }
}

class UpdateService {
  final AdminRemoteDataSource dataSource;
  final Ref ref;
  UpdateService(this.dataSource, this.ref);

  Future<void> call({required String id, required String name, required String description, required double price, required int duration, required bool isActive}) async {
    await dataSource.updateService(id: id, name: name, description: description, price: price, duration: duration, isActive: isActive);
    ref.invalidate(servicesProvider);
  }
}

class DeleteService {
  final AdminRemoteDataSource dataSource;
  final Ref ref;
  DeleteService(this.dataSource, this.ref);

  Future<void> call(String id) async {
    await dataSource.deleteService(id);
    ref.invalidate(servicesProvider);
  }
}

class CreateBarber {
  final AdminRemoteDataSource dataSource;
  final Ref ref;
  CreateBarber(this.dataSource, this.ref);

  Future<void> call({required String name, required String specialty}) async {
    await dataSource.createBarber(name: name, specialty: specialty);
    ref.invalidate(barbersProvider);
  }
}

class UpdateBarber {
  final AdminRemoteDataSource dataSource;
  final Ref ref;
  UpdateBarber(this.dataSource, this.ref);

  Future<void> call({required String id, required String name, required String specialty, required bool isActive}) async {
    await dataSource.updateBarber(id: id, name: name, specialty: specialty, isActive: isActive);
    ref.invalidate(barbersProvider);
  }
}

class DeleteBarber {
  final AdminRemoteDataSource dataSource;
  final Ref ref;
  DeleteBarber(this.dataSource, this.ref);

  Future<void> call(String id) async {
    await dataSource.deleteBarber(id);
    ref.invalidate(barbersProvider);
  }
}

class UpdateSettings {
  final AdminRemoteDataSource dataSource;
  final Ref ref;
  UpdateSettings(this.dataSource, this.ref);

  Future<void> call({required int openHour, required int closeHour, required int maxQueueSize}) async {
    await dataSource.updateSettings(openHour: openHour, closeHour: closeHour, maxQueueSize: maxQueueSize);
    ref.invalidate(settingsProvider);
  }
}
