import 'package:json_annotation/json_annotation.dart';

import '../../cart/models/cart_item.dart';

part 'order.g.dart';

enum OrderStatus { pending, processing, shipped, delivered, cancelled }

@JsonSerializable()
class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final ShippingAddress shippingAddress;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class ShippingAddress {
  final String fullName;
  final String address;
  final String city;
  final String zipCode;
  final String phone;

  const ShippingAddress({
    required this.fullName,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ShippingAddressToJson(this);
}
