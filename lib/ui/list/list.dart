// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/data/repo/product_repository.dart';
import 'package:seven_learn_nick/ui/list/bloc/product_list_bloc.dart';
import 'package:seven_learn_nick/ui/product/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key? key, required this.sort}) : super(key: key);
  final int sort;

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

enum ViwType {
  grid,list
}
class _ProductListScreenState extends State<ProductListScreen> {
  ProductListBloc? bloc;
  ViwType viwType = ViwType.grid;

  @override
  void dispose() {
    bloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش های ورزشی'),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          bloc = ProductListBloc(productRepository)
            ..add(ProductListStarted(widget.sort));
          return bloc!;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              final products = state.products;
              return Column(
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color:Theme.of(context).dividerColor)),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          // spreadRadius: 5,
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12))),
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              height: 280,
                              child: Column(
                                children: [
                                  Text(
                                    'انتخاب مرتب سازی',
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: state.sortName.length,
                                        itemBuilder: (context, index) {
                                          final selectedSortIndex = state.sort;
                                          return InkWell(
                                            onTap: () {
                                              bloc!.add(
                                                  ProductListStarted(index));
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0),
                                              child: SizedBox(
                                                height: 32,
                                                child: Row(
                                                  children: [
                                                    Text(state.sortName[index]),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    if (index ==
                                                        selectedSortIndex)
                                                      Icon(
                                                        CupertinoIcons
                                                            .check_mark_circled_solid,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
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
                          Container(
                            width: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  viwType = 
                                  viwType ==  ViwType.grid ? ViwType.list : ViwType.grid;
                                });
                              },
                              icon: const Icon(
                                CupertinoIcons.square_grid_2x2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.60,
                        crossAxisCount: viwType == ViwType.grid ? 2  :  1,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductItem(
                          product: product,
                          borderRadius: BorderRadius.zero,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
