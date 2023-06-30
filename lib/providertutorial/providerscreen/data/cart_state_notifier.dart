import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providerModels/product.dart';

final cartStateNotifierProvider =
    StateNotifierProvider.autoDispose<CartStateNotifier, List<Product>>((ref) {
  return CartStateNotifier();
});

class CartStateNotifier extends StateNotifier<List<Product>> {
  CartStateNotifier() : super([]);

  void addProduct(Product product) {
    state = [...state, product];
  }

  void removeProduct(Product product) {
    state = state.where((p) => p != product).toList();
  }

  void clearCart() {
    state = [];
  }
}
