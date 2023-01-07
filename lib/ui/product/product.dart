import 'package:seven_learn_nick/data/favorite_manager.dart';
import 'package:seven_learn_nick/data/product_entity.dart';
import 'package:seven_learn_nick/ui/product/details.dart';
import 'package:seven_learn_nick/ui/widget/image.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// this type of create instans called lazy approche
final favoriteManater = FavoriteManater();

class ProductItem extends StatefulWidget {
  const ProductItem({
    Key? key,
    required this.product,
    required this.borderRadius,
    this.itemWidth = 176,
    this.itemWheight = 189,
  }) : super(key: key);

  final ProductEntity product;
  final BorderRadius borderRadius;

  final double itemWidth;
  final double itemWheight;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    product: widget.product,
                  ))),
          child: SizedBox(
            width: widget.itemWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 0.93,
                      child: ImageLoadingService(
                        imageUrl: widget.product.imageUrl,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    Positioned(
                      right: 8.0,
                      top: 8.0,
                      child: InkWell(
                        onTap: () {
                          if (!favoriteManater.isFavorite(widget.product)) {
                            favoriteManater.addFavprote(widget.product);
                          }else{
                            favoriteManater.delete(widget.product);
                          }
                          setState(() {
                            //
                          });
                        },
                        child: Container(
                          height: 32,
                          width: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            favoriteManater.isFavorite(widget.product) ? CupertinoIcons.heart_fill :CupertinoIcons.heart,
                            size: 20.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.product.title,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.product.priviousPrice.withPriceLabel,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(decoration: TextDecoration.lineThrough),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, top: 4.0),
                  child: Text(
                    widget.product.price.withPriceLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
