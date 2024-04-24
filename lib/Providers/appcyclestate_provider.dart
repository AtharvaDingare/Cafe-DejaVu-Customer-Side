import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppCycleStateNotifier extends StateNotifier<bool> {
  AppCycleStateNotifier() : super(true);
  void changeState(bool newState) {
    state = newState;
  }
}

final appCycleStateProvider =
    StateNotifierProvider<AppCycleStateNotifier, bool>(
  (ref) => AppCycleStateNotifier(),
);
