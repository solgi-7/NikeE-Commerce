import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seven_learn_nick/common/exceptions.dart';
import 'package:seven_learn_nick/data/payment_receipt.dart';
import 'package:seven_learn_nick/data/repo/order_repository.dart';

part 'payment_receipt_event.dart';
part 'payment_receipt_state.dart';

class PaymentReceiptBloc extends Bloc<PaymentReceiptEvent, PaymentReceiptState> {
  final IOrderRepository repository;
  PaymentReceiptBloc(this.repository) : super(PaymentReceiptLoading()) {
    on<PaymentReceiptEvent>((event, emit) async {
      if (event is PaymentReceiptStarted) {
        try{
          emit(PaymentReceiptLoading());
        final result = await repository.getPaymentReceipt(event.orderId);
        emit(PaymentReceiptSuccess(result));
        }catch(e){
          emit(PaymentReceiptFailure(AppException()));
        }
      }
    });
  }
}
