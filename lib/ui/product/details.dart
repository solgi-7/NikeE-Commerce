import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/data/repo/cart_repository.dart';
import 'package:seven_learn_nick/theme.dart';
import 'package:seven_learn_nick/ui/product/bloc/product_bloc.dart';
import 'package:seven_learn_nick/ui/product/comment/comment_list.dart';
import 'package:seven_learn_nick/ui/product/comment/insert/insert_commetn_dialog.dart';
import 'package:seven_learn_nick/ui/widget/image.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);
  final ProductEntity product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  StreamSubscription<ProductState>? stateSubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  @override
  void dispose() {
    stateSubscription?.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<ProductBloc>(
        create: (context) {
          final bloc = ProductBloc(cartRepository);
          stateSubscription = bloc.stream.listen((state) {
            if (state is ProductAddToCartSuccess) {
              _scaffoldKey.currentState?.showSnackBar(const SnackBar(
                  content: Text('با موفقیت به سبد خرید شما اضافه شد')));
            } else if (state is ProductAddToCartError) {
              _scaffoldKey.currentState?.showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });
          return bloc;
        },
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: CustomScrollView(
              physics: defualtScrollPhysics,
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.width * 0.8,
                  flexibleSpace:
                      ImageLoadingService(imageUrl: widget.product.imageUrl),
                  foregroundColor: LightThemeColors.primeryTextColor,
                  actions: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.heart))
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              widget.product.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(overflow: TextOverflow.ellipsis),
                              maxLines: 2,
                            )),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              children: [
                                Text(
                                    widget.product.priviousPrice.withPriceLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .apply(
                                            decoration:
                                                TextDecoration.lineThrough)),
                                Text(widget.product.price.withPriceLabel),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text(
                          'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا هیچ فشار مخربی  به پا و زانوان شما انتقال داده شود',
                          style: TextStyle(height: 1.4),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('نظرات کاربران',
                                style: Theme.of(context).textTheme.subtitle1),
                            TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: true,
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                                  builder: (context){
                                  return InsertCommentDialog(productId: widget.product.id ,scaffoldMessengerState: _scaffoldKey.currentState ,);
                                });
                              },
                              child: const Text('ثبت نظر'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                CommentList(productId: widget.product.id),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  return FloatingActionButton.extended(
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(CartAddButtonClick(widget.product.id));
                    },
                    label: state is ProductAddToCartButtonLoading
                        ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Theme.of(context).colorScheme.onSecondary,))
                        : const Text('افزودن به سبد خرید'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
