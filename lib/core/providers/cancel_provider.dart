import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barberku_app/core/constants/app_constants.dart';

class CancelState {
  final int todayCancelCount;
  final DateTime? lastCancelDate;
  final DateTime? cooldownUntil;
  
  const CancelState({
    this.todayCancelCount = 0,
    this.lastCancelDate,
    this.cooldownUntil,
  });
  
  bool get canCancel => todayCancelCount < 2 && !isInCooldown;
  
  bool get isInCooldown {
    if (cooldownUntil == null) return false;
    return DateTime.now().isBefore(cooldownUntil!);
  }
  
  int get remainingCancels => 2 - todayCancelCount;
  
  CancelState copyWith({
    int? todayCancelCount,
    DateTime? lastCancelDate,
    DateTime? cooldownUntil,
  }) {
    return CancelState(
      todayCancelCount: todayCancelCount ?? this.todayCancelCount,
      lastCancelDate: lastCancelDate ?? this.lastCancelDate,
      cooldownUntil: cooldownUntil ?? this.cooldownUntil,
    );
  }
  
  CancelState resetIfNewDay() {
    final now = DateTime.now();
    if (lastCancelDate != null && 
        lastCancelDate!.day != now.day &&
        lastCancelDate!.month == now.month &&
        lastCancelDate!.year == now.year) {
      return CancelState();
    }
    return this;
  }
}

class CancelNotifier extends StateNotifier<CancelState> {
  CancelNotifier() : super(const CancelState()) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(AppConstants.keyCancelCount) ?? 0;
    final lastCancelStr = prefs.getString(AppConstants.keyLastCancelDate);
    final cooldownStr = prefs.getString(AppConstants.keyCooldownUntil);
    
    DateTime? lastCancelDate;
    if (lastCancelStr != null) {
      lastCancelDate = DateTime.parse(lastCancelStr);
    }
    
    DateTime? cooldownUntil;
    if (cooldownStr != null) {
      cooldownUntil = DateTime.parse(cooldownStr);
    }
    
    var newState = CancelState(
      todayCancelCount: count,
      lastCancelDate: lastCancelDate,
      cooldownUntil: cooldownUntil,
    );
    
    newState = newState.resetIfNewDay();
    state = newState;
  }

  Future<bool> cancelQueue(String queueId) async {
    if (!state.canCancel) {
      return false;
    }
    
    final newCount = state.todayCancelCount + 1;
    final now = DateTime.now();
    final cooldownUntil = now.add(const Duration(minutes: 15));
    
    final newState = state.copyWith(
      todayCancelCount: newCount,
      lastCancelDate: now,
      cooldownUntil: cooldownUntil,
    );
    
    state = newState;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.keyCancelCount, newCount);
    await prefs.setString(AppConstants.keyLastCancelDate, now.toIso8601String());
    await prefs.setString(AppConstants.keyCooldownUntil, cooldownUntil.toIso8601String());
    
    return true;
  }
  
  Future<void> reset() async {
    state = const CancelState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyCancelCount);
    await prefs.remove(AppConstants.keyLastCancelDate);
    await prefs.remove(AppConstants.keyCooldownUntil);
  }
}

final cancelProvider = StateNotifierProvider<CancelNotifier, CancelState>((ref) {
  return CancelNotifier();
});
