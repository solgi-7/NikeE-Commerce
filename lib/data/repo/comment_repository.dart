import 'package:seven_learn_nick/data/common/http_client.dart';
import 'package:seven_learn_nick/data/source/comment_data_source.dart';
import 'package:seven_learn_nick/data/comment.dart';

final commentRepostory =
    CommentRepostory(dataSource: CommentRemoteDataSource(httpClient));
  

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});
  Future<CommentEntity> insert(String title,String content, int productId);
}

class CommentRepostory extends ICommentRepository {
  final ICommentDataSource dataSource;

  CommentRepostory({required this.dataSource});
  @override
  Future<List<CommentEntity>> getAll({required int productId}) =>
      dataSource.getAll(productId: productId);

  @override
  Future<CommentEntity> insert(String title, String content, int productId) => dataSource.insert(title, content, productId);
}
