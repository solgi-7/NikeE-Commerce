import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/theme.dart';
import 'package:seven_learn_nick/ui/comment/comment_list.dart';
import 'package:seven_learn_nick/ui/widget/image.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);
  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          physics: defualtScrollPhysics,
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.width * 0.8,
              flexibleSpace: ImageLoadingService(imageUrl: product.imageUrl),
              foregroundColor: LightThemeColors.primeryTextColor,
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(CupertinoIcons.heart))
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
                          product.title,
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
                            Text(product.priviousPrice.withPriceLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(
                                        decoration:
                                            TextDecoration.lineThrough)),
                            Text(product.price.withPriceLabel),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                        'این کتونی شدیدا برای دویدن و راه رفتن مناسب هست و تقریبا هیچ فشار مخربی  به پا و زانوان شما انتقال داده شود'),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('نظرات کاربران',
                            style: Theme.of(context).textTheme.subtitle1),
                        TextButton(
                          onPressed: () {},
                          child: const Text('ثبت نظر'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CommentList(productId: product.id),

          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width - 50,
          child: FloatingActionButton.extended(
            onPressed: () {},
            label: const Text('افزودن به سبد خرید'),
          ),
        ),
      ),
    );
  }
}
