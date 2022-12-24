import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seven_learn_nick/common/exceptions.dart';
import 'package:seven_learn_nick/data/order.dart';
import 'package:seven_learn_nick/data/repo/order_repository.dart';

part 'shipping_event.dart';
part 'shipping_state.dart';

class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final IOrderRepository repository;
  ShippingBloc(this.repository) : super(ShippingInitial()) {
    on<ShippingEvent>(
      (event, emit) async {
        if (event is ShippingCreateOrder) {
          try {
            emit(ShippingLoading());
            final result = await repository.create(event.params);
            emit(ShippingSuccess(result));
          } catch (e) {
            emit(ShippingError(AppException()));
          }
        }
      },
    );
  }
}
