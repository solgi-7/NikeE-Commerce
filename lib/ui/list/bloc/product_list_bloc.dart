import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seven_learn_nick/common/exceptions.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/data/repo/product_repository.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final IProductRepository repository;
  ProductListBloc(this.repository) : super(ProductListLoading()) {
    on<ProductListEvent>((event, emit) async {
      if (event is ProductListStarted) {
        emit(ProductListLoading());
        try {
          final products = event.searchTerm.isEmpty ? await repository.getAll(event.sort) : await repository.search(event.searchTerm);
          if (products.isNotEmpty){
            emit(ProductListSuccess(products, event.sort, ProductSort.names));
          }else{
            emit(const ProductListEmpty('محصولی مشابه عبارت مورد جستجوی شما یافت نشد'));
          }
        } catch (e) {
          emit(ProductListError(AppException()));
        }
      }
    });
  }
}
