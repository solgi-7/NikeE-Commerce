import 'package:seven_learn_nick/data/source/banner_data_source.dart';
import 'package:seven_learn_nick/data/common/http_client.dart';
import 'package:seven_learn_nick/data/banner_entity.dart';

final banerRepository = BannerRepository(BannerRemoteDataSource(httpClient));

abstract class IBannerRepository {
  Future<List<BannerEntity>> getAll();
}

class BannerRepository implements IBannerRepository {
  final IBannerDataSource dataSource;

  BannerRepository(this.dataSource);

  @override
  Future<List<BannerEntity>> getAll() => dataSource.getAll();
}
