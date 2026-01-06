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
      setState(
        state.copyWith(
          items: updatedItems,
          notification: CartNotification(
            message: '${product.title} quantity updated',
            type: CartNotificationType.quantityUpdated,
          ),
        ),
        action: 'addToCart:increaseQuantity',
      );
    } else {
      setState(
        state.copyWith(
          items: [
            ...state.items,
            CartItem(product: product, quantity: 1),
          ],
          notification: CartNotification(
            message: '${product.title} added to cart',
            type: CartNotificationType.itemAdded,
          ),
        ),
        action: 'addToCart:newItem',
      );
    }
  }

  void removeFromCart(int productId) {
    logger.userAction('remove_from_cart', {'productId': productId});
    final item = state.items.firstWhere((i) => i.product.id == productId);
    setState(
      state.copyWith(
        items: state.items.where((i) => i.product.id != productId).toList(),
        notification: CartNotification(
          message: '${item.product.title} removed',
          type: CartNotificationType.itemRemoved,
        ),
      ),
      action: 'removeFromCart',
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

    setState(state.copyWith(items: updatedItems), action: 'updateQuantity');
    logger.debug('CART', 'Updated product $productId quantity to $quantity');
  }

  void clearCart() {
    setState(
      const CartState(
        notification: CartNotification(
          message: 'Cart cleared',
          type: CartNotificationType.cleared,
        ),
      ),
      action: 'clearCart',
    );
  }

  /// Clear the notification after showing it
  void clearNotification() {
    setState(state.clearNotification(), action: 'clearNotification');
  }
}
