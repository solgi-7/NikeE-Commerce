import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/theme.dart';
import 'package:seven_learn_nick/ui/product/details.dart';
import 'package:seven_learn_nick/ui/product/product.dart';
import 'package:seven_learn_nick/ui/widget/image.dart';

class FavoriteListScreen extends StatelessWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لیست علاقه مندی ها'),
      ),
      body: ValueListenableBuilder<Box<ProductEntity>>(
        valueListenable: favoriteManater.listenable,
        builder: (context, box, child) {
          final products = box.values.toList();
          return ListView.builder(
            itemCount: products.length,
            padding: const EdgeInsets.only(top: 8, bottom: 100),
            itemBuilder: (context, index) {
              final product = products[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(product: product),
                    ),
                  );
                },
                onLongPress: () {
                  favoriteManater.delete(product);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 110,
                        width: 110,
                        child: ImageLoadingService(
                          imageUrl: product.imageUrl,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .apply(
                                      color: LightThemeColors.primeryTextColor,
                                    ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Text(
                                product.priviousPrice.withPriceLabel,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .apply(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                              ),
                              Text(product.price.withPriceLabel),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
