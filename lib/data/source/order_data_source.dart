import 'package:dio/dio.dart';
import 'package:seven_learn_nick/data/order.dart';

abstract class IOrderDataSource {
  Future<CreateOrderResult> create(CreateOrderParams params);
}

class OrderRemoteDataSource implements IOrderDataSource {
  final Dio httpClient;

  OrderRemoteDataSource(this.httpClient);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) async {
    final response = await httpClient.post('order/submit', data: {
      "first_name": params.firstName,
      "last_name": params.lastName,
      "mobile": params.phoneNumber,
      "postal_code": params.postalCode,
      "address": params.address,
      "payment_method": params.paymentMethod == PaymentMethod.online
          ? 'online'
          : 'cash_on_delivery',
    });

    return CreateOrderResult.fromJson(response.data);
  }
}
