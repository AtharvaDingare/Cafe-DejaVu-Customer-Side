import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartMealsNotifier extends StateNotifier<List<dynamic>> {
  CartMealsNotifier() : super([]);
  void addItem(Map<String, dynamic> meal) {
    state = [...state, meal];
  }

  void changeState(List<dynamic> newState) {
    state = newState;
  }
}

final cartMealsProvider =
    StateNotifierProvider<CartMealsNotifier, List<dynamic>>(
  (ref) => CartMealsNotifier(),
);
