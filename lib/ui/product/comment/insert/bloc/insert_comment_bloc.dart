import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seven_learn_nick/common/exceptions.dart';
import 'package:seven_learn_nick/data/comment.dart';
import 'package:seven_learn_nick/data/repo/auth_reposityory.dart';
import 'package:seven_learn_nick/data/repo/comment_repository.dart';

part 'insert_comment_event.dart';
part 'insert_comment_state.dart';

class InsertCommentBloc extends Bloc<InsertCommentEvent, InsertCommentState> {
  final int productId;
  final ICommentRepository commentRepository;
  InsertCommentBloc(this.commentRepository, this.productId)
      : super(InsertCommentInitial()) {
    on<InsertCommentEvent>((event, emit) async {
      if (event is InsertCommentFormSubmit) {
        if (!AuthRepository.isUserLoggedIn()){
          emit(InsertCommentError(AppException(message: 'لطفا وارد حساب کاربری خود شوید')));
        }else{
           if (event.title.isNotEmpty && event.content.isNotEmpty) {
          try {
            emit(InsertCommentLoading());
            final comment = await commentRepository.insert(
              event.title,
              event.content,
              productId,
            );
            emit(InsertCommentSuccess(comment,'نظر شما با موفقیت ثبت شد و پس از تایید منتشر خواهد شد'));
          } catch (e) {
            emit(InsertCommentError(AppException()));
          }
        
        }
       }
      }else {
        emit (InsertCommentError(AppException(message: 'عنوان و متن نظر خود را وارد کنید')));
      }
    });
  }
}
