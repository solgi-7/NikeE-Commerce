import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/data/repo/product_repository.dart';
import 'package:seven_learn_nick/ui/list/bloc/product_list_bloc.dart';
import 'package:seven_learn_nick/ui/product/product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({Key? key, required this.sort}) : super(key: key);
  final int sort;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('کفش های ورزشی'),
        ),
        body: BlocProvider<ProductListBloc>(
          create: (context) =>
              ProductListBloc(productRepository)..add(ProductListStarted(sort)),
          child: BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListSuccess) {
                final products = state.products;
                return Column(
                  children: [
                    Container(
                      height: 56,                    
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          // spreadRadius: 5,
                        )
                      ]),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(CupertinoIcons.sort_down),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('مرتب سازی'),
                                      Text(
                                        ProductSort.names[state.sort],
                                        style:
                                            Theme.of(context).textTheme.caption,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(CupertinoIcons.square_grid_2x2))
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 0.60),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductItem(
                                product: product,
                                borderRadius: BorderRadius.zero);
                          }),
                    ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }
}
