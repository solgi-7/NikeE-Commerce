import 'package:seven_learn_nick/data/add_to_cart_response.dart';
import 'package:seven_learn_nick/data/common/http_client.dart';
import 'package:seven_learn_nick/data/source/cart_data_source.dart';
import 'package:seven_learn_nick/data/source/cart_response.dart';

final cartRepository = CartRepository(CartRemoteDataSource(httpClient));

abstract class ICartRepository extends ICartDataSource {
  // Future<CartResponse> add(int productId);
  // Future<CartResponse> changeCount(int cartItemId,int count);
  // Future<void> delete(int cartItemId);
  // Future<int> count();
  // Future<List<CartItemEntity>> getAll();
}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;

  CartRepository(this.dataSource);

  @override
  Future<AddToCartRespose> add(int productId) => dataSource.add(productId);

  @override
  Future<AddToCartRespose> changeCount(int cartItemId, int count) {
    return dataSource.changeCount(cartItemId, count);
  }

  @override
  Future<void> delete(int cartItemId) {
    return dataSource.delete(cartItemId);
  }

  @override
  Future<CartResponse> getAll() => dataSource.getAll();
}
