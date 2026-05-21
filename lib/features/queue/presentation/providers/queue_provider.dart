import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barberku_app/core/core.dart';
import 'package:barberku_app/features/queue/data/datasources/queue_remote_data_source.dart';
import 'package:barberku_app/features/queue/data/repositories/queue_repository_impl.dart';
import 'package:barberku_app/features/queue/domain/repositories/queue_repository.dart';
import 'package:barberku_app/features/queue/domain/usecases/queue_usecases.dart';
import 'package:barberku_app/features/queue/domain/entities/queue_entity.dart';

final queueRemoteDataSourceProvider = Provider<QueueRemoteDataSource>((ref) {
  final wsState = ref.watch(webSocketProvider);
  if (wsState.status != ConnectionStatus.connected) {
    throw Exception('WebSocket not connected');
  }
  return QueueRemoteDataSource();
});

final queueRepositoryProvider = Provider<QueueRepository>((ref) {
  final remoteDataSource = ref.watch(queueRemoteDataSourceProvider);
  return QueueRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getQueueListProvider = Provider<GetQueueList>((ref) {
  final repository = ref.watch(queueRepositoryProvider);
  return GetQueueList(repository);
});

final joinQueueProvider = Provider<JoinQueue>((ref) {
  final repository = ref.watch(queueRepositoryProvider);
  return JoinQueue(repository);
});

final cancelQueueProvider = Provider<CancelQueue>((ref) {
  final repository = ref.watch(queueRepositoryProvider);
  return CancelQueue(repository);
});

final getQueueDetailProvider = Provider<GetQueueDetail>((ref) {
  final repository = ref.watch(queueRepositoryProvider);
  return GetQueueDetail(repository);
});

final watchQueueListUseCaseProvider = Provider<WatchQueueList>((ref) {
  final repository = ref.watch(queueRepositoryProvider);
  return WatchQueueList(repository);
});

final watchQueueListProvider = StreamProvider<List<QueueEntity>>((ref) {
  final useCase = ref.watch(watchQueueListUseCaseProvider);
  return useCase();
});

final queueListStateProvider = StateNotifierProvider<QueueListNotifier, QueueListState>((ref) {
  final repository = ref.watch(queueRepositoryProvider);
  return QueueListNotifier(repository: repository);
});

class QueueListState {
  final List<QueueEntity> queues;
  final bool isLoading;
  final String? error;
  
  const QueueListState({
    this.queues = const [],
    this.isLoading = false,
    this.error,
  });
  
  QueueListState copyWith({
    List<QueueEntity>? queues,
    bool? isLoading,
    String? error,
  }) {
    return QueueListState(
      queues: queues ?? this.queues,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class QueueListNotifier extends StateNotifier<QueueListState> {
  final QueueRepository repository;
  
  QueueListNotifier({required this.repository}) : super(const QueueListState()) {
    _watchQueues();
  }
  
  void _watchQueues() {
    repository.watchQueueList().listen(
      (queues) {
        state = state.copyWith(queues: queues, isLoading: false);
      },
      onError: (error) {
        state = state.copyWith(error: error.toString(), isLoading: false);
      },
    );
  }
  
  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    try {
      final queues = await repository.getQueueList();
      state = state.copyWith(queues: queues, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
