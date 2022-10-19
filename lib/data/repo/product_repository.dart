

import 'package:seven_learn_nick/data/product.dart';

abstract class IProductRepository {
  Future<List<ProductEntity>> getAll(int sort);
}