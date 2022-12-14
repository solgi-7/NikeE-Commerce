import 'dart:math';

import 'package:seven_learn_nick/data/product_entity.dart';

class CartItemEntity {
  final ProductEntity product;
  final int id;
  final int count;

  CartItemEntity(this.product, this.id, this.count);
  CartItemEntity.formJson(Map<String, dynamic> json)
      : product = ProductEntity.fromJson(json['product']),
        id = json['cart_item_id'],
        count = json['count'];

  static List<CartItemEntity> parseJsonArray(List<dynamic> jsonArry) {
    final List<CartItemEntity> cartItems = [];
    jsonArry.forEach((element) {
      cartItems.add(CartItemEntity.formJson(element));
    });
    return cartItems;
  }
}
