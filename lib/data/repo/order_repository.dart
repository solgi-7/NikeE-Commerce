import 'package:seven_learn_nick/data/common/http_client.dart';
import 'package:seven_learn_nick/data/order.dart';
import 'package:seven_learn_nick/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository extends IOrderDataSource {}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);

  @override
  Future<CreateOrderResult> create(CreateOrderParams params) =>
      dataSource.create(params);
}
