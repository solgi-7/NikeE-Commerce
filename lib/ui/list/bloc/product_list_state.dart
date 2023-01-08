part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();
  
  @override
  List<Object> get props => [];
}

class ProductListLoading extends ProductListState {}
class ProductListSuccess extends ProductListState {
  final List<ProductEntity> products;
  final int sort;
  final List<String> sortName;

  const ProductListSuccess(this.products, this.sort, this.sortName);
  @override
  List<Object> get props => [sort,sortName,products];
}

class ProductListError extends ProductListState {
  final AppException exception;

  const ProductListError(this.exception);
  
  @override
  List<Object> get props => [exception];
}

class ProductListEmpty extends ProductListState {
  final String message;

  const ProductListEmpty(this.message);
  @override
  List<Object> get props => [message];
}