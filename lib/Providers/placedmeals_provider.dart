import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacedMealsNotifier extends StateNotifier<List<dynamic>> {
  PlacedMealsNotifier() : super([]);
  void addItem(Map<String, dynamic> meal) {
    state = [...state, meal];
  }

  void changeState(List<dynamic> newState) {
    state = newState;
  }
}

final placedMealsProvider =
    StateNotifierProvider<PlacedMealsNotifier, List<dynamic>>(
  (ref) => PlacedMealsNotifier(),
);
