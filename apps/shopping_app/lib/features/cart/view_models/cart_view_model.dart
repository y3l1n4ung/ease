import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/widgets.dart';

import '../../../core/logging/logger.dart';
import '../../products/models/product.dart';
import '../models/cart_item.dart';
import '../models/cart_state.dart';

part 'cart_view_model.ease.dart';

@ease()
class CartViewModel extends StateNotifier<CartState> {
  CartViewModel() : super(const CartState());

  void addToCart(Product product) {
    final existingIndex = state.items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      final existing = updatedItems[existingIndex];
      updatedItems[existingIndex] = existing.copyWith(
        quantity: existing.quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(product: product, quantity: 1),
        ],
      );
    }
  }

  void removeFromCart(int productId) {
    logger.userAction('remove_from_cart', {'productId': productId});
    state = state.copyWith(
      items: state.items.where((item) => item.product.id != productId).toList(),
    );
    logger.info(
      'CART',
      'Removed product $productId, cart now has ${state.itemCount} items',
    );
  }

  void updateQuantity(int productId, int quantity) {
    logger.userAction('update_cart_quantity', {
      'productId': productId,
      'quantity': quantity,
    });

    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
    logger.debug('CART', 'Updated product $productId quantity to $quantity');
  }

  void clearCart() {
    state = const CartState();
  }
}
