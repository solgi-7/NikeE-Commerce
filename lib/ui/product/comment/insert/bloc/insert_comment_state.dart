part of 'insert_comment_bloc.dart';

abstract class InsertCommentState extends Equatable {
  const InsertCommentState();
  
  @override
  List<Object> get props => [];
}

class InsertCommentInitial extends InsertCommentState {}
class InsertCommentLoading extends InsertCommentState {}
class InsertCommentError extends InsertCommentState {
  final AppException exception;
  const InsertCommentError(this.exception);
  @override
  List<Object> get props => [exception];
}

class InsertCommentSuccess extends InsertCommentState {
  final CommentEntity commentEntity;
  final String massage;
  const InsertCommentSuccess(this.commentEntity,this.massage);
  @override
  List<Object> get props => [massage,commentEntity];
}
