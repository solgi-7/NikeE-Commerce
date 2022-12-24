import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:seven_learn_nick/data/repo/order_repository.dart';
import 'package:seven_learn_nick/theme.dart';

import 'bloc/payment_receipt_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;
  const PaymentReceiptScreen({Key? key,required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('رسید پرداخت'),
        ),
        body: BlocProvider<PaymentReceiptBloc>(
          create: (context) => PaymentReceiptBloc(orderRepository)..add(PaymentReceiptStarted(orderId)),
          child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
            builder: (context, state) {
              if (state is PaymentReceiptSuccess) {
                  return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: themeData.dividerColor, width: 1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          state.paymentReciptData.purchaseSuccess ? 'پرداخت با موفقیت انجام شد' : 'پرداخت ناموفق',
                          style: themeData.textTheme.headline6!
                              .apply(color: themeData.colorScheme.primary),
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'وضعیت سفارش',
                              style: TextStyle(
                                color: LightThemeColors.secondryTextColor,
                              ),
                            ),
                            Text(
                              state.paymentReciptData.paymentStatus,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:  [
                            const Text(
                              'مبلغ',
                              style: TextStyle(
                                color: LightThemeColors.secondryTextColor,
                              ),
                            ),
                            Text(
                              state.paymentReciptData.payablePrice.withPriceLabel,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('بازگشت به صفحه اصلی'),
                  ),
                ],
              );
              }else if (state is PaymentReceiptFailure){
                return Center(child: Text(state.exception.message),);
              }else if (state is PaymentReceiptLoading) {
                return const Center(child: CircularProgressIndicator(),);
              }else {
                throw Exception('state in not supported');
              }
             },
          ),
        ));
  }
}
