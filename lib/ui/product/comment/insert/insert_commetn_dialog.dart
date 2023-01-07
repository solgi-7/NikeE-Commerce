import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/data/repo/comment_repository.dart';

import 'bloc/insert_comment_bloc.dart';

class InsertCommentDialog extends StatefulWidget {
  const InsertCommentDialog(
      {Key? key, required this.productId, this.scaffoldMessengerState})
      : super(key: key);
  final int productId;
  final ScaffoldMessengerState? scaffoldMessengerState;
  @override
  State<InsertCommentDialog> createState() => _InsertCommentDialogState();
}

class _InsertCommentDialogState extends State<InsertCommentDialog> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  StreamSubscription? subscription;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = InsertCommentBloc(commentRepostory, widget.productId);
        subscription = bloc.stream.listen((state) {
          if (state is InsertCommentSuccess) {
            widget.scaffoldMessengerState!
                .showSnackBar(SnackBar(content: Text(state.massage)));
            Navigator.of(context, rootNavigator: true).pop();
          } else if (state is InsertCommentError) {
            widget.scaffoldMessengerState!
                .showSnackBar(SnackBar(content: Text(state.exception.message)));
                Navigator.of(context,rootNavigator: true).pop();
          }
        });

        return bloc;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 280,
          child: BlocBuilder<InsertCommentBloc, InsertCommentState>(
            builder: (context, state) {
              return Column(
                children: [
                  Text(
                    'ثبت نظر',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(label: Text('عنوان')),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _content,
                    decoration: const InputDecoration(
                        label: Text('ثبت نظر خود را اینجا وارد کنید')),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<InsertCommentBloc>().add(InsertCommentFormSubmit(_content.text, _title.text));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state is InsertCommentLoading)
                        const CircularProgressIndicator(strokeWidth: 2,color: Colors.white,),
                        const Text('ذخیره'),
                      ],
                    ),
                    style: ButtonStyle(
                      maximumSize: MaterialStateProperty.all(
                        const Size.fromHeight(56),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
