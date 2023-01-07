import 'package:seven_learn_nick/data/product_entity.dart';

class CreateOrderResult {
  final int orderId;
  final String bankGetewayUrl;

  CreateOrderResult(this.orderId, this.bankGetewayUrl);
  CreateOrderResult.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        bankGetewayUrl = json['bank_geteway_url'] ?? '';
}

class CreateOrderParams {
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String postalCode;
  final String address;
  final PaymentMethod paymentMethod;

  CreateOrderParams(
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.postalCode,
    this.address,
    this.paymentMethod,
  );
}

enum PaymentMethod { online, cashOnDelivery}


class OrderEntity {
  final int id;
  final int payablePrice;
  final List<ProductEntity> items;

  OrderEntity(this.id,this.payablePrice,this.items);

  OrderEntity.fromJson(Map<String , dynamic> json) : 
  id = json['id'],
  payablePrice = json['payable'],
  items = (json['order_items'] as List).map((item) => ProductEntity.fromJson(item['product'])).toList();
}