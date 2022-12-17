import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_learn_nick/common/utils.dart';
import 'package:seven_learn_nick/data/cart_item.dart';
import 'package:seven_learn_nick/theme.dart';
import 'package:seven_learn_nick/ui/widget/image.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    Key? key,
    required this.data,
    required this.onDeleteButtonClick,
    required this.onIncreaseButtonClick,
    required this.onDecreaseButtonClick,
  }) : super(key: key);

  final CartItemEntity data;
  final GestureTapCallback onDeleteButtonClick;
  final GestureTapCallback onIncreaseButtonClick;
  final GestureTapCallback onDecreaseButtonClick;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ImageLoadingService(
                    imageUrl: data.product.imageUrl,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data.product.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('تعداد'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: onIncreaseButtonClick,
                          icon: const Icon(CupertinoIcons.plus_rectangle),
                        ),
                        data.changeCountLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  strokeWidth: 2.0,
                                ))
                            : Text(
                                data.count.toString(),
                                style: Theme.of(context).textTheme.headline6,
                              ),
                        IconButton(
                          onPressed: onDecreaseButtonClick,
                          icon: const Icon(CupertinoIcons.minus_rectangle),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.product.priviousPrice.withPriceLabel,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: LightThemeColors.secondryTextColor,
                          decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      data.product.price.withPriceLabel,
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough),
                    ),
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 1,
          ),
          data.deleteButtonLoading
              ? const SizedBox(
                  height: 48,
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  )),
                )
              : TextButton(
                  onPressed: onDeleteButtonClick,
                  child: const Text('حذف از سبد خرید'),
                ),
        ],
      ),
    );
  }
}
