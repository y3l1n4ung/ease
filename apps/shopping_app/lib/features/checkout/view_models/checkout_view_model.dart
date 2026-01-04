import 'package:ease_annotation/ease_annotation.dart';
import 'package:ease_state_helper/ease_state_helper.dart';
import 'package:flutter/widgets.dart';

import '../../cart/models/cart_item.dart';
import '../../orders/models/order.dart';
import '../models/checkout_state.dart';

part 'checkout_view_model.ease.dart';

@ease()
class CheckoutViewModel extends StateNotifier<CheckoutState> {
  CheckoutViewModel() : super(const CheckoutState());

  void updateShippingAddress(ShippingAddress address) {
    state = state.copyWith(shippingAddress: address);
  }

  Future<String?> processCheckout(List<CartItem> items, double totalAmount) async {
    if (state.shippingAddress == null) {
      state = state.copyWith(
        status: CheckoutStatus.error,
        errorMessage: 'Please enter shipping address',
      );
      return null;
    }

    state = state.copyWith(status: CheckoutStatus.processing);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final orderId = DateTime.now().millisecondsSinceEpoch.toString();

    state = state.copyWith(
      status: CheckoutStatus.success,
      orderId: orderId,
    );

    return orderId;
  }

  void reset() {
    state = const CheckoutState();
  }
}
