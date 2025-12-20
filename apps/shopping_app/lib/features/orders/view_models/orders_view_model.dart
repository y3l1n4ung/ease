import 'package:ease/ease.dart';
import 'package:flutter/widgets.dart';

import '../../cart/models/cart_item.dart';
import '../models/order.dart';
import '../models/orders_state.dart';

part 'orders_view_model.ease.dart';

@ease()
class OrdersViewModel extends StateNotifier<OrdersState> {
  OrdersViewModel() : super(const OrdersState());

  void placeOrder({
    required List<CartItem> items,
    required double totalAmount,
    required ShippingAddress shippingAddress,
  }) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: items,
      totalAmount: totalAmount,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      shippingAddress: shippingAddress,
    );

    state = state.copyWith(
      orders: [order, ...state.orders],
    );
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    final updatedOrders = state.orders.map((order) {
      if (order.id == orderId) {
        return Order(
          id: order.id,
          items: order.items,
          totalAmount: order.totalAmount,
          status: status,
          createdAt: order.createdAt,
          shippingAddress: order.shippingAddress,
        );
      }
      return order;
    }).toList();

    state = state.copyWith(orders: updatedOrders);
  }
}
