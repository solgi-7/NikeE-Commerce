import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:seven_learn_nick/data/repo/order_repository.dart';
import 'package:seven_learn_nick/ui/order/bloc/order_history_bloc.dart';
import 'package:seven_learn_nick/ui/widget/image.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderHistoryBloc(orderRepository)..add(OrderHistoryStarted()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('سوابق سفارش'),
          ),
          body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
            builder: (context, state) {
              if (state is OrderHistorySuccess) {
                final orders = state.orders;
                return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          )
                        ),
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('شناسه سفارش'),
                                Text(order.id.toString()),
                              ],
                            ),
                          ),
                          const Divider(height: 1,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('مبلغ'),
                                Text(order.payablePrice.withPriceLabel.toString()),
                              ],
                            ),
                          ),
                          const Divider(height: 1,),
                          SizedBox(
                            height: 132,
                            child: ListView.builder(
                              itemCount: order.items.length,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                              itemBuilder: (context , index){
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                height: 100,
                                width: 100,   
                                child: ImageLoadingService(
                                  borderRadius: BorderRadius.circular(8),
                                  imageUrl: order.items[index].imageUrl,),                       
                              );
                            }),
                          )
                        ],),
                      );
                    });
              } else if (state is OrderHistoryError) {
                return Center(
                  child: Text(state.exception.message),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          )),
    );
  }
}
