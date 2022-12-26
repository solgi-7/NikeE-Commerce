import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/data/order.dart';
import 'package:seven_learn_nick/data/repo/order_repository.dart';
import 'package:seven_learn_nick/ui/cart/price_info.dart';
import 'package:seven_learn_nick/ui/payment_webview.dart';
import 'package:seven_learn_nick/ui/receipt/payment_receipt.dart';
import 'package:seven_learn_nick/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({
    Key? key,
    required this.payablePrice,
    required this.shippingCost,
    required this.totalPrice,
  }) : super(key: key);
  final int payablePrice;
  final int shippingCost;
  final int totalPrice;

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController firstNameController =
      TextEditingController(text: 'صادق');

  final TextEditingController lastNameController =
      TextEditingController(text: 'سلگی');

  final TextEditingController phoneNumberController =
      TextEditingController(text: '09303994714');

  final TextEditingController postalCodeController =
      TextEditingController(text: '1080116107');

  final TextEditingController addressController =
      TextEditingController(text: 'انتهای خیابان شهید تهرانی مقدم');

  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گیرنده'),
        centerTitle: false,
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository);
          subscription = bloc.stream.listen((state) {
            if (state is ShippingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.appException.message)));
            } else if (state is ShippingSuccess) {
              if (state.result.bankGetewayUrl.isNotEmpty){
                //  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentGateWayScreen(backGatewayUrl: state.result.bankGetewayUrl,),));   
              }else{
                 Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentReceiptScreen(orderId: state.result.orderId,)));
              }
            }
          },
          );
          return bloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(label: Text('نام')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(label: Text('نام خانوادگی')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(label: Text('شماره تماس')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(label: Text('کدپستی')),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(label: Text('آدرس')),
              ),
              const SizedBox(
                height: 12,
              ),
              PriceInfo(
                payablePrice: widget.payablePrice,
                shippingCost: widget.shippingCost,
                totalPrice: widget.totalPrice,
              ),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  return state is ShippingLoading
                      ? const Center(
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              OutlinedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                  ShippingCreateOrder(
                                    CreateOrderParams(
                                      firstNameController.text,
                                      lastNameController.text,
                                      phoneNumberController.text,
                                      postalCodeController.text,
                                      addressController.text,
                                      PaymentMethod.cashOnDelivery,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('پرداخت در محل'),
                            ),
                          const SizedBox(
                              width: 16,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<ShippingBloc>(context).add(
                                  ShippingCreateOrder(
                                    CreateOrderParams(
                                      firstNameController.text,
                                      lastNameController.text,
                                      phoneNumberController.text,
                                      postalCodeController.text,
                                      addressController.text,
                                      PaymentMethod.online,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('پرداخت اینترنتی'),
                            ),
                            ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
