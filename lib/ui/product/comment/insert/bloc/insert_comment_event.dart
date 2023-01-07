part of 'insert_comment_bloc.dart';

abstract class InsertCommentEvent extends Equatable {
  const InsertCommentEvent();

  @override
  List<Object> get props => [];
}

class InsertCommentFormSubmit extends InsertCommentEvent {
  final String title;
  final String content;

  const InsertCommentFormSubmit(this.content,this.title);
  @override
  List<Object> get props => [title,content];
}