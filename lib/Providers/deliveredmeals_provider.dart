import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveredMealsNotifier extends StateNotifier<List<dynamic>> {
  DeliveredMealsNotifier() : super([]);
  void addItem(Map<String, dynamic> meal) {
    state = [...state, meal];
  }

  void changeState(List<dynamic> newState) {
    state = newState;
  }
}

final deliveredMealsProvider =
    StateNotifierProvider<DeliveredMealsNotifier, List<dynamic>>(
  (ref) => DeliveredMealsNotifier(),
);
