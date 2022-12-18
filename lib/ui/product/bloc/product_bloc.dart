import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seven_learn_nick/common/exceptions.dart';
import 'package:seven_learn_nick/data/repo/cart_repository.dart';
part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ICartRepository cartRepository;
  ProductBloc(this.cartRepository) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) async {
      if (event is CartAddButtonClick) {
        try {
          emit(ProductAddToCartButtonLoading());
          await Future.delayed(const Duration(seconds: 2));
          final result = await cartRepository.add(event.productId);
          await cartRepository.count();
          emit(ProductAddToCartSuccess());
        } catch (e) {
          emit(ProductAddToCartError(AppException()));
        }
      }
    });
  }
}
