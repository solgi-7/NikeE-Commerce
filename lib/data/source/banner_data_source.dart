import 'package:seven_learn_nick/data/common/http_respose_validator.dart';
import 'package:seven_learn_nick/data/banner_entity.dart';
import 'package:dio/dio.dart';

abstract class IBannerDataSource {
  Future<List<BannerEntity>> getAll();
}

class BannerRemoteDataSource
    with HttpResponseValidator
    implements IBannerDataSource {
  final Dio httpClient;

  const BannerRemoteDataSource(this.httpClient);

  @override
  Future<List<BannerEntity>> getAll() async {
    final response = await httpClient.get('banner/slider');
    validateRespose(response);
    final List<BannerEntity> banners = [];
    (response.data as List).forEach((jsonObject) {
      banners.add(BannerEntity.fromJson(jsonObject));
    });
    return banners;
  }
}
