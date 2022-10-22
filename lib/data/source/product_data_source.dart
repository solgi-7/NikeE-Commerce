import 'package:dio/dio.dart';
import 'package:seven_learn_nick/data/common/http_respose_validator.dart';
import 'package:seven_learn_nick/data/product_entity.dart';

abstract class IProductDataSource {
  Future<List<ProductEntity>> getAll(int sort);
  Future<List<ProductEntity>> search(String searchTerm);
}

class ProductRemoteDataSource with HttpResposeValidator implements IProductDataSource {
  final Dio httpClient ;

  ProductRemoteDataSource(this.httpClient);

  @override
  Future<List<ProductEntity>> getAll(int sort) async {
    final response = await httpClient.get('product/list?sort=$sort');
    validateRespose(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  } 

  @override
  Future<List<ProductEntity>> search(String searchTerm) async {
   final response = await httpClient.get('product/search?q=$searchTerm');
    validateRespose(response);
    final products = <ProductEntity>[];
    (response.data as List).forEach((element) {
      products.add(ProductEntity.fromJson(element));
    });
    return products;
  }

}