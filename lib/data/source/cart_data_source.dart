import 'package:dio/dio.dart';
import 'package:seven_learn_nick/data/add_to_cart_response.dart';
import 'package:seven_learn_nick/data/source/cart_response.dart';

abstract class ICartDataSource {
  Future<AddToCartRespose> add(int productId);
  Future<AddToCartRespose> changeCount(int cartItemId, int count);
  Future<int> count();
  Future<void> delete(int cartItemId);
  Future<CartResponse> getAll();
}

class CartRemoteDataSource implements ICartDataSource {
  final Dio httpClient;

  CartRemoteDataSource(this.httpClient);

  @override
  Future<AddToCartRespose> add(int productId) async {
    final response =
        await httpClient.post('cart/add', data: {"product_id": productId});
    return AddToCartRespose.fromJson(response.data);
  }

  @override
  Future<AddToCartRespose> changeCount(int cartItemId, int count) async {
    final response = await httpClient.post('cart/changeCount',
        data: {"cart_item_id": cartItemId, "count": count});
    return AddToCartRespose.fromJson(response.data);
  }

  @override
  Future<void> delete(int cartItemId) async {
    await httpClient.post('cart/remove', data: {
      'cart_item_id': cartItemId,
    });
  }

  @override
  Future<CartResponse> getAll() async {
    final response = await httpClient.get('cart/list');
    return CartResponse.fromJson(response.data);
  }

  @override
  Future<int> count() async {
    final response = await httpClient.get('cart/count');
    return response.data['count'];
  }
}
