import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/data/comment.dart';
import 'package:seven_learn_nick/data/repo/comment_repository.dart';
import 'package:seven_learn_nick/ui/comment/bloc/comment_list_bloc.dart';
import 'package:seven_learn_nick/ui/comment/comment.dart';
import 'package:seven_learn_nick/ui/widget/error.dart';

class CommentList extends StatelessWidget {
  final int productId;
  const CommentList({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final CommentListBloc bloc =
            CommentListBloc(repository: commentRepostory, productId: productId);
        bloc.add(CommentListStarted());
        return bloc;
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
          builder: (BuildContext context, state) {
        if (state is CommentListSuccess) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return CommentItem(
              comment: state.comments[index],
            );
          }, childCount: state.comments.length));
        } else if (state is CommentListLoading) {
          return const SliverToBoxAdapter(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is CommentListError) {
          return SliverToBoxAdapter(
            child: AppErrorWidget(
              exception: state.exception,
              onPressed: () {
                BlocProvider.of<CommentListBloc>(context)
                    .add(CommentListStarted());
              },
            ),
          );
        } else {
          throw Exception('state is not supported');
        }
      }),
    );
  }
}
