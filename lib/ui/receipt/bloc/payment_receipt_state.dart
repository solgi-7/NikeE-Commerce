part of 'payment_receipt_bloc.dart';

abstract class PaymentReceiptState extends Equatable {
  const PaymentReceiptState();

  @override
  List<Object> get props => [];
}

class PaymentReceiptLoading extends PaymentReceiptState {}

class PaymentReceiptSuccess extends PaymentReceiptState {
  final PaymentReceiptData paymentReciptData;
  const PaymentReceiptSuccess(this.paymentReciptData);

  @override
  List<Object> get props => [];
}

class PaymentReceiptFailure extends PaymentReceiptState {
  final AppException exception;

  const PaymentReceiptFailure(this.exception);

  @override
  List<Object> get props => [exception];
}